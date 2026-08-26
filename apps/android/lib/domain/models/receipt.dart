import 'sale.dart';

class Receipt {
  const Receipt({
    required this.number,
    required this.sale,
    required this.issuedAt,
  });

  final String number;
  final Sale sale;
  final DateTime issuedAt;

  int get total => sale.total;
  int get paid => sale.amountPaid;
  int get due => sale.due;

  bool get isMultiPage => sale.items.length > 8;

  int get pageCount {
    if (sale.items.isEmpty) return 1;
    return ((sale.items.length - 1) ~/ 8) + 1;
  }
}
