import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saku_app/core/session/user_session.dart';
import 'package:saku_app/views/login/login_screen.dart';
import 'package:saku_app/views/main/edit_profil.screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = UserSession.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                backgroundImage: _avatarProvider(user?.avatar),
              ),

              const SizedBox(height: 18),

              Text(
                user?.name ?? 'Guest',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                user?.email ?? 'Tidak ada email',
                style: const TextStyle(color: Colors.grey, fontSize: 17),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff3B82F6), Color(0xff2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Saldo Saat Ini',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Rp 12.450,75',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _menuTile(
                icon: Icons.person_outline,
                title: "Edit Profile",
                onTap: () async {
                  final user = UserSession.currentUser;

                  if (user == null) return;

                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(userId: user.id),
                    ),
                  );

                  if (result == true) {
                    setState(() {});
                  }
                },
              ),

              const SizedBox(height: 14),

              _menuTile(
                icon: Icons.notifications_none,
                title: 'Notifikasi',
                onTap: () {},
              ),

              const SizedBox(height: 14),

              _menuTile(
                icon: Icons.lock_outline,
                title: 'Keamanan',
                onTap: () {},
              ),

              const SizedBox(height: 14),

              SwitchListTile(
                value: false,
                onChanged: (v) {},
                activeColor: const Color(0xff2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                tileColor: Colors.white,
                secondary: const Icon(
                  Icons.dark_mode_outlined,
                  color: Color(0xff2563EB),
                ),
                title: const Text(
                  'Mode Gelap',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),

              const SizedBox(height: 14),

              _menuTile(
                icon: Icons.help_outline,
                title: 'Pusat Bantuan',
                onTap: () {},
              ),

              const SizedBox(height: 14),

              _menuTile(
                icon: Icons.info_outline,
                title: 'Tentang Aplikasi',
                onTap: () {},
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () async {
                    await UserSession.clear();
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Keluar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _avatarProvider(String? avatar) {
    if (avatar != null && avatar.isNotEmpty) {
      if (avatar.startsWith('http')) {
        return NetworkImage(avatar);
      }
      final file = File(avatar);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    return const NetworkImage('https://i.pravatar.cc/200');
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xff2563EB)),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
