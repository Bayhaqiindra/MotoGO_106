// lib/presentation/pelanggan/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_all_sparepart_response_model.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/bloc/sparepart_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/home/product_card.dart'; // Pastikan ProductCard diimpor dengan benar

// Import ini akan ditambahkan nanti (jika diperlukan oleh navigasi lain)
// import 'package:tugas_akhir/presentation/pelanggan/transaction/pages/transaction_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat semua sparepart saat HomeScreen pertama kali dimuat
    context.read<SparepartBloc>().add(FetchAllSpareparts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Warna latar belakang yang lebih lembut
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header lokasi dan search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Lokasi Anda",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Yogyakarta, Indonesia",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.black54),
                      ],
                    ),
                    const SizedBox(height: 20), // Jarak lebih besar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Cari sparepart...",
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder( // Border saat tidak fokus
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder( // Border saat fokus
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF3A60C0), width: 1.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A60C0),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3A60C0).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.tune, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Promo banner (Tanpa gambar aset, menggunakan gradien)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Margin lebih besar
                padding: const EdgeInsets.all(24), // Padding lebih besar
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Rounded lebih besar
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A60C0), Color(0xFF6A82FB)], // Gradien biru
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3A60C0).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Beli Satu\nGratis Satu!', // Teks lebih menarik
                        style: TextStyle(
                          fontSize: 26, // Ukuran font lebih besar
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    // Menambahkan ikon atau elemen visual sederhana
                    const Icon(
                      Icons.local_offer, // Contoh ikon
                      color: Colors.white,
                      size: 60,
                    ),
                  ],
                ),
              ),

              // Filter kategori
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      CategoryChip(label: 'Semua Sparepart', selected: true),
                      CategoryChip(label: 'Ban'),
                      CategoryChip(label: 'Oli'),
                      CategoryChip(label: 'Aki'),
                      CategoryChip(label: 'Rem'),
                      CategoryChip(label: 'Lampu'),
                      CategoryChip(label: 'Filter'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16), // Jarak sebelum grid produk

              // List Produk (Diubah menjadi BlocBuilder)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<SparepartBloc, SparepartState>(
                  builder: (context, state) {
                    if (state is SparepartLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AllSparepartsLoaded) {
                      if (state.spareparts.isEmpty) {
                        return const Center(
                          child: Text('Tidak ada sparepart ditemukan.'),
                        );
                      }
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16, // Spasi antar kolom
                          mainAxisSpacing: 16, // Spasi antar baris
                          childAspectRatio: 3 / 4.5, // Rasio aspek disesuaikan
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // Agar tidak ada scroll ganda
                        itemCount: state.spareparts.length,
                        itemBuilder: (context, index) {
                          final sparepart = state.spareparts[index];
                          return ProductCard(sparepart: sparepart); // Mengirim data sparepart ke ProductCard
                        },
                      );
                    } else if (state is SparepartError) {
                      return Center(
                        child: Text('Error memuat sparepart: ${state.message}'),
                      );
                    }
                    return const SizedBox.shrink(); // State awal atau tidak relevan
                  },
                ),
              ),
              const SizedBox(height: 20), // Padding bawah
            ],
          ),
        ),
      ),
    );
  }
}

// CategoryChip tetap sama, tapi sedikit penyesuaian gaya
class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const CategoryChip({required this.label, this.selected = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10), // Spasi antar chip
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8), // Padding lebih nyaman
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF3A60C0) : Colors.white, // Warna latar belakang chip
        borderRadius: BorderRadius.circular(25), // Lebih bulat
        border: Border.all(
          color: selected ? const Color(0xFF3A60C0) : Colors.grey.shade300, // Border
          width: 1.5,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: const Color(0xFF3A60C0).withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          fontSize: 15,
        ),
      ),
    );
  }
}