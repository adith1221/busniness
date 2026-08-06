import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

class LogInForm extends StatelessWidget {
  const LogInForm({
    super.key,
    required this.formKey,
    required this.phoneController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: phoneController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Phone number is required";
              }
              if (value.trim().length < 10) {
                return "Enter a valid phone number";
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Phone number",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
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
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
