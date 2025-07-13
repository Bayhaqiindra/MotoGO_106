// lib/presentation/pelanggan/sparepart/pages/sparepart_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    // Memuat detail sparepart berdasarkan ID saat halaman diinisialisasi
    context.read<SparepartBloc>().add(FetchSparepartById(id: widget.sparepartId));
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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
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
                      child: sparepart.imageUrl != null && sparepart.imageUrl!.isNotEmpty
                          ? Image.network(
                              'http://10.0.2.2:8000/storage/${sparepart.imageUrl}', // Pastikan URL ini benar
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                              ),
                            )
                          : Image.asset(
                              'assets/images/no_image.png', // Placeholder jika tidak ada gambar
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    sparepart.name ?? 'Nama Tidak Diketahui',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Format harga agar lebih mudah dibaca
                    'Rp ${sparepart.price?.toStringAsFixed(0) ?? '0'}',
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sparepart.description ?? 'Tidak ada deskripsi.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Stok Tersedia: ${sparepart.stockQuantity ?? 0}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20), // Jarak sebelum quantity picker

                  // ✨ Quantity Picker (Tombol + dan -) ✨
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tombol Kurang
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          // Pastikan kuantitas tidak kurang dari 1
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                      ),
                      // Tampilan Kuantitas
                      Text(
                        _quantity.toString(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // Tombol Tambah
                      IconButton(
                        icon: const Icon(Icons.add_circle),
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
                            // --- LOG DEBUG DIMULAI ---
        print('Navigating to TransactionConfirmationPage...');
        print('Sparepart details being passed:');
        print('  ID: ${sparepart.sparepartId}');
        print('  Name: ${sparepart.name}');
        print('  Price: ${sparepart.price}');
        print('  Quantity selected: $_quantity');
        // --- LOG DEBUG BERAKHIR ---
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
                      ),
                    ),
                  ),
                ],
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