// lib/presentation/admin/transaction/bloc/admin_transaction_state.dart

part of 'admin_transaction_bloc.dart';

@immutable
sealed class AdminTransactionState {}

final class AdminTransactionInitial extends AdminTransactionState {}
final class AdminTransactionLoading extends AdminTransactionState {}

final class AllAdminTransactionsLoaded extends AdminTransactionState {
  final List<Datum> transactions; // Menggunakan Datum dari GetalltransactionresponseModel
  AllAdminTransactionsLoaded(this.transactions);
}

final class AdminTransactionError extends AdminTransactionState {
  final String message;
  AdminTransactionError(this.message);
}

final class AdminTransactionDetailLoaded extends AdminTransactionState {
  final GetbyidtransactionresponseModel transactionDetail; // ✨ Gunakan model respons detail ini ✨
  AdminTransactionDetailLoaded(this.transactionDetail);
}