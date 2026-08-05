import 'package:flutter/material.dart';
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/services/token_service.dart';

class DecisionScreen extends StatefulWidget {
  const DecisionScreen({super.key});

  @override
  State<DecisionScreen> createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    // A small delay can be added here if you want to show a splash logo
    // await Future.delayed(const Duration(seconds: 1));
    final tokenService = TokenService();
    final loggedIn = await tokenService.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      Navigator.pushReplacementNamed(context, entryPointScreenRoute);
    } else {
      Navigator.pushReplacementNamed(context, onbordingScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
