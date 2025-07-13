// lib/presentation/pelanggan/home/widgets/product_card.dart (Jika Anda memisahkannya, atau tetap di home_screen.dart)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_all_sparepart_response_model.dart';
import 'package:tugas_akhir/presentation/pelanggan/spareparts/pages/sparepart_detail_page.dart';

class ProductCard extends StatelessWidget {
  final GetallSparepartResponseModel sparepart; // Terima objek sparepart
  static const String _baseUrl = 'http://10.0.2.2:8000'; // Base URL untuk gambar

  const ProductCard({required this.sparepart, super.key});

  // Helper untuk format mata uang
  String _formatCurrency(String? price) {
    if (price == null || price.isEmpty) return 'Rp 0';
    try {
      final double amount = double.parse(price);
      final NumberFormat formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      return formatter.format(amount);
    } catch (e) {
      return 'Rp $price'; // Fallback jika parsing gagal
    }
  }

  // Helper untuk membangun URL gambar yang benar dari backend
  String _getNetworkImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return ''; // Mengembalikan string kosong jika tidak ada path yang valid untuk gambar network
    }
    // Memeriksa apakah path sudah merupakan URL lengkap
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    } else {
      // Jika hanya path relatif, tambahkan '/storage/' di depan path, lalu tambahkan base URL
      // Ini mengasumsikan Anda telah menjalankan 'php artisan storage:link' di Laravel
      return '$_baseUrl/storage/$path';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String networkImageUrl = _getNetworkImageUrl(sparepart.imageUrl);
    final bool hasNetworkImage = networkImageUrl.isNotEmpty;

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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // Shadow lebih lembut
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // Tampilkan gambar dari network jika ada, jika tidak, langsung gunakan aset lokal
              child: ClipRRect( // Tambahkan ClipRRect untuk border radius pada gambar
                borderRadius: BorderRadius.circular(12),
                child: hasNetworkImage
                    ? Image.network(
                        networkImageUrl, // Menggunakan URL gambar network yang sudah divalidasi
                        fit: BoxFit.cover,
                        width: double.infinity, // Memastikan gambar mengisi lebar yang tersedia
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200, // Background abu-abu untuk placeholder
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/images/no_image.png', // Gambar placeholder lokal jika tidak ada gambar network
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12), // Jarak lebih besar
            Text(
              sparepart.name ?? 'Nama Tidak Diketahui',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              sparepart.description ?? 'Deskripsi Tidak Diketahui',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatCurrency(sparepart.price), // Tampilkan harga dengan format
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF3A60C0), // Warna harga yang menonjol
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A60C0),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3A60C0).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(6.0), // Padding untuk ikon
                    child: Icon(Icons.add, color: Colors.white, size: 20), // Ukuran ikon disesuaikan
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}