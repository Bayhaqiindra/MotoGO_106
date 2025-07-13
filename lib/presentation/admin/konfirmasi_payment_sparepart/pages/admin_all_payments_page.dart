// lib/presentation/admin/payment_sparepart/pages/admin_all_payments_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_sparepart/admin_get_all_payment_sparepart_response_model.dart';
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_sparepart/bloc/admin_payment_sparepart_bloc.dart';
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_sparepart/widget/admin_payment_confirmation_dialog.dart';
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_sparepart/widget/admin_payment_list_tile.dart';

class AdminAllPaymentsPage extends StatefulWidget {
  const AdminAllPaymentsPage({super.key});

  @override
  State<AdminAllPaymentsPage> createState() => _AdminAllPaymentsPageState();
}

class _AdminAllPaymentsPageState extends State<AdminAllPaymentsPage> {
  @override
  void initState() {
    super.initState();
    // Memuat semua riwayat pembayaran saat halaman diinisialisasi
    context.read<AdminPaymentSparepartBloc>().add(const FetchAllAdminPaymentsSparepart());
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showConfirmationDialog(BuildContext context, GetallAdminPaymentSparepartResponseModel payment) {
    showDialog(
      context: context,
      builder: (dialogContext) { // Gunakan dialogContext untuk Navigator.pop dari dialog
        return AdminPaymentConfirmationDialog(
          payment: payment,
          // Callback saat konfirmasi berhasil (untuk refresh daftar)
          onConfirmed: () {
            // Tutup dialog
            Navigator.pop(dialogContext);
            // Muat ulang daftar pembayaran
            context.read<AdminPaymentSparepartBloc>().add(const FetchAllAdminPaymentsSparepart());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pembayaran Sparepart'),
        backgroundColor: const Color(0xFF3A60C0),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<AdminPaymentSparepartBloc, AdminPaymentSparepartState>(
        listener: (context, state) {
          // Listener untuk menangani state sukses/error dari konfirmasi pembayaran
          if (state is AdminPaymentSparepartConfirmationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pembayaran berhasil dikonfirmasi: ${state.response.message}')),
            );
            // Tidak perlu memuat ulang di sini jika onConfirmed di dialog sudah memicunya
          } else if (state is AdminPaymentSparepartConfirmationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal konfirmasi pembayaran: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminPaymentsSparepartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminPaymentsSparepartLoaded) {
            if (state.payments.isEmpty) {
              return const Center(child: Text('Belum ada riwayat pembayaran sparepart.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.payments.length,
              itemBuilder: (context, index) {
                final payment = state.payments[index];
                return AdminPaymentListTile(
                  payment: payment,
                  onTapConfirm: () => _showConfirmationDialog(context, payment),
                );
              },
            );
          } else if (state is AdminPaymentsSparepartError) {
            return Center(child: Text('Error memuat riwayat pembayaran: ${state.message}'));
          }
          // Default return untuk state awal atau state yang tidak ditangani secara eksplisit
          return const Center(child: Text('Tekan tombol refresh untuk memuat data.'));
          // Anda bisa menambahkan FloatingActionButton untuk refresh manual jika perlu
        },
      ),
    );
  }
}