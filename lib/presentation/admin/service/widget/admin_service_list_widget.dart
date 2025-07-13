import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/response/admin/service/get_all_service_response_model.dart';
import 'package:tugas_akhir/presentation/admin/service/bloc/service_bloc.dart';
import 'package:tugas_akhir/core/constants/colors.dart'; // Import AppColors

class AdminServiceList extends StatelessWidget {
  final Function(int serviceId, String name, int cost) onEdit;

  const AdminServiceList({
    super.key,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ServiceFailure) {
          return Center(child: Text('Gagal memuat layanan: ${state.message}'));
        } else if (state is ServiceListSuccess) {
          if (state.services.isEmpty) {
            return const Center(child: Text('Belum ada layanan.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding untuk seluruh list
            itemCount: state.services.length,
            itemBuilder: (context, index) {
              final service = state.services[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin antar kartu
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Sudut membulat pada kartu
                ),
                elevation: 4, // Efek bayangan pada kartu
                child: InkWell( // Membuat seluruh kartu bisa diklik
                  onTap: () {
                    // Ketika kartu diklik, panggil onEdit
                    onEdit(
                      service.serviceId!,
                      service.serviceName ?? '',
                      service.serviceCost ?? 0,
                    );
                  },
                  borderRadius: BorderRadius.circular(15.0), // Pastikan borderRadius InkWell sesuai Card
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Padding internal ListTile
                    child: Row(
                      children: [
                        // Ikon Edit di sebelah kiri
                        Icon(Icons.edit, color: AppColors.primary, size: 24), // Menggunakan AppColors.primary
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.serviceName ?? '-',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${service.serviceCost ?? 0}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tombol Delete di sebelah kanan
                        IconButton(
                          icon: Icon(Icons.delete, color: AppColors.error, size: 24), // Menggunakan AppColors.danger (merah)
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) { // Gunakan dialogContext untuk Navigator.of
                                return AlertDialog(
                                  title: const Text('Hapus Layanan'),
                                  content: Text(
                                    'Anda yakin ingin menghapus layanan "${service.serviceName}"?',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Batal'),
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop(); // Gunakan dialogContext
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Hapus',
                                        style: TextStyle(color: AppColors.error), // Menggunakan AppColors.danger
                                      ),
                                      onPressed: () {
                                        context.read<ServiceBloc>().add(
                                          DeleteServiceEvent(service.serviceId!),
                                        );
                                        Navigator.of(dialogContext).pop(); // Gunakan dialogContext
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
