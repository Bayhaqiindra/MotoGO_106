import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/response/admin/data_booking/admin_get_all_booking_response_model.dart';
import 'package:tugas_akhir/presentation/admin/booking/bloc/admin_booking_bloc.dart';
import 'package:tugas_akhir/presentation/admin/booking/widget/confirm_service_form.dart';
import 'package:tugas_akhir/presentation/admin/booking/widget/status_action_buttons.dart';

class AdminBookingDetailPage extends StatefulWidget {
  final int bookingId;
  const AdminBookingDetailPage({super.key, required this.bookingId});

  @override
  State<AdminBookingDetailPage> createState() => _AdminBookingDetailPageState();
}

class _AdminBookingDetailPageState extends State<AdminBookingDetailPage> {
  @override
  void initState() {
    super.initState();
    // Memuat detail booking saat halaman pertama kali dibuka
    context.read<AdminBookingBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Booking'),
      ),
      body: BlocConsumer<AdminBookingBloc, AdminBookingState>(
        listener: (context, state) {
          // Menampilkan SnackBar untuk pesan error atau sukses dari operasi di detail page
          if (state is AdminBookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AdminBookingActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Setelah aksi sukses, muat ulang detail untuk menampilkan perubahan
            context.read<AdminBookingBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
          } else if (state is AdminServiceConfirmationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Layanan berhasil dikonfirmasi dan dikirim ke pelanggan!')),
            );
            // Muat ulang detail setelah konfirmasi
            context.read<AdminBookingBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
          }
        },
        builder: (context, state) {
          if (state is AdminBookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminBookingDetailSuccess) {
            final booking = state.bookingDetail;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookingInfo(booking),
                  const Divider(height: 30, thickness: 1),

                  // Bagian untuk mengubah status booking
                  StatusActionButtons(
                    currentStatus: booking.status,
                    onUpdateStatus: (newStatus) {
                      context.read<AdminBookingBloc>().add(
                        UpdateBookingStatusEvent(
                          bookingId: booking.bookingId!,
                          newStatus: newStatus,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 30, thickness: 1),

                  // Bagian untuk konfirmasi layanan
                  ConfirmServiceForm(
                    booking: booking,
                    onConfirm: (
                      bookingId,
                      serviceId,
                      serviceStatus,
                      totalCost,
                      adminNotes,
                    ) {
                      context.read<AdminBookingBloc>().add(
                        ConfirmServiceEvent(
                          bookingId: bookingId,
                          serviceId: serviceId,
                          serviceStatus: serviceStatus,
                          totalCost: totalCost,
                          adminNotes: adminNotes,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is AdminBookingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AdminBookingBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Memuat detail booking...'));
        },
      ),
    );
  }

  // Helper method untuk membangun info booking
  Widget _buildBookingInfo(AdmingetallbookingResponseModel booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Booking ID: ${booking.bookingId ?? 'N/A'}', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Nama Pelanggan: ${booking.pelanggan?.name ?? 'Anonim'}', style: Theme.of(context).textTheme.titleMedium),
        Text('No. Telepon: ${booking.pelanggan?.phone ?? 'N/A'}', style: Theme.of(context).textTheme.bodyLarge),
        Text('Alamat: ${booking.pelanggan?.address ?? 'N/A'}', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Text('Catatan Pelanggan: ${booking.customerNotes ?? 'Tidak ada catatan'}', style: Theme.of(context).textTheme.bodyMedium),
        Text('Lokasi Penjemputan: ${booking.pickupLocation ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
        Text('Status Booking: ${booking.status ?? 'N/A'}', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
        Text('Dibuat: ${booking.createdAt?.toLocal().toString().split('.')[0] ?? 'N/A'}'),
        Text('Terakhir Diperbarui: ${booking.updatedAt?.toLocal().toString().split('.')[0] ?? 'N/A'}'),
      ],
    );
  }
}