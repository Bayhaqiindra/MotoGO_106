import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/model/response/admin/data_booking/admin_get_all_booking_response_model.dart';

class ConfirmServiceForm extends StatefulWidget {
  final AdmingetallbookingResponseModel booking;
  final Function(
    int bookingId,
    int serviceId,
    String serviceStatus,
    int totalCost,
    String adminNotes,
  )
  onConfirm;

  const ConfirmServiceForm({
    super.key,
    required this.booking,
    required this.onConfirm,
  });

  @override
  State<ConfirmServiceForm> createState() => _ConfirmServiceFormState();
}

class _ConfirmServiceFormState extends State<ConfirmServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _totalCostController = TextEditingController();
  final TextEditingController _adminNotesController = TextEditingController();
  String? _selectedServiceStatus; // Untuk status layanan setelah dikonfirmasi

  @override
  void dispose() {
    _totalCostController.dispose();
    _adminNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Konfirmasi Layanan & Balas Pelanggan:',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedServiceStatus,
                hint: const Text('Pilih Status Layanan'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Status Layanan',
                ),
                items: const [
                  DropdownMenuItem(value: 'menunggu', child: Text('Menunggu')),
                  DropdownMenuItem(
                    value: 'dalam_pekerjaan',
                    child: Text('Dalam Pekerjaan'),
                  ),
                  DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
                  DropdownMenuItem(
                    value: 'dibatalkan',
                    child: Text('Dibatalkan'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedServiceStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Status layanan harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _totalCostController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Total Biaya (Rp)',
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Total biaya harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Total biaya harus angka';
                  }
                  if (int.parse(value) < 0) {
                    return 'Total biaya tidak boleh negatif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _adminNotesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Catatan Admin (Akan dikirim ke Pelanggan)',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Catatan admin tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onConfirm(
                        widget.booking.bookingId!,
                        widget
                            .booking
                            .serviceId!, // Pastikan serviceId ada di booking
                        _selectedServiceStatus!,
                        int.parse(_totalCostController.text),
                        _adminNotesController.text,
                      );
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim Konfirmasi & Balasan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
