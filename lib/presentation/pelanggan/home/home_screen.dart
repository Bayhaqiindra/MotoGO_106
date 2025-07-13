// lib/presentation/pelanggan/home/home_screen.dart (Atau path di mana HomeScreen berada)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_all_sparepart_response_model.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/bloc/sparepart_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/home/product_card.dart';

// Import ini akan ditambahkan nanti
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
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header lokasi dan search (kode yang sudah ada)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Location", style: TextStyle(color: Colors.grey)),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Yogyakarta, Indonesia", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search sparepart...",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
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
                          ),
                          child: const Icon(Icons.tune, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Promo banner (kode yang sudah ada)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.brown.shade200,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/promo_banner.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Text(
                  'Buy one get\none FREE',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),

              // Filter kategori (kode yang sudah ada)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      CategoryChip(label: 'All Spareparts', selected: true),
                      CategoryChip(label: 'Ban'),
                      CategoryChip(label: 'Oli'),
                      CategoryChip(label: 'Aki'),
                    ],
                  ),
                ),
              ),

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
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3 / 4.2,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
            ],
          ),
        ),
      ),
    );
  }
}

// CategoryChip tetap sama
class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const CategoryChip({required this.label, this.selected = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF3A60C0) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }
}