import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/data/local/in_memory_store.dart';
import 'package:songjog/domain/models/business_profile.dart';
import 'package:songjog/domain/models/transaction.dart';
import 'package:songjog/domain/services/user_data_export.dart';

void main() {
  test('exports profile and transactions within the requested range', () async {
    final store = InMemoryStore();
    await store.saveBusinessProfile(const BusinessProfile(
      id: 'p1',
      name: 'Demo',
      workspaceKind: WorkspaceKind.business,
      businessType: BusinessType.retail,
    ));
    await store.saveTransaction(TransactionRecord(
      id: 't1',
      type: TransactionType.sale,
      createdAt: DateTime(2026, 8, 10),
      lines: const [
        TransactionLine(
          id: 'l1',
          description: 'Item',
          quantity: 1,
          sellingPriceMinor: 1000,
        ),
      ],
    ));
    await store.saveTransaction(TransactionRecord(
      id: 't2',
      type: TransactionType.expense,
      createdAt: DateTime(2026, 8, 20),
      lines: const [
        TransactionLine(
          id: 'l2',
          description: 'Expense',
          quantity: 1,
          sellingPriceMinor: 500,
        ),
      ],
    ));

    final json = await UserDataExport.toJson(
      store: store,
      start: DateTime(2026, 8, 15),
    );

    expect(json, contains('Demo'));
    expect(json, contains('t2'));
    expect(json, isNot(contains('t1')));
    expect(json, contains('transaction_lines'));
  });
}
