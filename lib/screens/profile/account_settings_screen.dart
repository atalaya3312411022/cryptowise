import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  // ── Controllers ──
  final _nameController = TextEditingController(text: 'Alysaa');
  final _emailController = TextEditingController(text: 'Alyssaa@gmail.com');
  final _passwordController = TextEditingController(text: '12345');
  final _phoneController = TextEditingController(text: '08**-****-****');

  bool _obscurePassword = true;

  // ── Warna tema CryptoWise ──
  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF1A1A1A);
  static const Color _gold = Color(0xFFD4A017);
  static const Color _goldDark = Color(0xFF8B6914);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _grey = Color(0xFF888888);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Tutup keyboard
    FocusScope.of(context).unfocus();

    // ── Alert hijau "Profile updated successfully" ──
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: const Color(0xFFE8F5E9),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.green, size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Profile updated successfully',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child:
                  const Icon(Icons.close, color: Colors.green, size: 18),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: _white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(
              color: _white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // ── Profile Header ──
            _buildProfileHeader(),
            const SizedBox(height: 24),

            // ── Form Card ──
            _buildFormCard(),
            const SizedBox(height: 20),

            // ── Tombol Save ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _goldDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _save,
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Profile Header ──
  Widget _buildProfileHeader() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Stack(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage:
                  const AssetImage('assets/images/profile.png'),
              backgroundColor: Colors.grey[900],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _gold,
                  shape: BoxShape.circle,
                  border: Border.all(color: _bg, width: 2),
                ),
                child: const Icon(Icons.edit, color: _white, size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _nameController.text,
          style: const TextStyle(
              color: _white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          _emailController.text,
          style: const TextStyle(color: _grey, fontSize: 13),
        ),
      ],
    );
  }

  // ── Form Card ──
  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 0.8),
      ),
      child: Column(
        children: [
          _buildField(
            label: 'Full Name',
            controller: _nameController,
            keyboardType: TextInputType.name,
          ),
          _divider(),
          _buildField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          _divider(),
          _buildPasswordField(),
          _divider(),
          _buildField(
            label: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(color: Color(0xFF2A2A2A), height: 1, indent: 16);

  // ── Field selalu bisa diedit ──
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(color: _grey, fontSize: 14)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                  color: _white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
              cursorColor: _gold,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Password field dengan toggle show/hide ──
  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const SizedBox(
            width: 110,
            child: Text('Password',
                style: TextStyle(color: _grey, fontSize: 14)),
          ),
          Expanded(
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(
                  color: _white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
              cursorColor: _gold,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                suffixIcon: GestureDetector(
                  onTap: () => setState(
                      () => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: _grey,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}