import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import model request untuk mengirim data konfirmasi
import 'package:tugas_akhir/data/model/request/admin/payment_service/konfirmasi_payment_service_request_model.dart';
// Import Bloc dan State yang relevan dari folder bloc Anda
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_service/bloc/admin_payment_service_bloc.dart';
// Jika Anda perlu menampilkan detail payment di dialog, import model response
// import 'package:tugas_akhir/data/model/response/admin/payment_service/admin_get_all_payment_service_response_model.dart';


class AdminPaymentConfirmationDialog extends StatefulWidget {
  final int paymentId; // Sesuaikan tipe data dengan event Anda (int)
  // Menghapus isConfirm karena sekarang pilihan ada di dalam dialog
  final VoidCallback onConfirmed; // Callback saat konfirmasi/penolakan berhasil

  const AdminPaymentConfirmationDialog({
    super.key,
    required this.paymentId,
    required this.onConfirmed, // Menggunakan onConfirmed
  });

  @override
  State<AdminPaymentConfirmationDialog> createState() => _AdminPaymentConfirmationDialogState();
}

class _AdminPaymentConfirmationDialogState extends State<AdminPaymentConfirmationDialog> {
  String? _selectedStatus; // 'confirmed' atau 'rejected'
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Anda bisa memberikan nilai default jika diinginkan, misal:
    // _selectedStatus = 'confirmed';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitConfirmation() {
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih status konfirmasi (Konfirmasi/Tolak).')),
      );
      return;
    }

    final requestModel = KonfirmasiPaymentServiceRequestModel(
      paymentStatus: _selectedStatus!,
    );

    context.read<AdminPaymentServiceBloc>().add(
      VerifyAdminServicePayment(
        paymentId: widget.paymentId,
        request: requestModel,
      ),
    );
    // Panggil callback setelah event dikirim.
    // Dialog akan ditutup oleh callback onConfirmed di _showConfirmationDialog dari parent page.
    widget.onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminPaymentServiceBloc, AdminPaymentServiceState>(
      listener: (context, state) {
        if (state is AdminPaymentServiceLoading) {
          // Opsional: Tampilkan loading indicator di dialog jika diperlukan
          // Untuk saat ini, diasumsikan loading akan ditangani oleh halaman induk
        } else if (state is AdminServicePaymentVerified) {
          // Snackbar sudah ditangani di parent page
          // Memastikan dialog ditutup setelah verifikasi berhasil
          // Navigator.of(context).pop(); // Ini akan dipanggil oleh widget.onConfirmed() di parent
        } else if (state is AdminPaymentServiceFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error konfirmasi: ${state.error}')),
          );
          // Biarkan dialog tetap terbuka agar user bisa mencoba lagi atau melihat error
        }
      },
      child: AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID Pembayaran: ${widget.paymentId}'),
              // Jika Anda ingin menampilkan lebih banyak detail payment di sini (total bayar, dll)
              // Anda perlu meneruskan objek 'payment' lengkap ke dialog ini, bukan hanya paymentId.
              // Contoh:
              // if (widget.payment is GetAllAdminPaymentServiceResponseodel)
              //   Text('Total Bayar: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(double.tryParse(widget.payment.totalAmount ?? '0') ?? 0)}'),
              //   Text('Nama Pelanggan: ${widget.payment.serviceConfirmation?.booking?.pelanggan?.name ?? '-'}'),
              const SizedBox(height: 16),
              Text(
                'Pilih Status:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              RadioListTile<String>(
                title: const Text('Konfirmasi (Pembayaran Diterima)'),
                value: 'selesai', // Sesuai dengan nilai enum/string di API
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Tolak (Pembayaran Ditolak)'),
                value: 'ditolak', // Sesuai dengan nilai enum/string di API
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Admin (Opsional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
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