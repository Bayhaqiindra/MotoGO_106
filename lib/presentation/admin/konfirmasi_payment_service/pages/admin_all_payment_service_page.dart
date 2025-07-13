import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart'; // No longer directly used here, as formatting is in the list tile

// Import Bloc dan State yang relevan dari folder bloc Anda
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_service/bloc/admin_payment_service_bloc.dart';

// Import model respons untuk menampilkan data
import 'package:tugas_akhir/data/model/response/admin/payment_service/admin_get_all_payment_service_response_model.dart';
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_service/widget/admin_payment_confirmation_dialog.dart';
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_service/widget/admin_payment_list_tile.dart';


class AdminAllPaymentPage extends StatefulWidget {
  const AdminAllPaymentPage({super.key});

  @override
  State<AdminAllPaymentPage> createState() => _AdminAllPaymentPageState();
}

class _AdminAllPaymentPageState extends State<AdminAllPaymentPage> {
  @override
  void initState() {
    super.initState();
    // Memuat semua pembayaran layanan saat halaman diinisialisasi
    context.read<AdminPaymentServiceBloc>().add(const LoadAllAdminServicePayments());
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showConfirmationDialog(BuildContext context, GetAllAdminPaymentServiceResponseodel payment) {
    showDialog(
      context: context,
      builder: (dialogContext) { // Gunakan dialogContext untuk Navigator.pop dari dialog
        return AdminPaymentConfirmationDialog(
          paymentId: payment.paymentId ?? 0, // Pastikan paymentId int
          // Mengirimkan seluruh objek payment jika Anda ingin menampilkan lebih banyak detail di dialog
          // payment: payment, // Anda bisa uncomment ini jika AdminPaymentConfirmationDialog menerima objek payment
          onConfirmed: () {
            // Tutup dialog
            Navigator.pop(dialogContext);
            // Muat ulang daftar pembayaran setelah berhasil dikonfirmasi/ditolak
            context.read<AdminPaymentServiceBloc>().add(const LoadAllAdminServicePayments());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pembayaran Layanan'), // Judul disesuaikan
        backgroundColor: const Color(0xFF3A60C0), // Warna AppBar
        foregroundColor: Colors.white, // Warna teks di AppBar
      ),
      body: BlocConsumer<AdminPaymentServiceBloc, AdminPaymentServiceState>(
        listener: (context, state) {
          // Menangani state sukses dan gagal dari verifikasi/konfirmasi
          if (state is AdminServicePaymentVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.response.message ?? 'Pembayaran berhasil dikonfirmasi/ditolak.')),
            );
            // Note: Reloading is already handled by the onConfirmed callback from the dialog.
            // Keeping this line commented out to prevent double-reloads.
            // context.read<AdminPaymentServiceBloc>().add(const LoadAllAdminServicePayments());
          } else if (state is AdminPaymentServiceFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
          // Anda bisa menambahkan logika loading overlay jika diperlukan
          // if (state is AdminPaymentServiceLoading) {
          //   LoadingOverlay.show(context); // Asumsikan Anda punya LoadingOverlay
          // } else {
          //   LoadingOverlay.hide();
          // }
        },
        builder: (context, state) {
          if (state is AdminPaymentServiceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllAdminServicePaymentsLoaded) {
            if (state.payments.isEmpty) {
              return const Center(
                child: Text('Tidak ada riwayat pembayaran layanan.'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.payments.length,
              itemBuilder: (context, index) {
                final payment = state.payments[index];
                return AdminPaymentListTile(
                  payment: payment,
                  // Menggunakan onTapConfirm sesuai dengan AdminPaymentListTile yang diperbarui
                  onTapConfirm: () => _showConfirmationDialog(context, payment),
                );
              },
            );
          } else if (state is AdminPaymentServiceFailure) {
            return Center(
              child: Text('Gagal memuat pembayaran: ${state.error}'),
            );
          }
          // Default return untuk state awal atau state yang tidak ditangani secara eksplisit
          return const Center(child: Text('Tekan tombol refresh untuk memuat data.'));
        },
      ),
    );
  }
}