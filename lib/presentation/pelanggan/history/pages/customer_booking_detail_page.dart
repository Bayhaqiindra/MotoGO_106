// lib/presentation/pelanggan/pages/customer_booking_detail_page.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/extensions/error_retry_widget.dart';
import 'package:tugas_akhir/core/extensions/loading_indicator.dart'; // Pastikan ini adalah utilitas untuk overlay
import 'package:tugas_akhir/core/extensions/loading_payment.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/booking/get_all_booking_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/confirmation_service/pelanggan_confirmation_response_model.dart';
import 'package:tugas_akhir/presentation/pelanggan/booking/bloc/booking_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/history/widget/confirmation_dialog_content.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/presentation/pelanggan/payment_service/pages/customer_payment_page.dart'; // Import halaman pembayaran

class CustomerBookingDetailPage extends StatefulWidget {
  final int bookingId;
  final GetAllBookingResponseModel? initialBookingData;
  final bool showConfirmationOnLoad;

  const CustomerBookingDetailPage({
    Key? key,
    required this.bookingId,
    this.initialBookingData,
    this.showConfirmationOnLoad = false,
  }) : super(key: key);

  @override
  State<CustomerBookingDetailPage> createState() => _CustomerBookingDetailPageState();
}

class _CustomerBookingDetailPageState extends State<CustomerBookingDetailPage> {
  GetAllBookingResponseModel? _currentBookingData;
  DataHistory? _confirmationData; // Untuk menyimpan data konfirmasi dari admin

  @override
  void initState() {
    super.initState();
    _currentBookingData = widget.initialBookingData;
    // Panggil event untuk mendapatkan detail booking
    context.read<BookingBloc>().add(GetCustomerBookingDetail(bookingId: widget.bookingId));
  }

