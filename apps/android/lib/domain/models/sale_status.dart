enum SalePaymentStatus { unpaid, partial, paid }

SalePaymentStatus paymentStatus({
  required int total,
  required int amountPaid,
}) {
  if (amountPaid <= 0) return SalePaymentStatus.unpaid;
  if (amountPaid < total) return SalePaymentStatus.partial;
  return SalePaymentStatus.paid;
}
