import 'package:flutter/material.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/services/auth_service.dart';

import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthService().sendOTP(
        phone: _phoneController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      if (response["statusCode"] != 200) {
        throw Exception(
          (response["body"]?["message"] ?? "Failed to send OTP").toString(),
        );
      }

      final otpVerified = await Navigator.pushNamed(
        context,
        otpScreenRoute,
        arguments: {
          'phoneNumber': _phoneController.text.trim(),
          'isLoginFlow': true,
        },
      );

      if (!mounted) {
        return;
      }

      if (otpVerified == true) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          entryPointScreenRoute,
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst("Exception: ", ""),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/login_dark.png",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Log in with your phone number. We'll send an OTP.",
                  ),
                  const SizedBox(height: defaultPadding),
                  LogInForm(
                    formKey: _formKey,
                    phoneController: _phoneController,
                  ),
                  Align(
                    child: TextButton(
                      child: const Text("Forgot password"),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, passwordRecoveryScreenRoute);
                      },
                    ),
                  ),
                  SizedBox(
                    height:
                        size.height > 700 ? size.height * 0.1 : defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Log in"),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              entryPointScreenRoute,
                              (route) => false,
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE85D92)),
                    ),
                    child: const Text("Skip login"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: const Text("Sign up"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
