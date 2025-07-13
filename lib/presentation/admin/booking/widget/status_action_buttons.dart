import 'package:flutter/material.dart';

class StatusActionButtons extends StatelessWidget {
  final String? currentStatus;
  final Function(String newStatus) onUpdateStatus;

  const StatusActionButtons({
    super.key,
    required this.currentStatus,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ubah Status Booking (Saat Ini: ${currentStatus?.toUpperCase() ?? 'N/A'})',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0, // Spasi horizontal antar tombol
          runSpacing: 10.0, // Spasi vertikal antar baris tombol
          children: [
            _buildStatusButton(context, 'diterima', 'Terima Booking', Colors.green),
            _buildStatusButton(context, 'ditolak', 'Tolak Booking', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusButton(BuildContext context, String statusValue, String buttonText, Color color) {
    // Disable tombol jika status saat ini sudah sama
    final bool isDisabled = currentStatus?.toLowerCase() == statusValue.toLowerCase();

    return ElevatedButton.icon(
      onPressed: isDisabled ? null : () => onUpdateStatus(statusValue),
      icon: _getIconForStatus(statusValue),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
  }

  Icon _getIconForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'diterima':
        return const Icon(Icons.check_circle_outline);
      case 'ditolak':
        return const Icon(Icons.cancel_outlined);
      default:
        return const Icon(Icons.hourglass_empty);
    }
  }
}