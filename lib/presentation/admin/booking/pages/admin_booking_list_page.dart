import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/presentation/admin/booking/bloc/admin_booking_bloc.dart';
import 'package:tugas_akhir/presentation/admin/booking/pages/admin_booking_detail_page.dart';
import 'package:tugas_akhir/presentation/admin/booking/widget/booking_card.dart';

class AdminBookingListPage extends StatefulWidget {
  const AdminBookingListPage({super.key});

  @override
  State<AdminBookingListPage> createState() => _AdminBookingListPageState();
}

class _AdminBookingListPageState extends State<AdminBookingListPage> {
  @override
  void initState() {
    super.initState();
    // Memuat semua booking saat halaman pertama kali dibuka
    context.read<AdminBookingBloc>().add(const GetAllBookingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Booking Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AdminBookingBloc>().add(const GetAllBookingsEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<AdminBookingBloc, AdminBookingState>(
        listener: (context, state) {
          // Menampilkan SnackBar untuk pesan error atau sukses
          if (state is AdminBookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AdminBookingActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Setelah aksi sukses, muat ulang daftar booking
            context.read<AdminBookingBloc>().add(const GetAllBookingsEvent());
          }
        },
        builder: (context, state) {
          if (state is AdminBookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminAllBookingsSuccess) {
            if (state.bookings.isEmpty) {
              return const Center(child: Text('Tidak ada booking yang tersedia.'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AdminBookingBloc>().add(const GetAllBookingsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  return BookingCard(
                    booking: booking,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminBookingDetailPage(bookingId: booking.bookingId!),
                        ),
                      ).then((_) {
                        // Muat ulang daftar saat kembali dari detail page
                        context.read<AdminBookingBloc>().add(const GetAllBookingsEvent());
                      });
                    },
                  );
                },
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
                      context.read<AdminBookingBloc>().add(const GetAllBookingsEvent());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Muat data booking...'));
        },
      ),
    );
  }
}