import '../../domain/models/business_profile.dart';
import '../../domain/models/transaction.dart';

/// Small persistence boundary used by the first application layer.
///
/// The interface deliberately hides storage details from the domain. A durable
/// database implementation can replace this store without changing domain
/// models or presentation code.
abstract interface class LocalStore {
  Future<void> saveBusinessProfile(BusinessProfile profile);
  Future<BusinessProfile?> loadBusinessProfile();
  Future<void> saveTransaction(TransactionRecord transaction);
  Future<List<TransactionRecord>> loadTransactions();
}

class InMemoryStore implements LocalStore {
  BusinessProfile? _profile;
  final List<TransactionRecord> _transactions = <TransactionRecord>[];

  @override
  Future<void> saveBusinessProfile(BusinessProfile profile) async {
    _profile = profile;
  }

  @override
  Future<BusinessProfile?> loadBusinessProfile() async => _profile;

  @override
  Future<void> saveTransaction(TransactionRecord transaction) async {
    _transactions.removeWhere((item) => item.id == transaction.id);
    _transactions.add(transaction);
  }

  @override
  Future<List<TransactionRecord>> loadTransactions() async =>
      List.unmodifiable(_transactions);
}
