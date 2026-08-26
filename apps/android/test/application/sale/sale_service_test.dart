import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/application/sale/sale_service.dart';
import 'package:songjog/data/local/in_memory_store.dart';
import 'package:songjog/data/repositories/business_repository.dart';
import 'package:songjog/domain/models/business_profile.dart';
import 'package:songjog/domain/models/transaction.dart';
import 'package:songjog/domain/services/diagnostic_collector.dart';

class _ThrowingRepo implements BusinessRepository {
  @override
  Future<void> saveProfile(BusinessProfile profile) async =>
      throw StateError('disk failure');

  @override
  Future<BusinessProfile?> getProfile() async => null;

  @override
  Future<void> saveTransaction(TransactionRecord transaction) async =>
      throw StateError('disk failure');

  @override
  Future<List<TransactionRecord>> getTransactions() async => const [];
}

void main() {
  group('takaToMinor', () {
    test('parses whole taka', () {
      expect(takaToMinor('850'), 85000);
      expect(takaToMinor('0'), 0);
      expect(takaToMinor('  12 '), 1200);
    });

    test('parses fractional taka exactly', () {
      expect(takaToMinor('3.50'), 350);
      expect(takaToMinor('3.5'), 350);
      expect(takaToMinor('0.05'), 5);
      expect(takaToMinor('0.5'), 50);
    });

    test('respects the 12-digit integer bound', () {
      expect(takaToMinor('123456789012'), 12345678901200);
      expect(() => takaToMinor('1234567890123'), throwsFormatException);
    });

    test('rejects malformed or negative amounts', () {
      for (final bad in [
        '',
        '   ',
        'abc',
        '-5',
        '1.234',
        '.',
        '.5',
        '1.2.3',
        '১২৩',
      ]) {
        expect(
          () => takaToMinor(bad),
          throwsFormatException,
          reason: 'should reject: "$bad"',
        );
      }
    });
  });

  group('minorToTaka', () {
    test('formats whole and fractional amounts', () {
      expect(minorToTaka(85000), '850');
      expect(minorToTaka(350), '3.50');
      expect(minorToTaka(5), '0.05');
      expect(minorToTaka(0), '0');
      expect(minorToTaka(123456789), '1234567.89');
      expect(minorToTaka(-250), '-2.50');
    });
  });

  group('derivePaymentStatus', () {
    test('derives unpaid, partial and paid', () {
      expect(
        derivePaymentStatus(totalMinor: 10000, paidMinor: 0),
        PaymentStatus.unpaid,
      );
      expect(
        derivePaymentStatus(totalMinor: 10000, paidMinor: 4000),
        PaymentStatus.partial,
      );
      expect(
        derivePaymentStatus(totalMinor: 10000, paidMinor: 10000),
        PaymentStatus.paid,
      );
    });

    test('zero total is never paid', () {
      expect(
        derivePaymentStatus(totalMinor: 0, paidMinor: 0),
        PaymentStatus.unpaid,
      );
    });
  });

  group('clampPaid', () {
    test('clamps into [0, total]', () {
      expect(clampPaid(30000, 100000), 30000);
      expect(clampPaid(-5, 100000), 0);
      expect(clampPaid(200000, 100000), 100000);
    });
  });

  group('SaleEntryService.saveSale', () {
    late InMemoryStore store;
    late DiagnosticCollector collector;
    late SaleEntryService service;

    setUp(() {
      store = InMemoryStore();
      collector = DiagnosticCollector();
      service = SaleEntryService(DefaultBusinessRepository(store), collector);
    });

    test('persists a paid single-line sale', () async {
      final record = await service.saveSale(
        lines: [(description: 'Mouse', quantity: 1, priceMinor: 85000)],
        paidMinor: 85000,
        paymentMethod: PaymentMethod.cash,
      );

      expect(record.paymentStatus, PaymentStatus.paid);
      expect(record.paidMinor, 85000);
      expect(record.paymentMethod, PaymentMethod.cash);

      final stored = await store.loadTransactions();
      expect(stored, hasLength(1));
      expect(stored.single.lines.single.description, 'Mouse');
      expect(stored.single.totalMinor, 85000);

      final events = collector.events.where(
        (e) => e.operation == 'transaction_save' && e.level == 'info',
      );
      expect(events, hasLength(1));
    });

    test('multi-line totals are summed', () async {
      final record = await service.saveSale(
        lines: [
          (description: 'Mouse', quantity: 1, priceMinor: 85000),
          (description: 'Windows setup', quantity: 1, priceMinor: 80000),
          (description: 'Printing', quantity: 50, priceMinor: 300),
        ],
        paidMinor: 100000,
      );

      expect(record.totalMinor, 175000);
      expect(record.dueMinor, 75000);
      expect(record.paymentStatus, PaymentStatus.partial);
    });

    test('overpayment is clamped, never stored beyond the total', () async {
      final record = await service.saveSale(
        lines: [(description: 'Mouse', quantity: 1, priceMinor: 85000)],
        paidMinor: 90000,
      );
      expect(record.paidMinor, 85000);
      expect(record.paymentStatus, PaymentStatus.paid);
    });

    test('zero payment is unpaid', () async {
      final record = await service.saveSale(
        lines: [(description: 'Mouse', quantity: 1, priceMinor: 85000)],
      );
      expect(record.paidMinor, 0);
      expect(record.paymentStatus, PaymentStatus.unpaid);
    });

    test('empty lines are rejected', () async {
      expect(() => service.saveSale(lines: const []), throwsArgumentError);
    });

    test('a failing store records the error and rethrows', () async {
      final failing = SaleEntryService(_ThrowingRepo(), collector);
      expect(
        () => failing.saveSale(
          lines: [(description: 'Mouse', quantity: 1, priceMinor: 85000)],
        ),
        throwsStateError,
      );
      final errors = collector.events.where(
        (e) => e.operation == 'transaction_save' && e.level == 'error',
      );
      expect(errors, hasLength(1));
    });
  });
}
