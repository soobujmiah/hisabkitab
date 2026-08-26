import '../../domain/models/business_profile.dart';
import '../../domain/models/transaction.dart';
import '../local/in_memory_store.dart';

abstract interface class BusinessRepository {
  Future<void> saveProfile(BusinessProfile profile);
  Future<BusinessProfile?> getProfile();
  Future<void> saveTransaction(TransactionRecord transaction);
  Future<List<TransactionRecord>> getTransactions();
}

class DefaultBusinessRepository implements BusinessRepository {
  const DefaultBusinessRepository(this._store);

  final LocalStore _store;

  @override
  Future<void> saveProfile(BusinessProfile profile) =>
      _store.saveBusinessProfile(profile);

  @override
  Future<BusinessProfile?> getProfile() => _store.loadBusinessProfile();

  @override
  Future<void> saveTransaction(TransactionRecord transaction) =>
      _store.saveTransaction(transaction);

  @override
  Future<List<TransactionRecord>> getTransactions() =>
      _store.loadTransactions();
}
