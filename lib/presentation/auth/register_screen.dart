import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/components/buttons.dart';
import 'package:tugas_akhir/core/components/custom_text_field.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/core/extensions/build_context_ext.dart';
import 'package:tugas_akhir/data/model/request/auth/register_request_model.dart';
import 'package:tugas_akhir/presentation/auth/bloc/register/register_bloc.dart'; // RegisterBloc Anda

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/images/motogo_logo_remove.png', // Ganti dengan path gambar Anda
                  height: 200, // Sesuaikan tinggi gambar
                  fit: BoxFit.contain,
                ),
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: 'Email tidak boleh kosong',
                ),
                const SpaceHeight(20.0),
                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: 'Password tidak boleh kosong',
                ),
                const SpaceHeight(30.0),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterLoading) {
                      // Tampilkan loading indicator atau dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is RegisterSuccess) {
                      // Tutup loading dialog
                      context.pop();
                      // Tampilkan pesan sukses
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registrasi Berhasil: ${state.responseModel.message}')),
                      );
                      // Mungkin navigasi kembali ke layar login
                      context.pop();
                    } else if (state is RegisterFailure) {
                      // Tutup loading dialog
                      context.pop();
                      // Tampilkan pesan error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registrasi Gagal: ${state.error}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Button.filled(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final requestModel = RegisterRequestModel(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          // Panggil event RegisterRequested pada RegisterBloc
                          context.read<RegisterBloc>().add(RegisterRequested(requestModel: requestModel));
                        }
                      },
                      label: 'Daftar',
                      disabled: state is RegisterLoading, // Nonaktifkan tombol saat loading
                    );
                  },
                ),
                const SpaceHeight(20.0),
                TextButton(
                  onPressed: () {
                    // Kembali ke LoginScreen
                    context.pop();
                  },
                  child: const Text('Sudah punya akun? Masuk di sini.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}