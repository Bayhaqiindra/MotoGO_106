import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/pelanggan_profile_request_model.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/bloc/profile_pelanggan_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/widget/pelanggan_profile_input_form.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/widget/pelanggan_profile_view_form.dart';

class PelangganProfileScreen extends StatefulWidget {
  const PelangganProfileScreen({super.key});

  @override
  State<PelangganProfileScreen> createState() => _PelangganProfileScreenState();
}

class _PelangganProfileScreenState extends State<PelangganProfileScreen> {
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    context.read<PelangganProfileBloc>().add(GetPelangganProfile());
  }

  void _submitProfile(String name, String phone, String address, File? file) {
    final request = PelangganProfileRequestModel(
      name: name,
      phone: phone,
      address: address,
      profilePictureFile: file,
    );

    if (isEditMode) {
      context.read<PelangganProfileBloc>().add(UpdatePelangganProfile(requestModel: request));
    } else {
      context.read<PelangganProfileBloc>().add(AddPelangganProfile(requestModel: request));
    }

    setState(() {
      isEditMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Pelanggan")),
      body: BlocBuilder<PelangganProfileBloc, PelangganProfileState>(
        builder: (context, state) {
          final isLoading = state is PelangganProfileLoading;

          if (state is PelangganProfileSuccess) {
            final profile = state.responseModel.data;

            if (profile != null && profile.name != null && !isEditMode) {
              return PelangganProfileViewForm(
                profileData: profile,
                isLoading: isLoading,
                onEdit: () {
                  setState(() {
                    isEditMode = true;
                  });
                },
                onRefresh: () {
                  context.read<PelangganProfileBloc>().add(GetPelangganProfile());
                },
              );
            } else {
              return PelangganProfileInputForm(
                isUpdateMode: profile != null,
                initialData: profile,
                isLoading: isLoading,
                onSubmit: _submitProfile,
              );
            }
          }

          if (state is PelangganProfileFailure) {
  // Jika errornya karena belum ada data pelanggan, tampilkan form input
  if (state.error.toLowerCase().contains("pelanggan tidak ditemukan")) {
    return PelangganProfileInputForm(
      isUpdateMode: false,
      initialData: null,
      isLoading: false,
      onSubmit: _submitProfile,
    );
  }

  // Jika error lain, tampilkan pesan gagal
  return Center(child: Text('Gagal: ${state.error}'));
}


          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
