part of 'laporan_export_pdf_bloc.dart';

abstract class LaporanExportPdfState extends Equatable {
  const LaporanExportPdfState();

  @override
  List<Object> get props => [];
}

class LaporanExportPdfInitial extends LaporanExportPdfState {}

class LaporanExportPdfLoading extends LaporanExportPdfState {}

class LaporanExportPdfLoaded extends LaporanExportPdfState {
  final Uint8List pdfBytes; // Data PDF dalam bentuk bytes

  const LaporanExportPdfLoaded({required this.pdfBytes});

  @override
  List<Object> get props => [pdfBytes];
}

class LaporanExportPdfError extends LaporanExportPdfState {
  final String message;

  const LaporanExportPdfError({required this.message});

  @override
  List<Object> get props => [message];
}