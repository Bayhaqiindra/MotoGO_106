import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/components/auth_button.dart';
import 'package:tugas_akhir/core/components/login_text_field.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/core/extensions/build_context_ext.dart';
import 'package:tugas_akhir/data/model/request/auth/login_request_model.dart';
import 'package:tugas_akhir/presentation/admin/main/main_admin_screen.dart';
import 'package:tugas_akhir/presentation/admin/profile/widget/admin_profile_screen.dart';
import 'package:tugas_akhir/presentation/auth/bloc/login/login_bloc.dart';
import 'package:tugas_akhir/presentation/auth/screen/register_screen.dart';
import 'package:tugas_akhir/presentation/pelanggan/main/main_customer_screen.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final formHeight = screenHeight * 0.6;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 58, 96, 192),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              const SafeArea(child: SizedBox()),
              const SizedBox(height: 32),

              // 👇 Judul lebih dekat ke card
              const Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceHeight(4),
              const Text(
                'Please sign in to your existing account',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 20), // Tambahan jarak agar proporsional
              // 👇 FORM LOGIN CARD
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: formHeight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EMAIL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SpaceHeight(8),
                        LoginTextField(
                          controller: emailController,
                          hintText: 'Email',
                          prefixIcon: Icons.person,
                          validatorText: 'Email tidak boleh kosong',
                        ),

                        const SpaceHeight(20),
                        const Text(
                          'PASSWORD',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SpaceHeight(8),
                        LoginTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock,
                          obscureText: true,
                          validatorText: 'Password tidak boleh kosong',
                        ),

                        const SpaceHeight(12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(value: false, onChanged: (_) {}),
                                const Text("Remember me"),
                              ],
                            ),
                          ],
                        ),
                        const SpaceHeight(16),
                        BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginLoading) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (_) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              );
                            } else if (state is LoginSuccess) {
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login Berhasil!'),
                                ),
                              );
                              final role =
                                  state.responseModel.data?.role?.toLowerCase();
                              if (role == 'admin') {
                                context.pushAndRemoveUntil(
                                  const MainAdminScreen(),
                                  (route) => false,
                                );
                              } else if (role == 'pelanggan') {
                                context.pushAndRemoveUntil(
                                  const MainCustomerScreen(),
                                  (route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Role tidak dikenali'),
                                  ),
                                );
                              }
                            } else if (state is LoginFailure) {
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Login Gagal: ${state.error}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return AuthButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final requestModel = LoginRequestModel(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  context.read<LoginBloc>().add(
                                    LoginRequested(requestModel: requestModel),
                                  );
                                }
                              },
                              isLoading: state is LoginLoading,
                              label: 'LOG IN',
                            );
                          },
                        ),

                        const SpaceHeight(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don’t have an account? "),
                            TextButton(
                              onPressed: () {
                                context.push(const RegisterScreen());
                              },
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3A60C0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
