import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/repository/admin/admin_konfirmasi_payment_sparepart_repository.dart';
import 'package:tugas_akhir/data/repository/admin/admin_payment_service_repository.dart';
import 'package:tugas_akhir/data/repository/admin/admin_pengeluaran_repository.dart';
import 'package:tugas_akhir/data/repository/admin/admin_total_pemasukan_repository.dart';
import 'package:tugas_akhir/data/repository/admin/admin_transaction_repository.dart';
import 'package:tugas_akhir/data/repository/admin/laporan_repository.dart';

// REPOSITORIES (Pastikan path ini benar untuk semua repository yang Anda gunakan)
import 'package:tugas_akhir/data/repository/admin/sparepart_repository.dart'; // Import interface atau abstract class ISparepartRepository
import 'package:tugas_akhir/data/repository/admin/total_pengeluaran_repository.dart';
import 'package:tugas_akhir/data/repository/auth/auth_repository.dart';
import 'package:tugas_akhir/data/repository/admin/admin_profile_repository.dart';
import 'package:tugas_akhir/data/repository/pelanggan/payment_service_repository.dart';
import 'package:tugas_akhir/data/repository/pelanggan/payment_sparepart_repository.dart';
import 'package:tugas_akhir/data/repository/pelanggan/pelanggan_profile_repository.dart';
import 'package:tugas_akhir/data/repository/admin/service_repository.dart';
import 'package:tugas_akhir/data/repository/pelanggan/booking_repository_repository.dart';
import 'package:tugas_akhir/data/repository/admin/admin_booking_repository.dart';
import 'package:tugas_akhir/data/repository/pelanggan/transaction_repository.dart';
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_service/bloc/admin_payment_service_bloc.dart';
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_sparepart/bloc/admin_payment_sparepart_bloc.dart';
import 'package:tugas_akhir/presentation/admin/laporan/bloc/laporan_export_pdf_bloc.dart';
import 'package:tugas_akhir/presentation/admin/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:tugas_akhir/presentation/admin/total_pemasukan/bloc/total_pemasukan_bloc.dart';
import 'package:tugas_akhir/presentation/admin/total_pengeluaran/bloc/total_pengeluaran_bloc.dart';
import 'package:tugas_akhir/presentation/admin/transaction/bloc/admin_transaction_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/payment_service/bloc/pelanggan_payment_service_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/payment_sparepart/bloc/pelanggan_payment_sparepart_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/transaction/bloc/transaction_bloc.dart';
import 'package:tugas_akhir/service/service_http.dart'; // Core Services

// BLOCS (Pastikan path ini benar untuk semua bloc yang Anda gunakan)
import 'package:tugas_akhir/presentation/auth/bloc/login/login_bloc.dart';
import 'package:tugas_akhir/presentation/auth/bloc/register/register_bloc.dart';
import 'package:tugas_akhir/presentation/admin/profile/bloc/profile_admin_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/bloc/profile_pelanggan_bloc.dart';
import 'package:tugas_akhir/presentation/admin/service/bloc/service_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/booking/bloc/booking_bloc.dart';
import 'package:tugas_akhir/presentation/admin/booking/bloc/admin_booking_bloc.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/bloc/sparepart_bloc.dart'; // Import SparepartBloc

// Start / Welcome Screen
import 'package:tugas_akhir/presentation/start/welcomeapp.dart';

