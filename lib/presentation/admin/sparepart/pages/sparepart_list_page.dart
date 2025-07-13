import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/components/error_display.dart';
import 'package:tugas_akhir/core/extensions/loading_indicator.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/bloc/sparepart_bloc.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/widget/delete_confirmation_dialog.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/widget/sparepart_card.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/pages/sparepart_form_page.dart'; // Untuk navigasi ke form
import 'package:tugas_akhir/presentation/admin/sparepart/pages/sparepart_detail_page.dart'; // Untuk navigasi ke detail

class SparepartListPage extends StatefulWidget {
  const SparepartListPage({super.key});

  @override
  State<SparepartListPage> createState() => _SparepartListPageState();
}

class _SparepartListPageState extends State<SparepartListPage> {
  @override
  void initState() {
    super.initState();
    // Panggil event untuk memuat semua sparepart saat halaman dimuat
    context.read<SparepartBloc>().add(const FetchAllSpareparts());
  }

  void _showDeleteConfirmationDialog(int sparepartId, String sparepartName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          itemName: sparepartName,
          onConfirm: () {
            context.read<SparepartBloc>().add(DeleteSparepart(id: sparepartId));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Sparepart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigasi ke halaman form untuk tambah sparepart baru
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SparepartFormPage()),
              ).then((result) {
                // Refresh daftar setelah kembali dari form (jika ada perubahan)
                if (result == true) {
                  context.read<SparepartBloc>().add(const FetchAllSpareparts());
                }
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<SparepartBloc, SparepartState>(
        listener: (context, state) {
          if (state is SparepartDeletedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Muat ulang daftar setelah penghapusan berhasil
            context.read<SparepartBloc>().add(const FetchAllSpareparts());
          } else if (state is SparepartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is SparepartCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Muat ulang daftar setelah penambahan berhasil
            context.read<SparepartBloc>().add(const FetchAllSpareparts());
          } else if (state is SparepartUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Muat ulang daftar setelah update berhasil
            context.read<SparepartBloc>().add(const FetchAllSpareparts());
          }
        },
        builder: (context, state) {
          if (state is SparepartLoading) {
            return const LoadingIndicator();
          } else if (state is AllSparepartsLoaded) {
            if (state.spareparts.isEmpty) {
              return const Center(child: Text('Tidak ada sparepart tersedia.'));
            }
            return ListView.builder(
              itemCount: state.spareparts.length,
              itemBuilder: (context, index) {
                final sparepart = state.spareparts[index];
                return SparepartCard(
                  sparepart: sparepart,
                  onTap: () {
                    // Navigasi ke halaman detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SparepartDetailPage(
                              sparepartId: sparepart.sparepartId!)),
                    );
                  },
                  onEdit: () {
                    // Navigasi ke halaman form untuk edit
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SparepartFormPage(sparepartId: sparepart.sparepartId)),
                    ).then((result) {
                      if (result == true) {
                        context.read<SparepartBloc>().add(const FetchAllSpareparts());
                      }
                    });
                  },
                  onDelete: () {
                    _showDeleteConfirmationDialog(
                        sparepart.sparepartId!, sparepart.name ?? 'Sparepart Ini');
                  },
                );
              },
            );
          } else if (state is SparepartError) {
            return ErrorDisplay(
              message: state.message,
              onRetry: () {
                context.read<SparepartBloc>().add(const FetchAllSpareparts());
              },
            );
          }
          return const Center(child: Text('Silakan muat data sparepart.'));
        },
      ),
    );
  }
}