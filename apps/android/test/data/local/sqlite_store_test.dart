import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:songjog/data/local/sqlite_store.dart';
import 'package:songjog/domain/models/business_profile.dart';
import 'package:songjog/domain/models/transaction.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Directory tempDirectory;
  late SqliteStore store;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('songjog_sqlite_');
    store = await SqliteStore.open(
      databasePath: '${tempDirectory.path}/songjog_test.db',
      factory: databaseFactoryFfiNoIsolate,
    );
  });

  tearDown(() async {
    await store.close();
    await tempDirectory.delete(recursive: true);
  });

  test('persists business profile across store reopen', () async {
    const profile = BusinessProfile(
      id: 'business-1',
      name: 'Test Business',
      workspaceKind: WorkspaceKind.business,
      businessType: BusinessType.retail,
    );

    await store.saveBusinessProfile(profile);
    await store.close();

    store = await SqliteStore.open(
      databasePath: '${tempDirectory.path}/songjog_test.db',
      factory: databaseFactoryFfiNoIsolate,
    );
    expect(await store.loadBusinessProfile(), profile);
  });

  test('persists multi-line transaction and private cost', () async {
    final transaction = TransactionRecord(
      id: 'sale-1',
      type: TransactionType.sale,
      createdAt: DateTime(2026, 8, 26, 10),
      paymentStatus: PaymentStatus.paid,
      paymentMethod: PaymentMethod.cash,
      paidMinor: 15000,
      lines: const [
        TransactionLine(
          id: 'line-1',
          description: 'Product A',
          quantity: 2,
          sellingPriceMinor: 5000,
          actualCostMinor: 3500,
        ),
        TransactionLine(
          id: 'line-2',
          description: 'Service B',
          quantity: 1,
          sellingPriceMinor: 5000,
          actualCostMinor: 2000,
        ),
      ],
    );

    await store.saveTransaction(transaction);
    await store.close();
    store = await SqliteStore.open(
      databasePath: '${tempDirectory.path}/songjog_test.db',
      factory: databaseFactoryFfiNoIsolate,
    );

    final loaded = await store.loadTransactions();
    expect(loaded, hasLength(1));
    expect(loaded.single.id, 'sale-1');
    expect(loaded.single.lines, hasLength(2));
    expect(loaded.single.lines.first.actualCostMinor, 3500);
    expect(loaded.single.paidMinor, 15000);
  });

  test('rejects transaction without lines', () async {
    final transaction = TransactionRecord(
      id: 'invalid-sale',
      type: TransactionType.sale,
      createdAt: DateTime(2026, 8, 26),
      paymentStatus: PaymentStatus.unpaid,
      paidMinor: 0,
      lines: const [],
    );

    expect(
      () => store.saveTransaction(transaction),
      throwsArgumentError,
    );
  });
}
