import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/components/buttons.dart';
import 'package:tugas_akhir/core/components/custom_text_field.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/data/model/request/admin/service/service_request_model.dart';
import 'package:tugas_akhir/presentation/admin/service/bloc/service_bloc.dart';

class AdminServiceForm extends StatefulWidget {
  // Hapus final isUpdate, serviceId, initialName, initialCost
  // Kita akan menanganinya dari state Bloc atau dari parent secara eksplisit jika ingin edit
  const AdminServiceForm({
    super.key,
  });

  @override
  State<AdminServiceForm> createState() => AdminServiceFormState(); // Perhatikan: AdminServiceFormState tanpa _
}

// Ubah _AdminServiceFormState menjadi AdminServiceFormState
class AdminServiceFormState extends State<AdminServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();

  // Tambahkan variabel untuk mode update dan service ID
  bool _isUpdate = false;
  int? _currentServiceId;

  @override
  void initState() {
    super.initState();
    // Di sini kita tidak lagi menginisialisasi dari widget.initialName/Cost
    // Jika form ini digunakan untuk update, parent akan memanggil `loadForUpdate`
  }

  // Method untuk mereset form
  void resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _costController.clear();
    setState(() {
      _isUpdate = false;
      _currentServiceId = null;
    });
  }

  // Method untuk memuat data ke form saat mode update
  void loadForUpdate(int serviceId, String name, int cost) {
    _nameController.text = name;
    _costController.text = cost.toString();
    setState(() {
      _isUpdate = true;
      _currentServiceId = serviceId;
    });
  }


  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = ServiceRequestModel(
        serviceName: _nameController.text,
        serviceCost: int.parse(_costController.text),
      );

      if (_isUpdate && _currentServiceId != null) {
        context.read<ServiceBloc>().add(UpdateServiceEvent(_currentServiceId!, request));
      } else {
        context.read<ServiceBloc>().add(AddServiceEvent(request));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _nameController,
            label: 'Nama Layanan',
            validator: (value) =>
                value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
          ),
          const SpaceHeight(16),
          CustomTextField(
            controller: _costController,
            label: 'Harga Layanan',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Harga tidak boleh kosong';
              if (int.tryParse(value) == null) return 'Harga harus berupa angka';
              return null;
            },
          ),
          const SpaceHeight(24),
          // Tambahkan BlocBuilder di sini untuk menampilkan loading/disable tombol
          BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              final bool isLoading = state is ServiceLoading;
              return Button.filled(
                onPressed: isLoading ? null : _submit, // Disable saat loading
                label: isLoading
                    ? (_isUpdate ? 'Memperbarui...' : 'Menambahkan...')
                    : (_isUpdate ? 'Perbarui' : 'Tambah'),
              );
            },
          ),
          if (_isUpdate) ...[ // Tampilkan tombol reset hanya saat mode update
            const SpaceHeight(12),
            Button.outlined(
              onPressed: resetForm,
              label: 'Batal Perbarui',
            ),
          ]
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }
}