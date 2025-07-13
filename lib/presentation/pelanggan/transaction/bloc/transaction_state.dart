// lib/presentation/pelanggan/transaction/bloc/transaction_state.dart

part of 'transaction_bloc.dart';

sealed class TransactionState {}

final class TransactionInitial extends TransactionState {}
final class TransactionLoading extends TransactionState {}

final class AddTransactionSuccess extends TransactionState {
  final AddtransactionresponseModel transaction;
  AddTransactionSuccess(this.transaction);
}

final class AddTransactionError extends TransactionState {
  final String message;
  AddTransactionError(this.message);
}


class RiwayatTransactionsLoading extends TransactionState {}
final class RiwayatTransactionsLoaded extends TransactionState {
  final List<RiwayattransactionresponseModel> transactions;
  RiwayatTransactionsLoaded(this.transactions);
}

final class RiwayatTransactionsError extends TransactionState {
  final String message;
  RiwayatTransactionsError(this.message);
}

final class TransactionDetailLoaded extends TransactionState { // ✨ Tambahkan ini ✨
  final GetbyidtransactionresponseModel transactionDetail;
  TransactionDetailLoaded(this.transactionDetail);
}

final class TransactionDetailError extends TransactionState { // ✨ Tambahkan ini untuk error detail spesifik jika mau ✨
  final String message;
  TransactionDetailError(this.message);
}

