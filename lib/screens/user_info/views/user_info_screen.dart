import 'package:flutter/material.dart';
import 'package:busniness/components/network_image_with_loader.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/route/route_constants.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String _fullName = 'Sepide Rahimi';
  String _email = 'theflutterway@gmail.com';
  String _mobileNumber = '+1 555 123 4567';
  String _dateOfBirth = '12 Jun 1994';
  String _gender = 'Female';
  String? _editingField;
  String _draftValue = '';
  final TextEditingController _editorController = TextEditingController();

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            defaultPadding,
            defaultPadding / 2,
            defaultPadding,
            defaultPadding * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: defaultPadding),
              Text('Personal Information',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: defaultPadding / 2),
              EditableProfileField(
                label: 'Full Name',
                value: _fullName,
                icon: Icons.person_outline_rounded,
                isEditing: _editingField == 'fullName',
                controller: _editorController,
                draftValue: _draftValue,
                onEditPressed: () => _startEditing('fullName', _fullName),
                onSavePressed: _saveEditing,
                onCancelPressed: _cancelEditing,
                onDraftChanged: (value) => setState(() => _draftValue = value),
              ),
              const SizedBox(height: defaultPadding / 2),
              EditableProfileField(
                label: 'Email Address',
                value: _email,
                icon: Icons.email_outlined,
                isEditing: _editingField == 'email',
                controller: _editorController,
                draftValue: _draftValue,
                onEditPressed: () => _startEditing('email', _email),
                onSavePressed: _saveEditing,
                onCancelPressed: _cancelEditing,
                onDraftChanged: (value) => setState(() => _draftValue = value),
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: defaultPadding / 2),
              EditableProfileField(
                label: 'Mobile Number',
                value: _mobileNumber,
                icon: Icons.phone_outlined,
                isEditing: _editingField == 'mobile',
                controller: _editorController,
                draftValue: _draftValue,
                onEditPressed: () => _startEditing('mobile', _mobileNumber),
                onSavePressed: _saveEditing,
                onCancelPressed: _cancelEditing,
                onDraftChanged: (value) => setState(() => _draftValue = value),
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: defaultPadding / 2),
              EditableProfileField(
                label: 'Date of Birth',
                value: _dateOfBirth,
                icon: Icons.cake_outlined,
                isEditing: _editingField == 'dob',
                controller: _editorController,
                draftValue: _draftValue,
                onEditPressed: () => _startEditing('dob', _dateOfBirth),
                onSavePressed: _saveEditing,
                onCancelPressed: _cancelEditing,
                onDraftChanged: (value) => setState(() => _draftValue = value),
              ),
              const SizedBox(height: defaultPadding / 2),
              EditableProfileField(
                label: 'Gender',
                value: _gender,
                icon: Icons.transgender_outlined,
                isEditing: _editingField == 'gender',
                controller: _editorController,
                draftValue: _draftValue,
                onEditPressed: () => _startEditing('gender', _gender),
                onSavePressed: _saveEditing,
                onCancelPressed: _cancelEditing,
                onDraftChanged: (value) => setState(() => _draftValue = value),
                isSelector: true,
                onSelectorChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _draftValue = newValue);
                  }
                },
              ),
              const SizedBox(height: defaultPadding),
              Text('Account', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: defaultPadding / 2),
              EditableProfileField(
                label: 'Email',
                value: _email,
                icon: Icons.mail_outline,
                isEditing: _editingField == 'email',
                controller: _editorController,
                draftValue: _draftValue,
                onEditPressed: () => _startEditing('email', _email),
                onSavePressed: _saveEditing,
                onCancelPressed: _cancelEditing,
                onDraftChanged: (value) => setState(() => _draftValue = value),
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: defaultPadding / 2),
              EditableProfileField(
                label: 'Mobile Number',
                value: _mobileNumber,
                icon: Icons.phone_android_outlined,
                isEditing: _editingField == 'mobile',
                controller: _editorController,
                draftValue: _draftValue,
                onEditPressed: () => _startEditing('mobile', _mobileNumber),
                onSavePressed: _saveEditing,
                onCancelPressed: _cancelEditing,
                onDraftChanged: (value) => setState(() => _draftValue = value),
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: defaultPadding),
              Text('Address', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: defaultPadding / 2),
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.home_outlined, color: primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Default Address',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '123 Market Street, New York, NY 10001',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, addressesScreenRoute),
                        icon: const Icon(Icons.location_on_outlined),
                        label: const Text('Manage Addresses'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              Text('Security', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: defaultPadding / 2),
              _buildReadOnlyRow(
                  context, 'Change Password', 'Update your password',
                  icon: Icons.lock_outline_rounded),
              const SizedBox(height: defaultPadding / 2),
              _buildReadOnlyRow(
                  context, 'Privacy Policy', 'Review our privacy terms',
                  icon: Icons.privacy_tip_outlined),
              const SizedBox(height: defaultPadding / 2),
              _buildReadOnlyRow(
                  context, 'Terms & Conditions', 'Read our policies',
                  icon: Icons.description_outlined),
              const SizedBox(height: defaultPadding * 1.2),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showLogoutDialog,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: errorColor,
                    side: const BorderSide(color: errorColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(defaultBorderRadious),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: primaryColor.withOpacity(0.2), width: 3),
                ),
                child: ClipOval(
                  child: NetworkImageWithLoader(
                    'https://i.imgur.com/IXnwbLk.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          Text(
            _fullName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Member since Jan 2024',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyRow(
    BuildContext context,
    String title,
    String value, {
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startEditing(String fieldKey, String currentValue) {
    setState(() {
      _editingField = fieldKey;
      _draftValue = currentValue;
      _editorController.text = currentValue;
    });
  }

  void _saveEditing() {
    if (_editingField == null) {
      return;
    }

    setState(() {
      switch (_editingField) {
        case 'fullName':
          _fullName = _draftValue.trim().isEmpty ? _fullName : _draftValue;
          break;
        case 'email':
          _email = _draftValue.trim().isEmpty ? _email : _draftValue;
          break;
        case 'mobile':
          _mobileNumber =
              _draftValue.trim().isEmpty ? _mobileNumber : _draftValue;
          break;
        case 'dob':
          _dateOfBirth =
              _draftValue.trim().isEmpty ? _dateOfBirth : _draftValue;
          break;
        case 'gender':
          _gender = _draftValue.trim().isEmpty ? _gender : _draftValue;
          break;
      }
      _editingField = null;
      _draftValue = '';
      _editorController.clear();
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingField = null;
      _draftValue = '';
      _editorController.clear();
    });
  }

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

class EditableProfileField extends StatelessWidget {
  const EditableProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.isEditing,
    required this.controller,
    required this.draftValue,
    required this.onEditPressed,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.onDraftChanged,
    this.inputType,
    this.isSelector = false,
    this.onSelectorChanged,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isEditing;
  final TextEditingController controller;
  final String draftValue;
  final VoidCallback onEditPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;
  final ValueChanged<String> onDraftChanged;
  final TextInputType? inputType;
  final bool isSelector;
  final ValueChanged<String?>? onSelectorChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 19),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    if (isEditing)
                      const SizedBox.shrink()
                    else
                      Text(value,
                          style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEditPressed,
                icon: const Icon(Icons.edit_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (isEditing) ...[
            const SizedBox(height: 12),
            if (isSelector)
              DropdownButtonFormField<String>(
                value: draftValue.isNotEmpty ? draftValue : value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8F6FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: onSelectorChanged,
              )
            else
              TextFormField(
                controller: controller,
                autofocus: true,
                keyboardType: inputType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8F6FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: onDraftChanged,
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(
                    onPressed: onCancelPressed, child: const Text('Cancel')),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: onSavePressed, child: const Text('Save')),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