// Untuk menguji halaman SparepartListPage (opsional, jika ingin langsung ke halaman ini)
import 'package:tugas_akhir/presentation/admin/sparepart/pages/sparepart_list_page.dart'; // Import SparepartListPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceHttp = ServiceHttp(); // Inisialisasi ServiceHttp

    // REPOSITORIES
    final authRepository = AuthRepository(serviceHttp);
    final adminProfileRepo = AdminProfileRepository(serviceHttp);
    final pelangganProfileRepo = PelangganProfileRepository(serviceHttp);
    final serviceRepository = AdminServiceRepository(serviceHttp);
    final bookingRepository = BookingRepositoryImpl(serviceHttp);
    final adminBookingRepository = AdminBookingRepository(serviceHttp);
    final sparepartRepository = SparepartRepositoryImpl(serviceHttp);
    final transactionRepository = TransactionRepository(serviceHttp);
    final adminTransactionRepository = AdminTransactionRepository(serviceHttp);
    final pelangganPaymentSparepartRepository =
        PelangganPaymentSparepartRepository(serviceHttp);
    final adminPaymentSparepartRepository = AdminPaymentSparepartRepository(
      serviceHttp,
    );
    final pelangganPaymentServiceRepository = PelangganPaymentServiceRepository(
      serviceHttp,
    );
    final adminPaymentServiceRepository = AdminPaymentServiceRepository(
      serviceHttp,
    );
    final pengeluaranRepository = PengeluaranRepository(serviceHttp);
    final totalPengeluaranRepository = TotalPengeluaranRepository(serviceHttp);
    final totalPemasukanRepository = TotalPemasukanRepository(serviceHttp);
    final laporanRepository = LaporanRepository(serviceHttp);

    return MultiRepositoryProvider(
      providers: [
        // AUTH Repositories
        RepositoryProvider<AuthRepository>(create: (context) => authRepository),
        // PROFILE Repositories
        RepositoryProvider<AdminProfileRepository>(
          create: (context) => adminProfileRepo,
        ),
        RepositoryProvider<PelangganProfileRepository>(
          create: (context) => pelangganProfileRepo,
        ),
        // SERVICE (Admin) Repository
        RepositoryProvider<AdminServiceRepository>(
          create: (context) => serviceRepository,
        ),
        // BOOKING (Pelanggan) Repository
        RepositoryProvider<BookingRepositoryImpl>(
          create: (context) => bookingRepository,
        ),
        // BOOKING & CONFIRMATION (Admin) Repository
        RepositoryProvider<AdminBookingRepository>(
          create: (context) => adminBookingRepository,
        ),
        // SPAREPART Repository (SUDAH ADA DAN BENAR)
        // Menggunakan interface ISparepartRepository untuk injection dependency yang lebih baik
        RepositoryProvider<ISparepartRepository>(
          create: (context) => sparepartRepository,
        ),

        RepositoryProvider<TransactionRepository>(
          create: (context) => transactionRepository,
        ),

        RepositoryProvider<AdminTransactionRepository>(
          create: (context) => adminTransactionRepository,
        ),
        RepositoryProvider<PelangganPaymentSparepartRepository>(
          create: (context) => pelangganPaymentSparepartRepository,
        ),
        RepositoryProvider<AdminPaymentSparepartRepository>(
          create: (context) => adminPaymentSparepartRepository,
        ),
        RepositoryProvider<IPelangganPaymentServiceRepository>(
          // Gunakan interface jika ada
          create: (context) => pelangganPaymentServiceRepository,
        ),
        RepositoryProvider<IAdminPaymentServiceRepository>(
          // Gunakan interface jika ada
          create: (context) => adminPaymentServiceRepository,
        ),
        RepositoryProvider<PengeluaranRepository>(
          // <<< Tambahkan ini
          create: (context) => pengeluaranRepository,
        ),
        RepositoryProvider<TotalPengeluaranRepository>(
          // Daftarkan repository total
          create: (context) => totalPengeluaranRepository,
        ),
        RepositoryProvider<TotalPemasukanRepository>( // <-- Daftarkan TotalPemasukanRepository
          create: (context) => totalPemasukanRepository,
        ),
        RepositoryProvider<LaporanRepository>( // <-- Daftarkan LaporanRepository
          create: (context) => laporanRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // AUTH Blocs
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(authRepository: authRepository),
          ),
          BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(authRepository: authRepository),
          ),

          // PROFILE Blocs
          BlocProvider<AdminProfileBloc>(
            create: (context) => AdminProfileBloc(repository: adminProfileRepo),
          ),
          BlocProvider<PelangganProfileBloc>(
            create:
                (context) =>
                    PelangganProfileBloc(repository: pelangganProfileRepo),
          ),

          // SERVICE (Admin) Bloc
          BlocProvider<ServiceBloc>(
            create: (context) => ServiceBloc(serviceRepository),
          ),

          // BOOKING (Pelanggan) Bloc
          BlocProvider<BookingBloc>(
            create: (context) => BookingBloc(bookingRepository),
          ),

          // BOOKING & CONFIRMATION (Admin) Bloc
          BlocProvider<AdminBookingBloc>(
            create:
                (context) =>
                    AdminBookingBloc(bookingRepository: adminBookingRepository),
          ),
          // SPAREPART Bloc (SUDAH ADA DAN BENAR)
          BlocProvider<SparepartBloc>(
            create:
                (context) => SparepartBloc(
                  // Mengambil ISparepartRepository dari MultiRepositoryProvider
                  sparepartRepository:
                      RepositoryProvider.of<ISparepartRepository>(context),
                ),
          ),

          BlocProvider<TransactionBloc>(
            create:
                (context) => TransactionBloc(
                  // Mengambil TransactionRepository dari MultiRepositoryProvider yang sudah Anda daftarkan
                  context.read<TransactionRepository>(),
                ),
          ),

          BlocProvider<AdminTransactionBloc>(
            create:
                (context) => AdminTransactionBloc(
                  context
                      .read<
                        AdminTransactionRepository
                      >(), // Mengambil AdminTransactionRepository dari MultiRepositoryProvider
                ),
          ),
          BlocProvider<PelangganPaymentSparepartBloc>(
            create:
                (context) => PelangganPaymentSparepartBloc(
                  context
                      .read<
                        PelangganPaymentSparepartRepository
                      >(), // Mengambil PelangganPaymentSparepartRepository
                ),
          ),
          BlocProvider<AdminPaymentSparepartBloc>(
            create:
                (context) => AdminPaymentSparepartBloc(
                  context
                      .read<
                        AdminPaymentSparepartRepository
                      >(), // Mengambil AdminPaymentSparepartRepository
                ),
          ),
          BlocProvider<PelangganPaymentServiceBloc>(
            create:
                (context) => PelangganPaymentServiceBloc(
                  pelangganPaymentServiceRepository:
                      context.read<IPelangganPaymentServiceRepository>(),
                ),
          ),
          BlocProvider<AdminPaymentServiceBloc>(
            create:
                (context) => AdminPaymentServiceBloc(
                  adminPaymentServiceRepository:
                      context
                          .read<
                            IAdminPaymentServiceRepository
                          >(), // Mengambil dari MultiRepositoryProvider
                ),
          ),
          BlocProvider<PengeluaranBloc>(
            // <<< Tambahkan ini
            create:
                (context) => PengeluaranBloc(
                  pengeluaranRepository: context.read<PengeluaranRepository>(),
                ),
          ),
          BlocProvider<TotalPengeluaranBloc>(
            // <<< DAFTARKAN BLOC BARU INI
            create:
                (context) => TotalPengeluaranBloc(
                  totalPengeluaranRepository:
                      context.read<TotalPengeluaranRepository>(),
                ),
          ),
          BlocProvider<TotalPemasukanBloc>( // <-- Daftarkan TotalPemasukanBloc
            create: (context) => TotalPemasukanBloc(
              totalPemasukanRepository: context.read<TotalPemasukanRepository>(),
            ),
          ),
          BlocProvider<LaporanExportPdfBloc>( // <-- Daftarkan LaporanExportPdfBloc
            create: (context) => LaporanExportPdfBloc(
              laporanRepository: context.read<LaporanRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Tugas Akhir App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            cardTheme: CardTheme(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Halaman awal aplikasi Anda
          home: const StartScreen(), // Tetap WelcomeApp sebagai home awal
          // Jika Anda ingin langsung menguji SparepartListPage (admin), ganti home:
          // home: const SparepartListPage(), // <<< UNCOMMENT INI UNTUK PENGUJIAN LANGSUNG
        ),
      ),
    );
  }
}
