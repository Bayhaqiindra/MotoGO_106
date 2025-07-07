import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/repository/auth_repository.dart';
import 'package:tugas_akhir/data/repository/pelanggan_profile_repository.dart';
import 'package:tugas_akhir/presentation/auth/bloc/login/login_bloc.dart';
import 'package:tugas_akhir/presentation/auth/bloc/register/register_bloc.dart';
import 'package:tugas_akhir/presentation/auth/login_screen.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/bloc/profile_pelanggan_bloc.dart';
import 'package:tugas_akhir/service/service_http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ServiceHttp dan AuthRepository
    final serviceHttp = ServiceHttp();
    final authRepository = AuthRepository(serviceHttp);
    final profileRepository = PelangganProfileRepository(serviceHttp);


    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(authRepository: authRepository),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(authRepository: authRepository),
        ),
        BlocProvider<PelangganProfileBloc>(
  create: (context) => PelangganProfileBloc(repository: profileRepository),
),

        // Tambahkan BlocProvider lain jika ada seperti PelangganProfileBloc, BookingBloc, dll.
      ],
      child: MaterialApp(
        title: 'Tugas Akhir App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true, // opsional jika pakai Material 3
        ),
        home: const LoginScreen(), // Layar awal aplikasi
      ),
    );
  }
}
