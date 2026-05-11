import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'payment_method_screen.dart';
import 'account_settings_screen.dart';
import '../login_screen.dart'; // ← TAMBAH INI

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                /// 🔥 PROFILE HEADER
                Column(
                  children: [
                    const SizedBox(height: 30),
                    CircleAvatar(
                      radius: 45,
                      backgroundImage:
                          const AssetImage('assets/images/profile.png'),
                      backgroundColor: Colors.grey[900],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Alyssaa",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "alyssa@gmail.com",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// 🔥 BALANCE CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.3),
                        Colors.black,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Asset",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Rp 135.000.000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "+10% This Month",
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 MENU
                _menuItem(
                  icon: Icons.settings,
                  title: "Account Settings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AccountSettingsScreen(),
                      ),
                    );
                  },
                ),
                _menuItem(
                  icon: Icons.credit_card,
                  title: "Payment Method",
                  onTap: () {
                    // ← NAVIGASI KE PAYMENT METHOD
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PaymentMethodScreen(),
                      ),
                    );
                  },
                ),
                _menuItem(
                  icon: Icons.support_agent,
                  title: "Contact Support",
                  onTap: () {
                    // Tambahkan navigasi ke Contact Support nanti
                  },
                ),

                const SizedBox(height: 20),

                /// 🔥 LOGOUT
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(122, 255, 153, 0),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () {
                    // Kembali ke LoginScreen dan hapus semua history navigasi
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(color: Colors.white)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}