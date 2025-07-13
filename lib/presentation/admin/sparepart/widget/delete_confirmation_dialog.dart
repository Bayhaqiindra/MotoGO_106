import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.itemName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: Text('Apakah Anda yakin ingin menghapus $itemName ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Batalkan
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Konfirmasi
            onConfirm();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Hapus', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}