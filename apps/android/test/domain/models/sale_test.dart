import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/domain/models/sale.dart';

void main() {
  test('calculates subtotal, discount, total and due for multiple items', () {
    final sale = Sale(
      id: 'sale-1',
      createdAt: DateTime(2026, 8, 26),
      amountPaid: 100,
      items: [
        SaleItem(itemId: '1', name: 'Item 1', quantity: 2, unitPrice: 100),
        SaleItem(
          itemId: '2',
          name: 'Item 2',
          quantity: 3,
          unitPrice: 50,
          discount: 20,
        ),
      ],
    );

    expect(sale.subtotal, 350);
    expect(sale.discount, 20);
    expect(sale.total, 330);
    expect(sale.due, 230);
    expect(sale.isPaid, isFalse);
  });

  test('paid sale never reports a negative due amount as unpaid', () {
    final sale = Sale(
      id: 'sale-2',
      createdAt: DateTime(2026, 8, 26),
      amountPaid: 500,
      items: [
        SaleItem(itemId: '1', name: 'Item 1', quantity: 1, unitPrice: 300),
      ],
    );

    expect(sale.due, 0);
    expect(sale.isPaid, isTrue);
  });
}
