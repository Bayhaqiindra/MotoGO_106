// lib/presentation/pelanggan/widgets/booking_list_item.dart

import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/booking/get_all_booking_response_model.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

class BookingListItem extends StatelessWidget {
  final GetAllBookingResponseModel booking;
  final VoidCallback onTap;
  final VoidCallback? onConfirmPressed; // Callback untuk tombol konfirmasi

  const BookingListItem({
    Key? key,
    required this.booking,
    required this.onTap,
    this.onConfirmPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tentukan warna status
    Color statusColor;
    switch (booking.status?.toLowerCase()) {
      case 'menunggu':
        statusColor = Colors.orange;
        break;
      case 'diterima': // Asumsi 'diterima' adalah status dari admin sebelum dikonfirmasi pelanggan
        statusColor = Colors.blue;
        break;
      case 'dalam_pekerjaan':
        statusColor = Colors.purple;
        break;
      case 'selesai':
        statusColor = Colors.green;
        break;
      case 'dibatalkan':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2,
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
                    'Booking ID: ${booking.bookingId ?? "N/A"}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      booking.status?.toUpperCase() ?? 'N/A',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Layanan ID: ${booking.serviceId ?? "N/A"}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Lokasi: ${booking.pickupLocation ?? "N/A"}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Dibuat: ${booking.createdAt != null ? DateFormat('dd MMM yyyy, HH:mm').format(booking.createdAt!.toLocal()) : "N/A"}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (onConfirmPressed != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: onConfirmPressed,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Konfirmasi Layanan'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}