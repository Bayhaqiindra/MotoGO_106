// lib/presentation/admin/payment_sparepart/widgets/admin_payment_confirmation_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/request/admin/payment_sparepart/konfirmasi_payment_sparepart_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_sparepart/admin_get_all_payment_sparepart_response_model.dart';
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_sparepart/bloc/admin_payment_sparepart_bloc.dart';

class AdminPaymentConfirmationDialog extends StatefulWidget {
  final GetallAdminPaymentSparepartResponseModel payment;
  final VoidCallback onConfirmed; // Callback saat konfirmasi berhasil

  const AdminPaymentConfirmationDialog({
    Key? key,
    required this.payment,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  State<AdminPaymentConfirmationDialog> createState() =>
      _AdminPaymentConfirmationDialogState();
}

class _AdminPaymentConfirmationDialogState
    extends State<AdminPaymentConfirmationDialog> {
  String? _selectedStatus; // 'approved' atau 'rejected'
  final TextEditingController _notesController =
      TextEditingController(); // Opsional untuk catatan

  @override
  void initState() {
    super.initState();
    // Default selected status jika ingin
    // _selectedStatus = 'approved';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitConfirmation() {
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih status konfirmasi (Verifikasi/Tolak).'),
        ),
      );
      return;
    }

    final requestModel = KonfirmasiPaymentSparepartRequestModel(
      paymentStatus: _selectedStatus!,
      // Anda bisa menambahkan properti lain seperti notes/reason jika API mendukungnya
      // notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    context.read<AdminPaymentSparepartBloc>().add(
      ConfirmAdminPaymentSparepart(
        paymentId: widget.payment.paymentId!, // Asumsi payment.id tidak null
        requestModel: requestModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminPaymentSparepartBloc, AdminPaymentSparepartState>(
      listener: (context, state) {
        if (state is AdminPaymentSparepartConfirmationLoading) {
          // Opsional: Tampilkan loading indicator di dialog
          // Karena sudah ada di BlocListener page, mungkin tidak perlu di sini
        } else if (state is AdminPaymentSparepartConfirmationSuccess) {
          // Panggil callback ke halaman induk untuk refresh data
          widget.onConfirmed();
          // Dialog akan ditutup oleh onConfirmed callback di _showConfirmationDialog
        } else if (state is AdminPaymentSparepartConfirmationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error konfirmasi: ${state.message}')),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Transaksi ID: ${widget.payment.transactionId}'),
              Text('Total Bayar: Rp ${widget.payment.totalPembayaran}'),
              const SizedBox(height: 16),
              Text(
                'Pilih Status:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              RadioListTile<String>(
                title: const Text('Verifikasi (Pembayaran Diterima)'),
                value: 'selesai',
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Tolak (Pembayaran Ditolak)'),
                value: 'ditolak',
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              // Opsional: Field untuk catatan/alasan
              // const SizedBox(height: 16),
              // TextField(
              //   controller: _notesController,
              //   decoration: const InputDecoration(
              //     labelText: 'Catatan (Opsional)',
              //     border: OutlineInputBorder(),
              //   ),
              //   maxLines: 3,
              // ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _submitConfirmation,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A60C0),
              foregroundColor: Colors.white,
            ),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }
}
