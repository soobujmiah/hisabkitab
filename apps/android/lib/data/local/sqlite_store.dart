import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../domain/models/business_profile.dart';
import '../../domain/models/transaction.dart';
import 'in_memory_store.dart';

class SqliteStore implements LocalStore {
  SqliteStore._(this._db);

  final Database _db;

  static Future<SqliteStore> open({String? databasePath}) async {
    final path = databasePath ?? p.join(await getDatabasesPath(), 'songjog.db');
    final db = await openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE business_profile (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            workspace_kind TEXT NOT NULL,
            business_type TEXT NOT NULL,
            subtype TEXT,
            phone TEXT,
            address TEXT
          )
        ''');
        await database.execute('''
          CREATE TABLE transactions (
            id TEXT PRIMARY KEY,
            type TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            customer_id TEXT,
            reference TEXT,
            note TEXT,
            payment_status TEXT NOT NULL,
            payment_method TEXT,
            paid_minor INTEGER NOT NULL
          )
        ''');
        await database.execute('''
          CREATE TABLE transaction_lines (
            id TEXT PRIMARY KEY,
            transaction_id TEXT NOT NULL,
            description TEXT NOT NULL,
            quantity REAL NOT NULL,
            selling_price_minor INTEGER NOT NULL,
            actual_cost_minor INTEGER,
            FOREIGN KEY(transaction_id) REFERENCES transactions(id) ON DELETE CASCADE
          )
        ''');
        await database.execute(
          'CREATE INDEX idx_transaction_lines_transaction_id '
          'ON transaction_lines(transaction_id)',
        );
        await database.execute(
          'CREATE INDEX idx_transactions_created_at ON transactions(created_at)',
        );
      },
    );
    return SqliteStore._(db);
  }

  @override
  Future<void> saveBusinessProfile(BusinessProfile profile) async {
    await _db.insert(
      'business_profile',
      {
        'id': profile.id,
        'name': profile.name,
        'workspace_kind': profile.workspaceKind.name,
        'business_type': profile.businessType.name,
        'subtype': profile.subtype,
        'phone': profile.phone,
        'address': profile.address,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<BusinessProfile?> loadBusinessProfile() async {
    final rows = await _db.query('business_profile', limit: 1);
    if (rows.isEmpty) return null;
    final row = rows.first;
    return BusinessProfile(
      id: row['id']! as String,
      name: row['name']! as String,
      workspaceKind: WorkspaceKind.values.byName(row['workspace_kind']! as String),
      businessType: BusinessType.values.byName(row['business_type']! as String),
      subtype: row['subtype'] as String?,
      phone: row['phone'] as String?,
      address: row['address'] as String?,
    );
  }

  @override
  Future<void> saveTransaction(TransactionRecord transaction) async {
    if (transaction.lines.isEmpty) {
      throw ArgumentError('A transaction must contain at least one line.');
    }
    await _db.transaction((txn) async {
      await txn.insert(
        'transactions',
        {
          'id': transaction.id,
          'type': transaction.type.name,
          'created_at': transaction.createdAt.millisecondsSinceEpoch,
          'customer_id': transaction.customerId,
          'reference': transaction.reference,
          'note': transaction.note,
          'payment_status': transaction.paymentStatus.name,
          'payment_method': transaction.paymentMethod?.name,
          'paid_minor': transaction.paidMinor,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await txn.delete(
        'transaction_lines',
        where: 'transaction_id = ?',
        whereArgs: [transaction.id],
      );
      for (final line in transaction.lines) {
        await txn.insert('transaction_lines', {
          'id': line.id,
          'transaction_id': transaction.id,
          'description': line.description,
          'quantity': line.quantity,
          'selling_price_minor': line.sellingPriceMinor,
          'actual_cost_minor': line.actualCostMinor,
        });
      }
    });
  }

  @override
  Future<List<TransactionRecord>> loadTransactions() async {
    final rows = await _db.query('transactions', orderBy: 'created_at DESC');
    final result = <TransactionRecord>[];
    for (final row in rows) {
      final lineRows = await _db.query(
        'transaction_lines',
        where: 'transaction_id = ?',
        whereArgs: [row['id']],
      );
      result.add(TransactionRecord(
        id: row['id']! as String,
        type: TransactionType.values.byName(row['type']! as String),
        createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at']! as int),
        customerId: row['customer_id'] as String?,
        reference: row['reference'] as String?,
        note: row['note'] as String?,
        paymentStatus: PaymentStatus.values.byName(row['payment_status']! as String),
        paymentMethod: row['payment_method'] == null
            ? null
            : PaymentMethod.values.byName(row['payment_method']! as String),
        paidMinor: row['paid_minor']! as int,
        lines: lineRows.map((line) => TransactionLine(
          id: line['id']! as String,
          description: line['description']! as String,
          quantity: (line['quantity']! as num).toDouble(),
          sellingPriceMinor: line['selling_price_minor']! as int,
          actualCostMinor: line['actual_cost_minor'] as int?,
        )).toList(),
      ));
    }
    return result;
  }

  Future<void> close() => _db.close();
}
