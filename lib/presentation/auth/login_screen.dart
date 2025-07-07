import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/components/buttons.dart';
import 'package:tugas_akhir/core/components/custom_text_field.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/core/extensions/build_context_ext.dart';
import 'package:tugas_akhir/data/model/request/auth/login_request_model.dart';
import 'package:tugas_akhir/presentation/admin/admin_confirm_screen.dart';
import 'package:tugas_akhir/presentation/auth/bloc/login/login_bloc.dart';
import 'package:tugas_akhir/presentation/auth/register_screen.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/pelanggan_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SpaceHeight(16.0),
                Image.asset(
                  'assets/images/motogo_logo_remove.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SpaceHeight(16.0),
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

                // BlocConsumer untuk meng-handle login
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginLoading) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is LoginSuccess) {
                      context.pop(); // Tutup dialog loading
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login Berhasil!')),
                      );

                      final role = state.responseModel.data?.role?.toLowerCase();

                      if (role == 'admin') {
                        context.pushAndRemoveUntil(
                          const AdminConfirmScreen(),
                          (route) => false,
                        );
                      } else if (role == 'pelanggan') {
                        context.pushAndRemoveUntil(
                          const PelangganProfileScreen(),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Role tidak dikenali')),
                        );
                      }
                    } else if (state is LoginFailure) {
                      context.pop(); // Tutup dialog loading
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Login Gagal: ${state.error}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Button.filled(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final requestModel = LoginRequestModel(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          print('[DEBUG] LoginRequestModel: ${requestModel.toJson()}');
                          context.read<LoginBloc>().add(LoginRequested(requestModel: requestModel));
                        }
                      },
                      label: 'Login',
                      disabled: state is LoginLoading,
                    );
                  },
                ),
                const SpaceHeight(20.0),
                TextButton(
                  onPressed: () {
                    context.push(const RegisterScreen());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Belum punya akun? Daftar di sini.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
