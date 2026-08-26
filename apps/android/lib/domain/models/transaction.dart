enum TransactionType {
  sale,
  serviceSale,
  purchase,
  expense,
  paymentReceived,
  paymentMade,
  refund,
  returnTransaction,
  transfer,
  withdrawal,
  deposit,
  adjustment,
}

enum PaymentStatus { unpaid, partial, paid, refunded }

enum PaymentMethod { cash, bank, mobileFinancialService, card, other }

class TransactionLine {
  const TransactionLine({
    required this.id,
    required this.description,
    required this.quantity,
    required this.sellingPriceMinor,
    this.actualCostMinor,
  });

  final String id;
  final String description;
  final double quantity;
  final int sellingPriceMinor;
  final int? actualCostMinor;

  int get lineTotalMinor => (sellingPriceMinor * quantity).round();
  int? get lineCostMinor => actualCostMinor == null
      ? null
      : (actualCostMinor! * quantity).round();

  int? get grossProfitMinor => lineCostMinor == null
      ? null
      : lineTotalMinor - lineCostMinor!;
}

class TransactionRecord {
  const TransactionRecord({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.lines,
    this.customerId,
    this.reference,
    this.note,
    this.paymentStatus = PaymentStatus.unpaid,
    this.paymentMethod,
    this.paidMinor = 0,
  });

  final String id;
  final TransactionType type;
  final DateTime createdAt;
  final List<TransactionLine> lines;
  final String? customerId;
  final String? reference;
  final String? note;
  final PaymentStatus paymentStatus;
  final PaymentMethod? paymentMethod;
  final int paidMinor;

  int get totalMinor => lines.fold(0, (sum, line) => sum + line.lineTotalMinor);
  int get dueMinor => totalMinor - paidMinor;
  int get grossProfitMinor => lines.fold(
        0,
        (sum, line) => sum + (line.grossProfitMinor ?? 0),
      );
}
