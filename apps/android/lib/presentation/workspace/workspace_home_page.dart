import 'package:flutter/material.dart';

import '../../app/app_services.dart';
import '../../application/sale/sale_service.dart';
import '../../domain/models/business_profile.dart';
import '../../domain/models/transaction.dart';
import '../../l10n/app_text.dart';
import '../sale/sale_entry_screen.dart';
import '../settings/settings_screen.dart';

/// Owner workspace home: recent transactions plus the fast sale entry.
class WorkspaceHomePage extends StatefulWidget {
  const WorkspaceHomePage({
    super.key,
    required this.services,
    this.locale = AppLocale.bangla,
  });

  final AppServices services;
  final AppLocale locale;

  @override
  State<WorkspaceHomePage> createState() => _WorkspaceHomePageState();
}

class _WorkspaceHomePageState extends State<WorkspaceHomePage> {
  BusinessProfile? _profile;
  List<TransactionRecord> _transactions = const [];
  bool _loading = true;

  String t(String key) => AppText.get(widget.locale, key);

  String money(int minor) => widget.locale == AppLocale.bangla
      ? '৳${minorToTaka(minor)}'
      : 'BDT ${minorToTaka(minor)}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await widget.services.repository.getProfile();
    final transactions = await widget.services.repository.getTransactions();
    if (mounted) {
      setState(() {
        _profile = profile;
        _transactions = transactions;
        _loading = false;
      });
    }
  }

  Future<void> _newSale() async {
    final record = await Navigator.of(context).push<TransactionRecord>(
      MaterialPageRoute<TransactionRecord>(
        builder: (_) => SaleEntryScreen(
          service: SaleEntryService(
              widget.services.repository, widget.services.diagnostics),
          locale: widget.locale,
        ),
      ),
    );
    if (record != null && mounted) {
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t('sale_saved'))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_profile?.name ?? t('app_name')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: t('settings'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    SettingsScreen(services: widget.services, locale: widget.locale),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : _newSale,
        icon: const Icon(Icons.add_shopping_cart_outlined),
        label: Text(t('new_sale')),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _transactions.isEmpty
                ? _buildEmptyState()
                : _buildTransactionList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(t('no_transactions'),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(t('no_transactions_hint'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text(t('workspace_home_recent'),
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        for (final transaction in _transactions)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.lines.first.description,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (transaction.lines.length > 1)
                    Text(
                      t('more_lines').replaceFirst(
                          '{count}', '${transaction.lines.length - 1}'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(money(transaction.totalMinor),
                          style: Theme.of(context).textTheme.titleSmall),
                      Text(
                        t(transaction.paymentStatus.name == 'paid'
                            ? 'paid_status'
                            : transaction.paymentStatus.name == 'partial'
                                ? 'partial_status'
                                : 'unpaid_status'),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  if (transaction.dueMinor > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${t('due')}: ${money(transaction.dueMinor)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
