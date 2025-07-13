import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/components/error_display.dart';
import 'package:tugas_akhir/core/extensions/loading_indicator.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/bloc/sparepart_bloc.dart';

class SparepartDetailPage extends StatefulWidget {
  final int sparepartId;
  

  const SparepartDetailPage({super.key, required this.sparepartId});

  @override
  State<SparepartDetailPage> createState() => _SparepartDetailPageState();
}

class _SparepartDetailPageState extends State<SparepartDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<SparepartBloc>().add(FetchSparepartById(id: widget.sparepartId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Sparepart'),
      ),
      body: BlocBuilder<SparepartBloc, SparepartState>(
        builder: (context, state) {
          if (state is SparepartLoading) {
            return const LoadingIndicator();
          } else if (state is SparepartByIdLoaded) {
            final sparepart = state.sparepart;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sparepart.imageUrl != null && sparepart.imageUrl!.isNotEmpty)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'http://10.0.2.2:8000/storage/${sparepart.imageUrl}', // URL gambar
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  _buildDetailRow('ID Sparepart:', sparepart.sparepartId.toString()),
                  _buildDetailRow('Nama:', sparepart.name ?? '-'),
                  _buildDetailRow('Deskripsi:', sparepart.description ?? '-'),
                  _buildDetailRow('Harga:', 'Rp ${sparepart.price ?? '0'}'),
                  _buildDetailRow('Stok:', sparepart.stockQuantity.toString()),
                  _buildDetailRow('Dibuat pada:', sparepart.createdAt?.toLocal().toString().split('.')[0] ?? '-'),
                  _buildDetailRow('Diperbarui pada:', sparepart.updatedAt?.toLocal().toString().split('.')[0] ?? '-'),
                ],
              ),
            );
          } else if (state is SparepartError) {
            return ErrorDisplay(
              message: state.message,
              onRetry: () {
                context.read<SparepartBloc>().add(FetchSparepartById(id: widget.sparepartId));
              },
            );
          }
          return const Center(child: Text('Muat detail sparepart...'));
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }
}