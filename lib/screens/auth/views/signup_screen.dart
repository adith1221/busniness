import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/screens/auth/views/components/sign_up_form.dart';
import 'package:busniness/services/auth_service.dart';
import 'package:busniness/services/token_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isChecked = false;

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleContinue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept Terms & Privacy Policy"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 1. Send OTP
      final otpResponse =
          await AuthService().sendOTP(phone: phoneController.text.trim());

      if (!mounted) return;

      if (otpResponse["statusCode"] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Sent Successfully")),
        );

        // 2. Navigate to OTP screen and wait for result
        final otpVerified = await Navigator.pushNamed(
          context,
          otpScreenRoute,
          arguments: {
            'phoneNumber': phoneController.text.trim(),
            'isLoginFlow': false,
          },
        );

        // 3. If OTP is verified, register the user
        if (otpVerified == true) {
          final registerResponse = await AuthService().register(
            phone: phoneController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

          if (!mounted) return;

          if (registerResponse["statusCode"] == 201) {
            // 4. Save tokens
            await TokenService().saveTokens(
              accessToken: registerResponse["body"]["access"],
              refreshToken: registerResponse["body"]["refresh"],
            );

            // 5. Navigate to home
            Navigator.pushNamedAndRemoveUntil(
              context,
              entryPointScreenRoute,
              (route) => false,
            );
          } else {
            throw Exception(registerResponse["body"]["message"]?.toString() ??
                "Registration failed");
          }
        } // If otpVerified is not true, do nothing (user might have pressed back)
      } else {
        throw Exception(otpResponse["body"]["message"] ?? "Failed to send OTP");
      }
    } catch (e) {
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
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signUp_dark.png",
              height: MediaQuery.of(context).size.height * .35,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's get started!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Please enter your valid data in order to create an account.",
                  ),
                  const SizedBox(height: defaultPadding),
                  SignUpForm(
                    formKey: _formKey,
                    phoneController: phoneController,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "I agree with the ",
                            children: [
                              TextSpan(
                                text: "Terms of Service ",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      termsOfServicesScreenRoute,
                                    );
                                  },
                              ),
                              const TextSpan(
                                text: "& Privacy Policy",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : handleContinue,
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Continue"),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do you have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            logInScreenRoute,
                          );
                        },
                        child: const Text("Log in"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
