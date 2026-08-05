import 'package:flutter/material.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/services/api_service.dart';
import 'components/sign_up_form.dart';
import 'otp_screen.dart'; // Assuming this file exists and is correct

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ApiService.sendOtp(_phoneController.text.trim());

      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OtpScreen(
            phoneNumber: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        ));
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const SizedBox(height: defaultPadding * 2),
              Text("Sign Up", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: defaultPadding * 2),
              SignUpForm(
                formKey: _formKey,
                phoneController: _phoneController,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              const SizedBox(height: defaultPadding * 2),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _sendOtp,
                  child: const Text("Continue"),
                ),
              if (_errorMessage != null) ...[
                const SizedBox(height: defaultPadding),
                Text(_errorMessage!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
