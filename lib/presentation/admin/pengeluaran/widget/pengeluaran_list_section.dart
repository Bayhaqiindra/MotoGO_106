import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/get_all_pengeluaran_response_model.dart';
import 'package:tugas_akhir/presentation/admin/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:tugas_akhir/presentation/admin/pengeluaran/widget/pengeluaran_list_item.dart';

class PengeluaranListSection extends StatelessWidget {
  final Function(int, Datum) onEdit;
  final Function(BuildContext, int) onDelete;

  const PengeluaranListSection({
    Key? key,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PengeluaranBloc, PengeluaranState>(
      listener: (context, state) {
        if (state is PengeluaranAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.response.message ?? 'Pengeluaran berhasil ditambahkan!')),
          );
        } else if (state is PengeluaranUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.response.message ?? 'Pengeluaran berhasil diperbarui!')),
          );
        } else if (state is PengeluaranDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.response.message ?? 'Pengeluaran berhasil dihapus!')),
          );
        } else if (state is PengeluaranError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        List<Datum> displayList = [];
        bool isLoading = false;

        if (state is PengeluaranLoading) {
          isLoading = true;
        } else if (state is PengeluaranLoaded) {
          displayList = state.pengeluaranList;
        } else if (state is PengeluaranUpdateLoading) {
          displayList = state.pengeluaranList;
          isLoading = true;
        } else if (state is PengeluaranError) {
          return Center(
            child: Text('Gagal memuat pengeluaran: ${state.message}'),
          );
        }

        if (isLoading && displayList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (displayList.isEmpty) {
          return const Center(child: Text('Tidak ada riwayat pengeluaran.'));
        }

        // Urutkan daftar berdasarkan tanggal terbaru (jika belum diurutkan oleh BLoC)
        displayList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            final pengeluaran = displayList[index];
            return PengeluaranListItem(
              pengeluaran: pengeluaran,
              onEdit: (id) {
                onEdit(id, pengeluaran);
              },
              onDelete: (id) {
                onDelete(context, id);
              },
            );
          },
        );
      },
    );
  }
}