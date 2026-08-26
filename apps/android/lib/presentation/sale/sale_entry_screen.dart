import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../application/sale/sale_service.dart';
import '../../domain/models/transaction.dart';
import '../../l10n/app_text.dart';

class _LineState {
  _LineState() {
    quantity.text = '1';
  }

  final description = TextEditingController();
  final quantity = TextEditingController();
  final price = TextEditingController();

  void dispose() {
    description.dispose();
    quantity.dispose();
    price.dispose();
  }

  bool get hasDescription => description.text.trim().isNotEmpty;

  double? get parsedQuantity {
    final value = double.tryParse(quantity.text.trim());
    return (value == null || value <= 0) ? null : value;
  }

  int? get parsedPriceMinor {
    final text = price.text.trim();
    if (text.isEmpty) return null;
    try {
      final minor = takaToMinor(text);
      return minor <= 0 ? null : minor;
    } on FormatException {
      return null;
    }
  }

  int? get lineTotalMinor {
    final q = parsedQuantity;
    final p = parsedPriceMinor;
    if (q == null || p == null) return null;
    return (p * q).round();
  }

  bool get complete => hasDescription && lineTotalMinor != null;
}

class SaleEntryScreen extends StatefulWidget {
  const SaleEntryScreen({
    super.key,
    required this.service,
    this.locale = AppLocale.bangla,
  });

  final SaleEntryService service;
  final AppLocale locale;

  @override
  State<SaleEntryScreen> createState() => _SaleEntryScreenState();
}

class _SaleEntryScreenState extends State<SaleEntryScreen> {
  final _lines = <_LineState>[
    _LineState(),
  ];
  final _paid = TextEditingController();
  PaymentMethod? _method;
  bool _saving = false;

  String t(String key) => AppText.get(widget.locale, key);

  /// Currency prefix keeps script purity: Bangla mode uses the taka sign,
  /// English mode stays Latin-only.
  String money(int minor) => widget.locale == AppLocale.bangla
      ? '৳${minorToTaka(minor)}'
      : 'BDT ${minorToTaka(minor)}';

  @override
  void dispose() {
    for (final line in _lines) {
      line.dispose();
    }
    _paid.dispose();
    super.dispose();
  }

  int get _totalMinor =>
      _lines.fold<int>(0, (sum, line) => sum + (line.lineTotalMinor ?? 0));

  int? get _paidMinor {
    final text = _paid.text.trim();
    if (text.isEmpty) return 0;
    try {
      return takaToMinor(text);
    } on FormatException {
      return null;
    }
  }

  bool get _allLinesComplete => _lines.isNotEmpty && _lines.every((l) => l.complete);

  PaymentStatus get _status {
    final total = _totalMinor;
    final paid = _paidMinor;
    if (paid == null) return PaymentStatus.unpaid;
    return derivePaymentStatus(
        totalMinor: total, paidMinor: clampPaid(paid, total));
  }

  Future<void> _completeSale() async {
    final paid = _paidMinor;
    if (paid == null) {
      _showError();
      return;
    }
    setState(() => _saving = true);
    try {
      final record = await widget.service.saveSale(
        lines: [
          for (final line in _lines)
            (
              description: line.description.text.trim(),
              quantity: line.parsedQuantity!,
              priceMinor: line.parsedPriceMinor!,
            ),
        ],
        paidMinor: clampPaid(paid, _totalMinor),
        paymentMethod: _method,
      );
      if (mounted) {
        Navigator.of(context).pop(record);
      }
    } catch (_) {
      if (mounted) _showError();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t('sale_failed'))));
  }

  @override
  Widget build(BuildContext context) {
    final total = _totalMinor;
    final paid = _paidMinor ?? 0;
    final clampedPaid = clampPaid(paid, total);
    final due = total - clampedPaid;
    return Scaffold(
      appBar: AppBar(title: Text(t('sale_title'))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            for (var i = 0; i < _lines.length; i++) ...[
              _buildLine(_lines[i], index: i),
              const SizedBox(height: 12),
            ],
            FilledButton.tonalIcon(
              onPressed: _saving ? null : () => setState(() => _lines.add(_LineState())),
              icon: const Icon(Icons.add),
              label: Text(t('add_line')),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t('total'),
                            style: Theme.of(context).textTheme.titleMedium),
                        Text(money(total),
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _paid,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: InputDecoration(
                        labelText: t('amount_paid'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t('due'),
                            style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          money(due),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: due > 0
                                    ? Theme.of(context).colorScheme.error
                                    : null,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t(_status.name == 'paid'
                          ? 'paid_status'
                          : _status.name == 'partial'
                              ? 'partial_status'
                              : 'unpaid_status'),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<PaymentMethod?>(
                      initialValue: _method,
                      decoration: InputDecoration(labelText: t('payment_method')),
                      items: [
                        DropdownMenuItem<PaymentMethod?>(
                          value: null,
                          child: Text(t('payment_method_unset')),
                        ),
                        for (final method in PaymentMethod.values)
                          DropdownMenuItem<PaymentMethod?>(
                            value: method,
                            child: Text(t(method.name)),
                          ),
                      ],
                      onChanged:
                          _saving ? null : (value) => setState(() => _method = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed:
                  _saving || !_allLinesComplete ? null : _completeSale,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(_saving ? '…' : t('complete_sale')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLine(_LineState line, {required int index}) {
    final lineTotal = line.lineTotalMinor;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: line.description,
                    decoration: InputDecoration(labelText: t('line_description')),
                  ),
                ),
                IconButton(
                  tooltip: t('remove_line'),
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _saving || _lines.length == 1
                      ? null
                      : () => setState(() {
                          final removed = _lines.removeAt(index);
                          removed.dispose();
                        }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: line.quantity,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    decoration: InputDecoration(labelText: t('quantity')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: line.price,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    decoration: InputDecoration(labelText: t('price')),
                  ),
                ),
              ],
            ),
            if (lineTotal != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t('line_total'),
                        style: Theme.of(context).textTheme.labelLarge),
                    Text(money(lineTotal),
                        style: Theme.of(context).textTheme.labelLarge),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
