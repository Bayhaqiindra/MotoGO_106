// lib/presentation/pelanggan/transaction/bloc/transaction_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/transaction/add_transaction_request_model.dart';
import 'package:tugas_akhir/data/model/response/get_by_id_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/transaction/add_transaction_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/transaction/riwayat_transaction_response_model.dart';
import 'package:tugas_akhir/data/repository/pelanggan/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;

  TransactionBloc(this._repository) : super(TransactionInitial()) {
    on<AddNewTransaction>(_onAddNewTransaction);
    on<FetchRiwayatTransactions>(_onFetchRiwayatTransactions);
    on<FetchTransactionDetail>(_onFetchTransactionDetail);
  }

  Future<void> _onAddNewTransaction(
      AddNewTransaction event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final requestModel = AddtransactionrequestModel(
        sparepartId: event.sparepartId,
        quantity: event.quantity,
      );
      final response = await _repository.addTransaction(requestModel);
      emit(AddTransactionSuccess(response));
    } catch (e) {
      emit(AddTransactionError(e.toString()));
    }
  }

  Future<void> _onFetchRiwayatTransactions(
      FetchRiwayatTransactions event, Emitter<TransactionState> emit) async {
    emit(RiwayatTransactionsLoading());
    try {
      final transactions = await _repository.getRiwayatTransaksi();
      emit(RiwayatTransactionsLoaded(transactions));
    } catch (e) {
      emit(RiwayatTransactionsError(e.toString()));
    }
  }

  Future<void> _onFetchTransactionDetail( // ✨ Tambahkan method ini ✨
      FetchTransactionDetail event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading()); // Gunakan state loading yang sama
    try {
      final transactionDetail = await _repository.getTransactionById(event.transactionId);
      emit(TransactionDetailLoaded(transactionDetail));
    } catch (e) {
      emit(TransactionDetailError(e.toString())); // Atau TransactionError(e.toString())
    }
  }
}