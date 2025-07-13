import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_all_sparepart_response_model.dart'; // Atau GetSparepartByIdResponseModel jika detailnya sama


class SparepartCard extends StatelessWidget {
  final GetallSparepartResponseModel sparepart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap; // Untuk melihat detail

  const SparepartCard({
    super.key,
    required this.sparepart,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap, // Aksi ketika card diklik (misal: buka detail)
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sparepart.imageUrl != null && sparepart.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'http://10.0.2.2:8000/storage/${sparepart.imageUrl}', // Pastikan ini sesuai dengan base URL storage Anda
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                sparepart.name ?? 'Nama Tidak Diketahui',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Deskripsi: ${sparepart.description ?? '-'}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                'Harga: Rp ${sparepart.price ?? '0'}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(
                'Stok: ${sparepart.stockQuantity ?? 0}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}