import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/presentation/admin/service/bloc/service_bloc.dart';
import 'package:tugas_akhir/presentation/admin/service/widget/admin_service_form.dart';
import 'package:tugas_akhir/presentation/admin/service/widget/admin_service_list_widget.dart';
import 'package:tugas_akhir/data/model/response/admin/service/get_all_service_response_model.dart';

class AdminServiceScreen extends StatefulWidget {
  const AdminServiceScreen({super.key});

  @override
  State<AdminServiceScreen> createState() => _AdminServiceScreenState();
}

class _AdminServiceScreenState extends State<AdminServiceScreen> {
  final GlobalKey<AdminServiceFormState> _formKey = GlobalKey<AdminServiceFormState>();

  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(GetAllServiceEvent());
  }

  // Method untuk memuat data ke form ketika diminta oleh AdminServiceList
  void _editService(int serviceId, String name, int cost) {
    _formKey.currentState?.loadForUpdate(serviceId, name, cost);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Layanan'),
        centerTitle: true,
      ),
      body: BlocListener<ServiceBloc, ServiceState>(
        listener: (context, state) {
          if (state is ServiceAddedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Layanan "${state.response.data?.serviceName}" berhasil ditambahkan!')),
            );
            context.read<ServiceBloc>().add(GetAllServiceEvent());
            _formKey.currentState?.resetForm();
          } else if (state is ServiceUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Layanan "${state.response.data?.serviceName}" berhasil diperbarui!')),
            );
            context.read<ServiceBloc>().add(GetAllServiceEvent());
            _formKey.currentState?.resetForm();
          } else if (state is ServiceDeletedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Layanan berhasil dihapus!')),
            );
            context.read<ServiceBloc>().add(GetAllServiceEvent());
          } else if (state is ServiceFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AdminServiceForm(key: _formKey),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Daftar Layanan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: AdminServiceList(
                onEdit: _editService, // <--- Berikan callback ke AdminServiceList
              ),
            ),
          ],
        ),
      ),
    );
  }
}