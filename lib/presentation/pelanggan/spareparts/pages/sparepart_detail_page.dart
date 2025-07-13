// lib/presentation/pelanggan/sparepart/pages/sparepart_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_by_id_sparepart_response_model.dart';

import 'package:tugas_akhir/presentation/admin/sparepart/bloc/sparepart_bloc.dart';
// Pastikan path ini benar. Jika TransactionConfirmationPage ada di folder 'pages', sesuaikan importnya:
import 'package:tugas_akhir/presentation/pelanggan/transaction/widget/transaction_confirmation_page.dart';
// Atau jika di 'pages':
// import 'package:tugas_akhir/presentation/pelanggan/transaction/pages/transaction_confirmation_page.dart';


class SparepartDetailPage extends StatefulWidget {
  final int sparepartId;

  const SparepartDetailPage({super.key, required this.sparepartId});

  @override
  State<SparepartDetailPage> createState() => _SparepartDetailPageState();
}

class _SparepartDetailPageState extends State<SparepartDetailPage> {
  // Deklarasi state untuk kuantitas yang dipilih
  int _quantity = 1;
  static const String _baseUrl = 'http://10.0.2.2:8000'; // Base URL untuk gambar

  @override
  void initState() {
    super.initState();
    // Memuat detail sparepart berdasarkan ID saat halaman diinisialisasi
    context.read<SparepartBloc>().add(FetchSparepartById(id: widget.sparepartId));
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

  // Helper untuk membersihkan dan mengonversi string harga ke double, lalu memformatnya
  String _parseAndFormatCurrency(double? priceValue) { // Mengubah tipe parameter menjadi double?
    if (priceValue == null) {
      return 'Rp 0';
    }

    // Format mata uang ke Rupiah tanpa desimal
    final NumberFormat formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(priceValue);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Sparepart'),
        backgroundColor: const Color(0xFF3A60C0),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<SparepartBloc, SparepartState>(
        builder: (context, state) {
          if (state is SparepartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SparepartByIdLoaded) {
            // Pastikan sparepart tidak null sebelum diakses
            final GetSparepartByIdResponseModel sparepart = state.sparepart;

            // Tambahkan cek jika sparepart benar-benar null (walaupun Bloc sudah mengindikasikan Loaded)
            if (sparepart == null) {
              return const Center(child: Text('Data sparepart tidak ditemukan.'));
            }

            final String networkImageUrl = _getNetworkImageUrl(sparepart.imageUrl);
            final bool hasNetworkImage = networkImageUrl.isNotEmpty;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card( // Membungkus konten dalam Card
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.all(8.0), // Margin di sekitar Card
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[200],
                          ),
                          child: ClipRRect( // Tambahkan ClipRRect untuk border radius pada gambar
                            borderRadius: BorderRadius.circular(16),
                            child: hasNetworkImage
                                ? Image.network(
                                    networkImageUrl, // Menggunakan URL gambar network yang sudah divalidasi
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/no_image.png', // Placeholder lokal
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        sparepart.name ?? 'Nama Tidak Diketahui',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        // Menggunakan helper baru untuk parsing dan formatting
                        _parseAndFormatCurrency(sparepart.price), // sparepart.price sekarang diasumsikan double?
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Deskripsi Produk:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sparepart.description ?? 'Tidak ada deskripsi.',
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Stok Tersedia: ${sparepart.stockQuantity ?? 0}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 20), // Jarak sebelum quantity picker

                      // ✨ Quantity Picker (Tombol + dan -) ✨
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Tombol Kurang
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.remove, color: Color(0xFF3A60C0)),
                              onPressed: () {
                                // Pastikan kuantitas tidak kurang dari 1
                                if (_quantity > 1) {
                                  setState(() {
                                    _quantity--;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Tampilan Kuantitas
                          Text(
                            _quantity.toString(),
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(width: 16),
                          // Tombol Tambah
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Color(0xFF3A60C0)),
                              onPressed: () {
                                // Pastikan kuantitas tidak melebihi stok yang tersedia
                                if (_quantity < (sparepart.stockQuantity ?? 0)) {
                                  setState(() {
                                    _quantity++;
                                  });
                                } else {
                                  // Opsional: Tampilkan SnackBar jika stok tidak mencukupi
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Stok tidak mencukupi!')),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32), // Jarak sebelum tombol beli

                      // ✨ Tombol "Beli Sekarang" ✨
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          // Tombol akan aktif hanya jika stok > 0
                          onPressed: (sparepart.stockQuantity ?? 0) > 0
                              ? () {
                                  // Navigasi ke halaman TransactionConfirmationPage
                                  // Meneruskan objek sparepart dan _quantity yang sudah dipilih
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TransactionConfirmationPage(
                                        sparepart: sparepart,
                                        quantity: _quantity,
                                      ),
                                    ),
                                  );
                                }
                              : null, // Jika stok 0, onPressed menjadi null (tombol dinonaktifkan)
                          icon: const Icon(Icons.shopping_cart, color: Colors.white),
                          label: const Text(
                            'Beli Sekarang',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A60C0),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5, // Tambahkan sedikit elevasi
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is SparepartError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          // Default fallback jika tidak ada data atau state tidak dikenali
          return const Center(child: Text('Sparepart tidak ditemukan.'));
        },
      ),
    );
  }
}
