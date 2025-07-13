// lib/presentation/pelanggan/transaction/bloc/transaction_event.dart

part of 'transaction_bloc.dart';

sealed class TransactionEvent {}

class AddNewTransaction extends TransactionEvent {
  final int sparepartId;
  final int quantity;

  AddNewTransaction({required this.sparepartId, required this.quantity});
}

class FetchRiwayatTransactions extends TransactionEvent {}

class FetchTransactionDetail extends TransactionEvent { 
  final int transactionId;
  FetchTransactionDetail({required this.transactionId});
}