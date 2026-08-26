class SaleItem {
  const SaleItem({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0,
  });

  final String itemId;
  final String name;
  final double quantity;
  final int unitPrice;
  final int discount;

  int get subtotal => (quantity * unitPrice).round();
  int get total => subtotal - discount;
}

class Sale {
  const Sale({
    required this.id,
    required this.items,
    required this.createdAt,
    this.amountPaid = 0,
    this.note,
  });

  final String id;
  final List<SaleItem> items;
  final DateTime createdAt;
  final int amountPaid;
  final String? note;

  int get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);
  int get discount => items.fold(0, (sum, item) => sum + item.discount);
  int get total => items.fold(0, (sum, item) => sum + item.total);
  int get due => total - amountPaid;

  bool get isPaid => due <= 0;
}
