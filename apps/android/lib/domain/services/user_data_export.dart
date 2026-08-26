import 'dart:convert';

import '../../data/local/in_memory_store.dart';
import 'export_manifest.dart';

class UserDataExport {
  const UserDataExport._();

  /// [clock] is injectable so the manifest timestamp (and therefore the
  /// serialized export) is deterministic in tests.
  static Future<String> toJson({
    required LocalStore store,
    DateTime? start,
    DateTime? end,
    DateTime Function()? clock,
  }) async {
    final profile = await store.loadBusinessProfile();
    final transactions = await store.loadTransactions();
    final filtered = transactions.where((item) {
      if (start != null && item.createdAt.isBefore(start)) return false;
      if (end != null && item.createdAt.isAfter(end)) return false;
      return true;
    }).toList(growable: false);

    final manifest = ExportManifest(
      schemaVersion: 1,
      createdAt: (clock ?? DateTime.now)(),
      kind: 'user_data',
      sections: const ['business_profile', 'transactions', 'transaction_lines'],
    );

    return const JsonEncoder.withIndent('  ').convert({
      'manifest': manifest.toMap(),
      'business_profile': profile == null
          ? null
          : {
              'id': profile.id,
              'name': profile.name,
              'workspace_kind': profile.workspaceKind.name,
              'business_type': profile.businessType.name,
              'subtype': profile.subtype,
              'phone': profile.phone,
              'address': profile.address,
            },
      'transactions': filtered.map((transaction) => {
        'id': transaction.id,
        'type': transaction.type.name,
        'created_at': transaction.createdAt.toUtc().toIso8601String(),
        'customer_id': transaction.customerId,
        'reference': transaction.reference,
        'note': transaction.note,
        'payment_status': transaction.paymentStatus.name,
        'payment_method': transaction.paymentMethod?.name,
        'paid_minor': transaction.paidMinor,
        'lines': transaction.lines.map((line) => {
          'id': line.id,
          'description': line.description,
          'quantity': line.quantity,
          'selling_price_minor': line.sellingPriceMinor,
          'actual_cost_minor': line.actualCostMinor,
        }).toList(growable: false),
      }).toList(growable: false),
    });
  }
}
