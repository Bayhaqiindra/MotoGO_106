import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas_akhir/data/repository/admin/laporan_repository.dart';

part 'laporan_export_pdf_event.dart';
part 'laporan_export_pdf_state.dart';

class LaporanExportPdfBloc extends Bloc<LaporanExportPdfEvent, LaporanExportPdfState> {
  final LaporanRepository laporanRepository;

  LaporanExportPdfBloc({required this.laporanRepository}) : super(LaporanExportPdfInitial()) {
    on<ExportLaporanPdf>(_onExportLaporanPdf);
  }

  Future<void> _onExportLaporanPdf(
    ExportLaporanPdf event,
    Emitter<LaporanExportPdfState> emit,
  ) async {
    emit(LaporanExportPdfLoading());
    try {
      final pdfBytes = await laporanRepository.exportLaporanPDF();
      emit(LaporanExportPdfLoaded(pdfBytes: pdfBytes));
    } catch (e) {
      emit(LaporanExportPdfError(message: 'Gagal mengunduh laporan PDF: ${e.toString()}'));
    }
  }
}
