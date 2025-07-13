import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/constants/colors.dart'; // Import AppColors
import 'package:tugas_akhir/data/model/request/pelanggan/profile/pelanggan_profile_request_model.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/bloc/profile_pelanggan_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/widget/pelanggan_profile_input_form.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/widget/pelanggan_profile_view_form.dart';

class PelangganProfileScreen extends StatefulWidget {
  const PelangganProfileScreen({super.key});

  @override
  State<PelangganProfileScreen> createState() => _PelangganProfileScreenState();
}

class _PelangganProfileScreenState extends State<PelangganProfileScreen> {
  // isEditMode tidak lagi diperlukan di sini karena navigasi akan menangani pergantian form
  // bool isEditMode = false; // Dihapus

  @override
  void initState() {
    super.initState();
    // Memuat profil pelanggan saat halaman pertama kali dibuka
    context.read<PelangganProfileBloc>().add(GetPelangganProfile());
  }

  // Fungsi untuk menangani submit dari PelangganProfileInputForm
  void _onSubmitProfile(String name, String phone, String address, File? file, bool isUpdate) {
    final request = PelangganProfileRequestModel(
      name: name,
      phone: phone,
      address: address,
      profilePicture: file,
    );

    if (isUpdate) {
      context.read<PelangganProfileBloc>().add(UpdatePelangganProfile(requestModel: request));
    } else {
      context.read<PelangganProfileBloc>().add(AddPelangganProfile(requestModel: request));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.white, // Latar belakang utama Scaffold
      // AppBar akan disimulasikan di dalam Stack untuk efek gambar latar belakang
      body: BlocConsumer<PelangganProfileBloc, PelangganProfileState>(
        listener: (context, state) {
          if (state is PelangganProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal: ${state.error}')),
            );
          } else if (state is PelangganProfileSuccess &&
              (state.responseModel.message != null &&
                  state.responseModel.message!.isNotEmpty)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    state.responseModel.message ?? 'Profil berhasil diperbarui!'),
              ),
            );

            // Jika kita berada di halaman input (setelah submit), pop kembali ke halaman view
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(true); // Pop dengan mengembalikan nilai `true`
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is PelangganProfileLoading;

          // Konten utama yang akan diatur di dalam Stack
          Widget contentWidget;

          if (state is PelangganProfileInitial || isLoading) {
            contentWidget = const Center(child: CircularProgressIndicator());
          } else if (state is PelangganProfileSuccess) {
            final profile = state.responseModel.data;

            // Jika data profil belum ada atau namanya kosong, tampilkan form input untuk menambah
            if (profile == null || profile.name == null || profile.name!.isEmpty) {
              contentWidget = PelangganProfileInputForm(
                isUpdateMode: false,
                initialData: null,
                isLoading: isLoading,
                onSubmit: (name, phone, address, file) => _onSubmitProfile(name, phone, address, file, false),
              );
            } else {
              // Jika data profil sudah ada, tampilkan form view
              contentWidget = PelangganProfileViewForm(
                profileData: profile,
                isLoading: isLoading,
                onEdit: () async {
                  // Saat tombol edit ditekan, navigasi ke PelangganProfileInputForm dalam mode update
                  final bool? profileUpdated = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold( // Scaffold baru untuk input form
                        appBar: AppBar(
                          title: const Text('Perbarui Profil'),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                          ),
                        ),
                        body: PelangganProfileInputForm(
                          isUpdateMode: true,
                          isLoading: false, // Loading diatur oleh Bloc saat submit
                          initialData: profile, // Kirim data profil yang ada
                          onSubmit: (name, phone, address, file) => _onSubmitProfile(name, phone, address, file, true),
                        ),
                      ),
                    ),
                  );
                  // Jika PelangganProfileInputForm di-pop dengan `true` (berarti update berhasil)
                  if (profileUpdated == true) {
                    // Panggil GetPelangganProfile lagi untuk me-refresh tampilan dengan data terbaru
                    context.read<PelangganProfileBloc>().add(GetPelangganProfile());
                  }
                },
                onRefresh: () {
                  context.read<PelangganProfileBloc>().add(GetPelangganProfile());
                },
              );
            }
          } else if (state is PelangganProfileFailure) {
            // Jika errornya karena belum ada data pelanggan, tampilkan form input
            if (state.error.toLowerCase().contains("pelanggan tidak ditemukan")) {
              contentWidget = PelangganProfileInputForm(
                isUpdateMode: false,
                initialData: null,
                isLoading: false,
                onSubmit: (name, phone, address, file) => _onSubmitProfile(name, phone, address, file, false),
              );
            } else {
              // Jika error lain, tampilkan pesan gagal
              contentWidget = Center(child: Text('Gagal: ${state.error}'));
            }
          } else {
            contentWidget = const Center(child: Text('Terjadi kesalahan yang tidak diketahui.'));
          }

          return Stack(
            children: [
              // Konten utama (view atau input form)
              Positioned.fill(child: contentWidget),

              // Judul "Profile" di AppBar (disimulasikan)
              // Hanya tampilkan jika bukan dalam mode input (saat PelangganProfileViewForm aktif)
              if (state is PelangganProfileSuccess && state.responseModel.data != null && state.responseModel.data!.name != null)
                Positioned(
                  top: statusBarHeight + 20, // Sesuaikan posisi
                  left: 24,
                  child: const Text(
                    'Profile',
                    style: TextStyle(
                      color: AppColors.white, // Warna teks putih
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
