import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int navIndex = 3;

  void onNavTap(int index) {
    setState(() => navIndex = index);
  }

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
                      backgroundImage: AssetImage('assets/images/profile.png'),
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
                        Colors.orange.withValues(alpha: 0.3),
                        Colors.black,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
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
                _menuItem(Icons.settings, "Account Settings"),
                _menuItem(Icons.credit_card, "Payment Method"),
                _menuItem(Icons.support_agent, "Contact Support"),

                const SizedBox(height: 20),

                /// 🔥 LOGOUT
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(122, 255, 153, 0),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
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

  Widget _menuItem(IconData icon, String title) {
    return Container(
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
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}