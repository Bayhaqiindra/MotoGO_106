import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/core/constants/colors.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/get_all_pengeluaran_response_model.dart';

// --- IMPORTS FOR BLOCS ---
import 'package:tugas_akhir/presentation/admin/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:tugas_akhir/presentation/admin/pengeluaran/widget/balance_cards.dart';
import 'package:tugas_akhir/presentation/admin/pengeluaran/widget/pengeluaran_list_section.dart';
import 'package:tugas_akhir/presentation/admin/total_pengeluaran/bloc/total_pengeluaran_bloc.dart';
import 'package:tugas_akhir/presentation/admin/total_pemasukan/bloc/total_pemasukan_bloc.dart';
import 'package:tugas_akhir/presentation/admin/laporan/bloc/laporan_export_pdf_bloc.dart';

// --- IMPORTS FOR PAGES ---
import 'package:tugas_akhir/presentation/admin/pengeluaran/pages/add_pengeluaran_page.dart';
import 'package:tugas_akhir/presentation/admin/pengeluaran/pages/edit_pengeluaran_page.dart';

import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class PengeluaranPage extends StatefulWidget {
  const PengeluaranPage({super.key});

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // Fungsi untuk memuat ulang semua data
  Future<void> _loadAllData() async {
    context.read<PengeluaranBloc>().add(const LoadPengeluaran());
    context.read<TotalPengeluaranBloc>().add(const LoadTotalPengeluaran());
    context.read<TotalPemasukanBloc>().add(const LoadTotalPemasukan());
  }

  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus pengeluaran ini?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<PengeluaranBloc>().add(DeletePengeluaran(id: id));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Path ke gambar latar belakang Anda di folder assets.
    // GANTI 'assets/images/pengeluaran_background.png' DENGAN PATH GAMBAR ASLI ANDA!
    const String backgroundAssetPath = 'assets/images/background.jpg';

    return BlocListener<LaporanExportPdfBloc, LaporanExportPdfState>(
      listener: (context, state) async {
        if (state is LaporanExportPdfLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mempersiapkan laporan PDF...')),
          );
        } else if (state is LaporanExportPdfLoaded) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          try {
            final directory = await getTemporaryDirectory();
            final filePath = '${directory.path}/laporan_keuangan.pdf';
            final file = File(filePath);
            await file.writeAsBytes(state.pdfBytes);
            final result = await OpenFilex.open(filePath);

            if (result.type != ResultType.done) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal membuka PDF: ${result.message}')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan PDF berhasil diunduh dan dibuka.'),
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error saat menyimpan/membuka PDF: ${e.toString()}',
                ),
              ),
            );
          }
        } else if (state is LaporanExportPdfError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor:
            AppColors
                .primary, // Background hijau tua untuk keseluruhan Scaffold
        body: RefreshIndicator(
          onRefresh: _loadAllData,
          child: Stack(
            children: [
              // Bagian Header (hijau tua) - sekarang hanya untuk judul dan padding atas
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: screenHeight * 0.45, // Tinggi area gambar
                child: Container(
                  decoration: BoxDecoration(
                    // Mengganti 'color' dengan 'image' untuk latar belakang gambar
                    image: const DecorationImage(
                      image: AssetImage(
                        backgroundAssetPath,
                      ), // <--- Menggunakan AssetImage
                      fit:
                          BoxFit
                              .cover, // Memastikan gambar menutupi seluruh area
                      // Opsional: colorFilter untuk membuat teks lebih mudah dibaca di atas gambar
                      colorFilter: ColorFilter.mode(
                        Colors.black54, // Overlay hitam transparan
                        BlendMode
                            .darken, // Mode blend untuk menggelapkan gambar
                      ),
                    ),
                  ),
                ),
              ),

              // Kartu Total Balance, Pemasukan, Pengeluaran (di atas area hijau)
              Positioned(
                top: statusBarHeight + 20, // Posisi judul "Laporan Keuangan"
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Laporan Keuangan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<LaporanExportPdfBloc>().add(
                              const ExportLaporanPdf(),
                            );
                          },
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Export Laporan PDF',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              45,
                              131,
                              37,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<
                              TotalPemasukanBloc,
                              TotalPemasukanState
                            >(
                              builder: (context, state) {
                                double totalPemasukan = 0;
                                if (state is TotalPemasukanLoaded) {
                                  totalPemasukan =
                                      (state.pemasukanData.totalPemasukan ?? 0)
                                          .toDouble();
                                }
                                return SizedBox(
                                  height:
                                      130, // Tinggi yang sedikit lebih besar
                                  child: BalanceCard(
                                    title: 'Pemasukan',
                                    amount: totalPemasukan,
                                    isIncome: true,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: BlocBuilder<
                              TotalPengeluaranBloc,
                              TotalPengeluaranState
                            >(
                              builder: (context, state) {
                                double totalPengeluaran = 0;
                                if (state is TotalPengeluaranLoaded) {
                                  totalPengeluaran = state.total.toDouble();
                                }
                                return SizedBox(
                                  height:
                                      130, // Tinggi yang sedikit lebih besar
                                  child: BalanceCard(
                                    title: 'Pengeluaran',
                                    amount: totalPengeluaran,
                                    isIncome: false,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Konten utama (daftar pengeluaran) dalam Container putih yang memenuhi lebar dan tinggi sisa
              Positioned(
                top: screenHeight * 0.45 - 30, // Posisi awal riwayat transaksi
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ), // Warna putih untuk list section
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Riwayat Pengeluaran',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const AddPengeluaranPage(),
                                  ),
                                );
                                _loadAllData();
                              },
                              backgroundColor: Color(0xFFDCCBAF),
                              foregroundColor: Colors.white,
                              mini: true,
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: PengeluaranListSection(
                          onEdit: (id, initialData) async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EditPengeluaranPage(
                                      pengeluaranId: id,
                                      initialData: initialData,
                                    ),
                              ),
                            );
                            _loadAllData();
                          },
                          onDelete: _showDeleteConfirmationDialog,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
