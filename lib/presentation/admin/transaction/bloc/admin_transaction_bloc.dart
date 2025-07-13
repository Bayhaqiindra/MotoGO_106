// lib/presentation/admin/transaction/bloc/admin_transaction_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tugas_akhir/data/model/response/admin/transaction/get_all_transaction_response_model.dart'; // Import model
import 'package:tugas_akhir/data/model/response/get_by_id_response_model.dart';
import 'package:tugas_akhir/data/repository/admin/admin_transaction_repository.dart';

part 'admin_transaction_event.dart';
part 'admin_transaction_state.dart';

class AdminTransactionBloc
    extends Bloc<AdminTransactionEvent, AdminTransactionState> {
  final AdminTransactionRepository _repository;

  AdminTransactionBloc(this._repository) : super(AdminTransactionInitial()) {
    on<FetchAllAdminTransactions>(_onFetchAllAdminTransactions);
    on<FetchAdminTransactionDetail>(_onFetchAdminTransactionDetail);
  }

  Future<void> _onFetchAllAdminTransactions(
    FetchAllAdminTransactions event,
    Emitter<AdminTransactionState> emit,
  ) async {
    emit(AdminTransactionLoading());
    try {
      final transactions = await _repository.getAllTransactions();
      emit(AllAdminTransactionsLoaded(transactions));
    } catch (e) {
      emit(AdminTransactionError(e.toString()));
    }
  }

  Future<void> _onFetchAdminTransactionDetail(
    FetchAdminTransactionDetail event,
    Emitter<AdminTransactionState> emit,
  ) async {
    emit(AdminTransactionLoading()); // Bisa pakai state loading yang sama
    try {
      final transactionDetail = await _repository.getTransactionById(
        event.transactionId,
      );
      emit(AdminTransactionDetailLoaded(transactionDetail));
    } catch (e) {
      emit(
        AdminTransactionError(e.toString()),
      ); 
    }
  }
}
