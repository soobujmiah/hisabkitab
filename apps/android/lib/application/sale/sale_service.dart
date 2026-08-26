import '../../data/repositories/business_repository.dart';
import '../../domain/models/transaction.dart';
import '../../domain/services/diagnostic_collector.dart';

/// Exact BDT taka (string) to minor-unit (paisa, integer) conversion.
///
/// Persisted money is always integer minor units. UI input arrives as a plain
/// decimal string ("850", "3.50"); parsing is string/integer based so no
/// floating point ever touches money (see docs/FINANCIAL_MODEL.md §9).
///
/// Only non-negative amounts are supported here; sale entry does not accept
/// negatives.
int takaToMinor(String raw) {
  final text = raw.trim();
  final match = RegExp(r'^(\d{1,12})(?:\.(\d{1,2}))?$').firstMatch(text);
  if (match == null) {
    throw FormatException('Invalid amount: $raw');
  }
  final whole = int.parse(match.group(1)!);
  final frac = match.group(2) == null
      ? 0
      : int.parse(match.group(2)!.padRight(2, '0'));
  return whole * 100 + frac;
}

/// Deterministic display for a minor-unit value: integer part always,
/// fractional part trimmed (85000 → "850", 350 → "3.50", 5 → "0.05").
String minorToTaka(int minor) {
  final negative = minor < 0;
  final abs = negative ? -minor : minor;
  final whole = abs ~/ 100;
  final frac = abs % 100;
  final text = frac == 0
      ? '$whole'
      : (frac < 10 ? '$whole.0$frac' : '$whole.$frac');
  return negative ? '-$text' : text;
}

/// Payment status derived from total and received amount.
PaymentStatus derivePaymentStatus({
  required int totalMinor,
  required int paidMinor,
}) {
  if (totalMinor <= 0 || paidMinor <= 0) return PaymentStatus.unpaid;
  if (paidMinor >= totalMinor) return PaymentStatus.paid;
  return PaymentStatus.partial;
}

/// Clamps a received amount into `[0, total]` (exact int math): a payment
/// can never silently exceed the applicable balance.
int clampPaid(int paidMinor, int totalMinor) =>
    paidMinor < 0 ? 0 : (paidMinor > totalMinor ? totalMinor : paidMinor);

/// Builds and persists sale transactions from completed entry lines.
class SaleEntryService {
  const SaleEntryService(this._repository, this._diagnostics);

  final BusinessRepository _repository;
  final DiagnosticCollector? _diagnostics;

  /// Persists a sale. The received amount is clamped into `[0, total]` so a
  /// payment can never silently exceed the applicable balance.
  Future<TransactionRecord> saveSale({
    required List<({String description, double quantity, int priceMinor})> lines,
    int paidMinor = 0,
    PaymentMethod? paymentMethod,
  }) async {
    if (lines.isEmpty) {
      throw ArgumentError('A sale needs at least one line.');
    }
    final now = DateTime.now();
    final recordLines = [
      for (var i = 0; i < lines.length; i++)
        TransactionLine(
          id: '${now.microsecondsSinceEpoch}-$i',
          description: lines[i].description,
          quantity: lines[i].quantity,
          sellingPriceMinor: lines[i].priceMinor,
        ),
    ];
    final total = recordLines.fold<int>(
      0,
      (sum, line) => sum + line.lineTotalMinor,
    );
    final clamped = clampPaid(paidMinor, total);
    final record = TransactionRecord(
      id: now.microsecondsSinceEpoch.toString(),
      type: TransactionType.sale,
      createdAt: now,
      lines: recordLines,
      paymentMethod: paymentMethod,
      paidMinor: clamped,
      paymentStatus: derivePaymentStatus(totalMinor: total, paidMinor: clamped),
    );
    try {
      await _repository.saveTransaction(record);
      _diagnostics?.record(
        level: 'info',
        category: 'transaction',
        operation: 'transaction_save',
        message: 'sale saved',
        details: {
          'lines': record.lines.length,
          'total_minor': total,
          'paid_minor': clamped,
          'payment_status': record.paymentStatus.name,
        },
      );
    } catch (error, stack) {
      _diagnostics?.record(
        level: 'error',
        category: 'transaction',
        operation: 'transaction_save',
        message: 'sale save failed',
        error: error.toString(),
        stackTrace: stack.toString(),
      );
      rethrow;
    }
    return record;
  }
}
