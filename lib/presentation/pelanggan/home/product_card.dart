// lib/presentation/pelanggan/home/widgets/product_card.dart (Jika Anda memisahkannya, atau tetap di home_screen.dart)

import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_all_sparepart_response_model.dart';
import 'package:tugas_akhir/presentation/pelanggan/spareparts/pages/sparepart_detail_page.dart';

class ProductCard extends StatelessWidget {
  final GetallSparepartResponseModel sparepart; // Terima objek sparepart

  const ProductCard({required this.sparepart, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail sparepart
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SparepartDetailPage(
                sparepartId: sparepart.sparepartId!), // Pastikan id tidak null
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // Tampilkan gambar dari network
              child: sparepart.imageUrl != null && sparepart.imageUrl!.isNotEmpty
                  ? Image.network(
                      'http://10.0.2.2:8000/storage/${sparepart.imageUrl}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    )
                  : Image.asset(
                      'assets/images/no_image.png', // Gambar placeholder jika tidak ada gambar
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 8),
            Text(sparepart.name ?? 'Nama Tidak Diketahui', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(sparepart.description ?? 'Deskripsi Tidak Diketahui', style: const TextStyle(color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp ${sparepart.price ?? '0'}', // Tampilkan harga
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF3A60C0),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}