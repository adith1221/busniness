import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          //----------------------------------------
          // Phone Number
          //----------------------------------------

          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Phone Number",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.75,
                ),
                child: SvgPicture.asset(
                  "assets/icons/Call.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withValues(alpha: 0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Phone number is required";
              }

              if (value.length < 10) {
                return "Enter a valid phone number";
              }

              return null;
            },
          ),

          const SizedBox(height: defaultPadding),

          //----------------------------------------
          // Email
          //----------------------------------------

          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Email Address",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.75,
                ),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withValues(alpha: 0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Email is required";
              }

              final emailRegex = RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              );

              if (!emailRegex.hasMatch(value.trim())) {
                return "Enter a valid email";
              }

              return null;
            },
          ),

          const SizedBox(height: defaultPadding),

          //----------------------------------------
          // Password
          //----------------------------------------

          TextFormField(
            controller: passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.75,
                ),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withValues(alpha: 0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }

              if (value.length < 8) {
                return "Password must be at least 8 characters";
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
