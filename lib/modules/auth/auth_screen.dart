import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layouts/home_layout.dart';
import '../../shared/cubit/auth_cubit/auth_cubit.dart';
import '../../shared/cubit/auth_cubit/auth_states.dart';
import '../../shared/widgets/components.dart';


class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final _authCubit = AuthCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Text(
                          'INSTAGRAM',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 100),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (!_authCubit.isLogin) ...[
                                defaultTextField(
                                  controller: _nameController,
                                  hint: 'Jack Sparow',
                                  label: 'Username',
                                ),
                                const SizedBox(height: 12),
                                defaultTextField(
                                  controller: _phoneController,
                                  hint: '01031245141',
                                  label: 'Phone Number',
                                  type: const TextInputType.numberWithOptions(),
                                ),
                                const SizedBox(height: 12),
                              ],
                              defaultTextField(
                                controller: _emailController,
                                hint: 'someone@gmail.com',
                                label: 'Email',
                                type: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              defaultTextField(
                                controller: _passController,
                                hint: '**********',
                                label: 'Password',
                                type: TextInputType.visiblePassword,
                                isPassword: true,
                                showPassword: _authCubit.showPass,
                                changePassVisibility: () =>
                                    _authCubit.changePassVisibility(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        defaultButton(
                          title: (_authCubit.isLogin) ? 'LOGIN' : 'REGISTER',
                          btnFun: () {
                            if (_formKey.currentState!.validate()) {
                              if (_authCubit.isLogin) {
                                _authCubit
                                    .logUserIn(
                                        email: _emailController.text,
                                        password: _passController.text)
                                    .then(
                                  (success) {
                                    if (success) {
                                      navigateRemove(context,
                                          page: const HomeLayout());
                                    }
                                  },
                                );
                              } else {
                                _authCubit
                                    .createNewUser(
                                        email: _emailController.text,
                                        password: _passController.text,
                                        username: _nameController.text,
                                        phoneNumber: _phoneController.text)
                                    .then((success) {
                                  if (success) {
                                    navigateRemove(context,
                                        page: const HomeLayout());
                                  }
                                });
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => _authCubit.changePageState(),
                          child: Text(
                            (_authCubit.isLogin)
                                ? 'Don\'t have an account? Register'
                                : 'Already have an account? Login',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
