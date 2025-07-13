// lib/presentation/admin/transaction/bloc/admin_transaction_event.dart

part of 'admin_transaction_bloc.dart';

@immutable
sealed class AdminTransactionEvent {}

class FetchAllAdminTransactions extends AdminTransactionEvent {}

class FetchAdminTransactionDetail extends AdminTransactionEvent {
  final int transactionId;
  FetchAdminTransactionDetail({required this.transactionId});
}