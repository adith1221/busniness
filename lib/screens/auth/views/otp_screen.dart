import 'package:flutter/material.dart';
import 'package:busniness/services/api_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String? email;
  final String? password;
  final bool isLoginFlow;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    this.email,
    this.password,
    this.isLoginFlow = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _verifyAndRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Verify OTP and get tokens
      await ApiService.verifyOtp(
        widget.phoneNumber,
        _otpController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            "Verification failed. Please check the OTP and try again.";
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
      appBar: AppBar(title: const Text("Verify Phone Number")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("An OTP was printed in the terminal. Please enter it below.",
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "OTP", hintText: "Enter OTP"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "OTP is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _verifyAndRegister,
                  child: const Text("Verify & Register"),
                ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(_errorMessage!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
