import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/model/response/admin/data_booking/admin_get_all_booking_response_model.dart';

class BookingCard extends StatelessWidget {
  final AdmingetallbookingResponseModel booking;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Helper untuk menentukan warna status
    Color _getStatusColor(String? status) {
      switch (status?.toLowerCase()) {
        case 'diterima':
          return Colors.green[700]!;
        case 'ditolak':
          return Colors.red[700]!;
        case 'dikonfirmasi':
          return Colors.blue[700]!;
        case 'menunggu':
        default:
          return Colors.grey[600]!;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking ID: #${booking.bookingId ?? 'N/A'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      booking.status?.toUpperCase() ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Pelanggan: ${booking.pelanggan?.name ?? 'Anonim'}',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                'Layanan ID: ${booking.serviceId ?? 'N/A'}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Lokasi: ${booking.pickupLocation ?? 'N/A'}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Dibuat: ${booking.createdAt?.toLocal().toString().split('.')[0] ?? 'N/A'}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}