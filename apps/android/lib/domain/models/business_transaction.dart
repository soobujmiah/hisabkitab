// Provenance: this model originates from the "adaptive business and
// transaction foundation" work on main (commit 000c5cb / b674845,
// 2026-08-26) as `transaction.dart`. It is kept in this repository as the
// v2 target transaction model for the adaptive business domain
// (BusinessProfile + TradeProgram). The current app implementation and its
// tests use the v1 model in `transaction.dart` (TransactionRecord,
// minor-unit money). The two models are intentionally kept separate until
// the app migrates; do not merge class names across the two files.
enum TransactionKind { sale, serviceSale, paymentReceived, expense, purchase, refund, returnAdjustment, transfer, withdrawal }

enum PaymentMethod { cash, bank, bkash, nagad, other, mixed, due }

class TransactionLine {
  const TransactionLine({
    required this.id,
    required this.name,
    required this.quantity,
    required this.sellingPrice,
    this.actualCost,
  });

  final String id;
  final String name;
  final double quantity;
  final double sellingPrice;
  final double? actualCost;

  double get revenue => quantity * sellingPrice;
  double? get grossProfit => actualCost == null
      ? null
      : revenue - (quantity * actualCost!);
}

class BusinessTransaction {
  const BusinessTransaction({
    required this.id,
    required this.number,
    required this.kind,
    required this.createdAt,
    required this.lines,
    this.paymentMethod,
    this.amountPaid = 0,
    this.customerId,
    this.reference,
  });

  final String id;
  final String number;
  final TransactionKind kind;
  final DateTime createdAt;
  final List<TransactionLine> lines;
  final PaymentMethod? paymentMethod;
  final double amountPaid;
  final String? customerId;
  final String? reference;

  double get total => lines.fold(0, (sum, line) => sum + line.revenue);
  double get due => (total - amountPaid).clamp(0, double.infinity);
  double? get grossProfit {
    final profits = lines.map((line) => line.grossProfit);
    if (profits.any((profit) => profit == null)) return null;
    return profits.fold<double>(0, (sum, profit) => sum + profit!);
  }
}
