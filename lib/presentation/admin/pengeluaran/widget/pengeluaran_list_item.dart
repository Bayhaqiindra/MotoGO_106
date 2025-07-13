import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/get_all_pengeluaran_response_model.dart';

class PengeluaranListItem extends StatelessWidget {
  final Datum pengeluaran;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const PengeluaranListItem({
    Key? key,
    required this.pengeluaran,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 6, // Meningkatkan elevasi untuk bayangan yang lebih menonjol
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), // Lebih rounded lagi
      child: Container( // Menggunakan Container untuk background color dan border
        decoration: BoxDecoration(
          color: Colors.white, // Latar belakang kartu putih
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1), // Border tipis
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // Warna bayangan lebih gelap
              spreadRadius: 2,
              blurRadius: 12, // Blur yang lebih halus
              offset: const Offset(0, 4), // Bayangan ke bawah
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Detail Pengeluaran (Kategori dan Tanggal)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pengeluaran.categoryPengeluaran ?? 'Tidak Ada Kategori',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      // Format tanggal: HH:mm - Bulan dd
                      '${DateFormat('HH:mm').format(pengeluaran.createdAt!)} - ${DateFormat('MMMM dd').format(pengeluaran.createdAt!)}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Jumlah Pengeluaran dan Tombol Aksi
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormatter.format(double.tryParse(pengeluaran.jumlahPengeluaran ?? '0') ?? 0),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: (double.tryParse(pengeluaran.jumlahPengeluaran ?? '0') ?? 0) > 0 ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_note_outlined, color: Colors.blue, size: 22),
                        onPressed: () {
                          if (pengeluaran.pengeluaranId != null) {
                            onEdit(pengeluaran.pengeluaranId!);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                        onPressed: () {
                          if (pengeluaran.pengeluaranId != null) {
                            onDelete(pengeluaran.pengeluaranId!);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