  // Method untuk menampilkan dialog konfirmasi
  void _showConfirmationDialog(
      BuildContext context, GetAllBookingResponseModel booking, DataHistory confirmationData) {
    if (kDebugMode) {
      debugPrint('[DEBUG] _showConfirmationDialog called:');
      debugPrint('  Booking ID: ${booking.bookingId}');
      debugPrint('  Booking Status: ${booking.status}');
      debugPrint('  Confirmation Data (Admin Notes): ${confirmationData.adminNotes}');
      debugPrint('  Confirmation Data (Total Cost): ${confirmationData.totalCost}');
      debugPrint('  Confirmation Data (Service Status): ${confirmationData.serviceStatus}');
      debugPrint('  Confirmation Data (Customer Agreed): ${confirmationData.customerAgreed}');
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup dengan tap di luar
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Layanan Anda'),
          content: ConfirmationDialogContent(
            confirmationData: confirmationData,
            bookingStatusFromBooking: booking.status ?? 'N/A',
            onAgree: () {
              // Tutup dialog
              Navigator.of(dialogContext).pop();
              if (kDebugMode) {
                debugPrint('[DEBUG] Tombol SETUJU ditekan untuk Booking ID: ${booking.bookingId}');
                debugPrint('[DEBUG] Mengirim ConfirmCustomerBooking (customerAgreed: true)');
              }
              // Kirim event untuk konfirmasi persetujuan pelanggan
              context.read<BookingBloc>().add(
                    ConfirmCustomerBooking(
                      confirmationId: confirmationData.confirmationId!, // Menggunakan confirmationId
                      customerAgreed: true,
                    ),
                  );
              // Lanjut ke halaman pembayaran jika setuju
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => CustomerPaymentPage(
                      transactionId: confirmationData.confirmationId!, // Gunakan confirmationId sebagai transactionId
                      transactionTotalPrice: confirmationData.totalCost ?? '0', // Ambil totalCost (String)
                    ),
                  ),
                );
              }
            },
            onReject: () {
              // Tutup dialog
              Navigator.of(dialogContext).pop();
              if (kDebugMode) {
                debugPrint('[DEBUG] Tombol TOLAK ditekan untuk Booking ID: ${booking.bookingId}');
                debugPrint('[DEBUG] Mengirim ConfirmCustomerBooking (customerAgreed: false)');
              }
              // Kirim event untuk konfirmasi penolakan pelanggan
              context.read<BookingBloc>().add(
                    ConfirmCustomerBooking(
                      confirmationId: confirmationData.confirmationId!, // Menggunakan confirmationId
                      customerAgreed: false,
                    ),
                  );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Booking'),
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
                listener: (context, state) {
          if (state is BookingLoading) {
            // Tampilkan loading overlay jika sedang loading
            if (mounted && !LoadingPayment.isShowing) { // <-- AKSES SECARA STATIC
              LoadingPayment.show(context); // <-- AKSES SECARA STATIC
            }
          } else {
            // Sembunyikan loading overlay jika tidak lagi loading
            if (mounted && LoadingPayment.isShowing) { // <-- AKSES SECARA STATIC
              LoadingPayment.hide(context); // <-- AKSES SECARA STATIC
            }
          }


          if (state is BookingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error} ❌')),
            );
          } else if (state is CustomerBookingDetailSuccess) {
            _currentBookingData = state.booking;
            // Jika booking statusnya 'diterima', kita juga perlu mengambil data konfirmasi dari admin
            // Kita panggil GET AdminConfirmationDetail HANYA JIKA _confirmationData masih null
            // untuk menghindari pengambilan data berulang jika sudah ada
            if (state.booking.status?.toLowerCase() == 'diterima' && _confirmationData == null) {
              context.read<BookingBloc>().add(GetAdminConfirmationDetail(bookingId: widget.bookingId));
            }
            // Trigger dialog jika showConfirmationOnLoad dan booking sudah diterima
            // Pastikan _confirmationData sudah ada sebelum memanggil dialog
            if (widget.showConfirmationOnLoad &&
                _currentBookingData?.status?.toLowerCase() == 'diterima' &&
                _confirmationData != null) {
              // Pastikan dialog belum terbuka untuk mencegah multiple dialog
              if (!Navigator.of(context).canPop() || ModalRoute.of(context)?.isCurrent == true) {
                 _showConfirmationDialog(context, _currentBookingData!, _confirmationData!);
              }
            }
          } else if (state is CustomerBookingConfirmedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Muat ulang detail booking setelah konfirmasi pelanggan berhasil
            // Ini akan memperbarui status di UI (misalnya, jika jadi 'Menunggu Pembayaran')
            context.read<BookingBloc>().add(GetCustomerBookingDetail(bookingId: widget.bookingId));
            // Catatan: Jika pelanggan menolak, mereka tetap di halaman detail booking dan status akan diperbarui.
            // Jika pelanggan setuju, mereka sudah dinavigasikan ke CustomerPaymentPage di `_showConfirmationDialog`.
          } else if (state is AdminConfirmationDetailSuccess) {
            _confirmationData = state.confirmationData;
            // Trigger dialog jika showConfirmationOnLoad dan booking sudah diterima
            // Ini dipanggil lagi jika _confirmationData baru didapat setelah _currentBookingData
            if (widget.showConfirmationOnLoad &&
                _currentBookingData?.status?.toLowerCase() == 'diterima' &&
                mounted) { // Pastikan widget masih ada
              // Tambahan cek agar tidak muncul dialog berkali-kali
              if (!Navigator.of(context).canPop() || ModalRoute.of(context)?.isCurrent == true) {
                _showConfirmationDialog(context, _currentBookingData!, _confirmationData!);
              }
            }
          }
        },
        builder: (context, state) {
          if (state is BookingLoading && _currentBookingData == null) {
            // Tidak perlu LoadingIndicator di sini karena sudah di-handle oleh overlay di listener
            return const SizedBox.shrink();
          } else if (_currentBookingData != null) {
            final booking = _currentBookingData!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking ID: ${booking.bookingId ?? "N/A"}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildDetailRow('Status', booking.status?.toUpperCase() ?? "N/A"),
                  _buildDetailRow('Layanan ID', booking.serviceId?.toString() ?? "N/A"),
                  _buildDetailRow('Lokasi Penjemputan', booking.pickupLocation ?? "N/A"),
                  _buildDetailRow('Catatan Pelanggan', booking.customerNotes ?? "Tidak ada"),
                  _buildDetailRow('Latitude', booking.latitude?.toString() ?? "N/A"),
                  _buildDetailRow('Longitude', booking.longitude?.toString() ?? "N/A"),
                  _buildDetailRow('Dibuat Pada',
                      booking.createdAt != null ? DateFormat('dd MMM yyyy, HH:mm').format(booking.createdAt!.toLocal()) : "N/A"),
                  _buildDetailRow('Diperbarui Pada',
                      booking.updatedAt != null ? DateFormat('dd MMM yyyy, HH:mm').format(booking.updatedAt!.toLocal()) : "N/A"),

                  if (booking.pelanggan != null) ...[
                    const Divider(height: 32),
                    const Text('Detail Pelanggan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildDetailRow('Nama', booking.pelanggan!.name ?? "N/A"),
                    _buildDetailRow('Telepon', booking.pelanggan!.phone ?? "N/A"),
                    _buildDetailRow('Alamat', booking.pelanggan!.address ?? "N/A"),
                  ],

                  // Tampilkan bagian konfirmasi admin jika status booking 'diterima'
                  // dan data konfirmasi sudah tersedia
                  if (booking.status?.toLowerCase() == 'diterima' && _confirmationData != null) ...[
                    const Divider(height: 32),
                    const Text('Pesan Konfirmasi Admin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildDetailRow('Status Layanan Admin', _confirmationData!.serviceStatus?.toUpperCase() ?? "N/A"),
                    _buildDetailRow('Total Biaya', _confirmationData!.totalCost != null ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(double.tryParse(_confirmationData!.totalCost!)) : "N/A"),
                    _buildDetailRow('Catatan Admin', _confirmationData!.adminNotes ?? "Tidak ada catatan dari admin."),
                    const SizedBox(height: 20),
                    // Tombol untuk membuka kembali dialog konfirmasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _showConfirmationDialog(context, booking, _confirmationData!);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Lihat/Setujui Konfirmasi'),
                          ),
                        ),
                      ],
                    ),
                  ]
                  else if (booking.status?.toLowerCase() == 'menunggu pembayaran') ...[
                    const Divider(height: 32),
                    const Text('Status Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildDetailRow('Status Saat Ini', 'Menunggu Pembayaran Anda'),
                    _buildDetailRow('Total Pembayaran', _confirmationData!.totalCost != null ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(double.tryParse(_confirmationData!.totalCost!)) : "N/A"),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                                if (mounted) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => CustomerPaymentPage(
                                        transactionId: _confirmationData!.confirmationId!,
                                        transactionTotalPrice: _confirmationData!.totalCost ?? '0',
                                      ),
                                    ),
                                  );
                                }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.deepOrange, // Warna untuk tombol pembayaran
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Lanjutkan ke Pembayaran'),
                          ),
                        ),
                      ],
                    ),
                  ]
                  else if (booking.status?.toLowerCase() == 'ditolak') ...[
                    const Divider(height: 32),
                    const Text('Konfirmasi Ditolak', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                    const SizedBox(height: 8),
                    _buildDetailRow('Status Konfirmasi', 'Ditolak oleh Pelanggan'),
                    _buildDetailRow('Catatan Admin', _confirmationData?.adminNotes ?? 'Tidak ada catatan.'),
                    const SizedBox(height: 20),
                    const Text('Silakan hubungi admin untuk informasi lebih lanjut atau buat booking baru.', style: TextStyle(fontStyle: FontStyle.italic)),
                  ],
                  // Anda bisa menambahkan kondisi lain untuk status booking 'selesai', 'dibatalkan', dll.
                ],
              ),
            );
          } else if (state is BookingFailure) {
            return ErrorRetryWidget(
              message: state.error,
              onRetry: () {
                context.read<BookingBloc>().add(GetCustomerBookingDetail(bookingId: widget.bookingId));
              },
            );
          }
          // Default: tampilkan widget kosong atau loading jika tidak ada kondisi yang cocok
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}