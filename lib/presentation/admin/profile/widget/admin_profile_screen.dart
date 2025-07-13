import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/request/admin/profile/admin_profile_request_model.dart';
import 'package:tugas_akhir/presentation/admin/profile/bloc/profile_admin_bloc.dart';
import 'package:tugas_akhir/presentation/admin/profile/widget/admin_profile_input_form.dart';
import 'package:tugas_akhir/presentation/admin/profile/widget/admin_profile_view_form.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat profil admin saat halaman pertama kali dibuka
    context.read<AdminProfileBloc>().add(GetAdminProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Latar belakang abu-abu terang
      body: BlocConsumer<AdminProfileBloc, AdminProfileState>(
        listener: (context, state) {
          if (state is AdminProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal: ${state.error}')),
            );
          } else if (state is AdminProfileSuccess &&
              (state.responseModel.message != null &&
                  state.responseModel.message!.isNotEmpty)) {
            // Tampilkan pesan sukses hanya jika ada pesan dari response model
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      state.responseModel.message ?? 'Profil berhasil diperbarui!')),
            );

            // LOGIKA NAVIGASI: Kembali ke halaman sebelumnya (AdminProfileViewForm)
            // Jika AdminProfileInputForm dipush, kita akan pop kembali
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(true); // Pop dengan mengembalikan nilai `true`
            }
            // Setelah pop, Builder akan rebuild dan jika perlu, GetAdminProfile akan dipanggil ulang
            // untuk memastikan data terbaru.
          }
        },
        builder: (context, state) {
          if (state is AdminProfileInitial || state is AdminProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminProfileSuccess) {
            final data = state.responseModel.data;

            // Jika data profil belum ada atau namanya kosong, tampilkan form input untuk menambah
            if (data == null || data.name == null || data.name!.isEmpty) {
              return AdminProfileInputForm(
                isUpdateMode: false,
                isLoading: state is AdminProfileLoading,
                onSubmit: (String name, File? image) {
                  context.read<AdminProfileBloc>().add(
                        AddAdminProfile(
                          requestModel: AdminProfileRequestModel(
                            name: name,
                            profilePicture: image,
                          ),
                        ),
                      );
                },
              );
            } else {
              // Jika data profil sudah ada, tampilkan form view
              return AdminProfileViewForm(
                profileData: data,
                isLoading: state is AdminProfileLoading,
                onEdit: () async {
                  // Saat tombol edit ditekan, navigasi ke AdminProfileInputForm dalam mode update
                  // await digunakan untuk menunggu hasil pop dari halaman AdminProfileInputForm
                  final bool? profileUpdated = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AdminProfileInputForm(
                        isUpdateMode: true,
                        isLoading: false, // Loading diatur oleh Bloc saat submit
                        initialData: state.responseModel, // Kirim data profil yang ada
                        onSubmit: (String name, File? image) {
                          context.read<AdminProfileBloc>().add(
                                UpdateAdminProfile(
                                  requestModel: AdminProfileRequestModel(
                                    name: name,
                                    profilePicture: image,
                                  ),
                                ),
                              );
                        },
                      ),
                    ),
                  );
                  // Jika AdminProfileInputForm di-pop dengan `true` (berarti update berhasil)
                  if (profileUpdated == true) {
                    // Panggil GetAdminProfile lagi untuk me-refresh tampilan dengan data terbaru
                    context.read<AdminProfileBloc>().add(GetAdminProfile());
                  }
                },
                // onRefresh tidak lagi dibutuhkan di sini karena auto-update
                onRefresh: () {}, // Dibiarkan kosong atau dihapus jika tidak ada kebutuhan lain
              );
            }
          } else if (state is AdminProfileFailure) {
            // Jika ada kegagalan saat memuat profil (misalnya pertama kali dan tidak ada profil),
            // arahkan ke form input untuk menambahkan profil baru
            return AdminProfileInputForm(
              isUpdateMode: false,
              isLoading: state is AdminProfileLoading,
              onSubmit: (String name, File? image) {
                context.read<AdminProfileBloc>().add(
                      AddAdminProfile(
                        requestModel: AdminProfileRequestModel(
                          name: name,
                          profilePicture: image,
                        ),
                      ),
                    );
              },
            );
          }
          return const Center(child: Text('Terjadi kesalahan yang tidak diketahui.'));
        },
      ),
    );
  }
}