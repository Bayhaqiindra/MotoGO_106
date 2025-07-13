// lib/presentation/pelanggan/pages/customer_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/extensions/error_retry_widget.dart';
// Hapus import yang tidak digunakan jika LoadingIndicator dan LoadingPayment
// tidak lagi berfungsi sebagai overlay atau di-refaktor menjadi widget inline.
// import 'package:tugas_akhir/core/extensions/loading_indicator.dart';
// import 'package:tugas_akhir/core/extensions/loading_payment.dart';

// Imports untuk Booking History
import 'package:tugas_akhir/presentation/pelanggan/booking/bloc/booking_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/history/pages/customer_booking_detail_page.dart';
import 'package:tugas_akhir/presentation/pelanggan/history/widget/booking_list_item.dart';

// Imports untuk Payment Service History (PASTIKAN PATH INI BENAR)
import 'package:tugas_akhir/data/model/response/pelanggan/payment_service/get_all_payment_service_response_model.dart';
import 'package:tugas_akhir/presentation/pelanggan/payment_service/bloc/pelanggan_payment_service_bloc.dart';


class CustomerHistoryPage extends StatefulWidget {
  const CustomerHistoryPage({Key? key}) : super(key: key);

  @override
  State<CustomerHistoryPage> createState() => _CustomerHistoryPageState();
}

class _CustomerHistoryPageState extends State<CustomerHistoryPage> {
  @override
  void initState() {
    super.initState();
    // Panggil event untuk memuat riwayat booking dan riwayat pembayaran layanan
    context.read<BookingBloc>().add(GetCustomerBookings());
    context.read<PelangganPaymentServiceBloc>().add(const LoadCustomerServicePayments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Aktivitas Layanan Saya'), // Ubah judul agar lebih umum
        backgroundColor: const Color(0xFF3A60C0), // Tambahkan warna jika perlu
        foregroundColor: Colors.white, // Tambahkan warna teks jika perlu
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding untuk seluruh konten
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Agar teks rata kiri
          children: [
            // --- Bagian Riwayat Booking ---
            Text(
              'Riwayat Booking Saya',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            const Divider(), // Garis pemisah
            BlocConsumer<BookingBloc, BookingState>(
              listener: (context, state) {
                if (state is BookingFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error Booking: ${state.error} ❌')),
                  );
                } else if (state is CustomerBookingConfirmedSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  // Muat ulang riwayat booking setelah konfirmasi
                  context.read<BookingBloc>().add(GetCustomerBookings());
                }
              },
              builder: (context, state) {
                if (state is BookingLoading) {
                  return const Center(child: CircularProgressIndicator()); // Indikator loading
                } else if (state is CustomerBookingsSuccess) {
                  if (state.bookings.isEmpty) {
                    return const Center(child: Text('Anda belum memiliki riwayat booking.'));
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scroll ListView
                    shrinkWrap: true, // Biarkan ListView mengambil ruang seperlunya
                    itemCount: state.bookings.length,
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      final bool showConfirmButton = booking.status?.toLowerCase() == 'diterima';

                      return BookingListItem(
                        booking: booking,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerBookingDetailPage(
                                bookingId: booking.bookingId!,
                                initialBookingData: booking,
                              ),
                            ),
                          );
                        },
                        onConfirmPressed: showConfirmButton
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomerBookingDetailPage(
                                      bookingId: booking.bookingId!,
                                      initialBookingData: booking,
                                      showConfirmationOnLoad: true,
                                    ),
                                  ),
                                );
                              }
                            : null,
                      );
                    },
                  );
                } else if (state is BookingFailure) {
                  return ErrorRetryWidget(
                    message: state.error,
                    onRetry: () {
                      context.read<BookingBloc>().add(GetCustomerBookings());
                    },
                  );
                }
                return const SizedBox.shrink(); // Widget kosong jika tidak ada state yang cocok
              },
            ),

            const SizedBox(height: 32), // Spasi antar dua bagian riwayat

            // --- Bagian Riwayat Pembayaran Layanan ---
            Text(
              'Riwayat Pembayaran Layanan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            const Divider(), // Garis pemisah
            BlocConsumer<PelangganPaymentServiceBloc, PelangganPaymentServiceState>(
              listener: (context, state) {
                if (state is PelangganPaymentServiceFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error Pembayaran Layanan: ${state.error} ❌')),
                  );
                }
                // Jika pembayaran berhasil, muat ulang riwayat pembayaran layanan
                if (state is PelangganPaymentServiceSubmissionSuccess) {
                  context.read<PelangganPaymentServiceBloc>().add(const LoadCustomerServicePayments());
                }
              },
              builder: (context, state) {
                // Di sini Anda bisa membedakan loading untuk history vs submission jika perlu,
                // tapi untuk kesederhanaan kita gunakan satu state loading.
                if (state is PelangganPaymentServiceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CustomerServicePaymentsLoaded) { // Pastikan nama state ini benar
                  if (state.payments.isEmpty) {
                    return const Center(child: Text('Anda belum memiliki riwayat pembayaran layanan.'));
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.payments.length,
                    itemBuilder: (context, index) {
                      final payment = state.payments[index];
                      // Pastikan properti di sini sesuai dengan GetAllPaymentServicetResponseModel Anda
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Icon(Icons.receipt_long, color: Color(0xFF3A60C0)),
                          title: Text(
                            'ID Konfirmasi: ${payment.confirmationId ?? 'N/A'}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Status: ${payment.paymentStatus ?? 'N/A'}'), // <-- PERUBAHAN DI SINI
                              Text('Metode: ${payment.metodePembayaran ?? '-'}'),
                              // Ganti totalPrice dengan totalAmount
                              Text('Total Bayar: Rp ${payment.totalAmount ?? '0'}'), // <-- PERUBAHAN DI SINI
                              Text(
                                'Tanggal: ${payment.paymentDate?.toLocal().toString().split(' ')[0] ?? '-'}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              if (payment.buktiPembayaran != null && payment.buktiPembayaran!.isNotEmpty)
                                Text(
                                  'Bukti: ${payment.buktiPembayaran!.split('/').last}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                            ],
                          ),
                          // Optional: onTap untuk melihat detail pembayaran layanan
                          // onTap: () {
                          //   if (payment.paymentServiceId != null) {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => PaymentServiceDetailScreen(paymentId: payment.paymentServiceId!),
                          //       ),
                          //     );
                          //   }
                          // },
                        ),
                      );
                    },
                  );
                } else if (state is PelangganPaymentServiceFailure) {
                  return ErrorRetryWidget(
                    message: state.error,
                    onRetry: () {
                      context.read<PelangganPaymentServiceBloc>().add(const LoadCustomerServicePayments());
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}