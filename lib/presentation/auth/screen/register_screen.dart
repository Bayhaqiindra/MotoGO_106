import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/components/auth_button.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/core/components/login_text_field.dart';
import 'package:tugas_akhir/core/extensions/build_context_ext.dart';
import 'package:tugas_akhir/data/model/request/auth/register_request_model.dart';
import 'package:tugas_akhir/presentation/auth/bloc/register/register_bloc.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final formHeight = screenHeight * 0.65;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 58, 96, 192),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              const SafeArea(child: SizedBox()),
              const SizedBox(height: 32),
              const Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceHeight(4),
              const Text(
                'Create a new account to get started',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // FORM CARD
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
                          keyboardType: TextInputType.emailAddress,
                          validatorText: 'Email tidak boleh kosong',
                          prefixIcon: Icons.email_outlined,
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
                          obscureText: true,
                          validatorText: 'Password tidak boleh kosong',
                          prefixIcon: Icons.lock_outline,
                        ),

                        const SpaceHeight(30),
                        BlocConsumer<RegisterBloc, RegisterState>(
                          listener: (context, state) {
                            if (state is RegisterLoading) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (_) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              );
                            } else if (state is RegisterSuccess) {
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Registrasi Berhasil: ${state.responseModel.message}',
                                  ),
                                ),
                              );
                              context.pop(); // Kembali ke Login
                            } else if (state is RegisterFailure) {
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Registrasi Gagal: ${state.error}',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return AuthButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final requestModel = RegisterRequestModel(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  context.read<RegisterBloc>().add(
                                    RegisterRequested(
                                      requestModel: requestModel,
                                    ),
                                  );
                                }
                              },
                              isLoading: state is RegisterLoading,
                              label: 'REGISTER',
                            );
                          },
                        ),

                        const SpaceHeight(20),
                        Center(
                          child: TextButton(
                            onPressed: () => context.pop(),
                            child: const Text(
                              'Sudah punya akun? Masuk di sini.',
                              style: TextStyle(
                                color: Color(0xFF3A60C0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
