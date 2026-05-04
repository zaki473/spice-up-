import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  void _changePassword() async {
    String newPass = _passController.text;
    String confirmPass = _confirmPassController.text;

    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password minimal 6 karakter!"),
          backgroundColor: Colors.red));
      return;
    }
    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Konfirmasi password tidak cocok!"),
          backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newPass);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password berhasil diperbarui!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.message ??
                'Gagal mengganti password. Silakan login ulang dan coba lagi.'),
            backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan tinggi layar untuk perhitungan responsif
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Menghindari isi layar terpotong keyboard
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background tetap full
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/logo_dan_bg/SU_MAIN_BG01.svg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    // Memastikan konten setidaknya setinggi layar agar container putih di bawah
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bagian Atas: Logo
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                          child: SvgPicture.asset(
                            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
                            width: 200,
                          ),
                        ),

                        // Bagian Bawah: Form Container
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                          decoration: const BoxDecoration(
                            color: AppColors.cardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Set a new password for your account to keep it secure.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 30),
                              
                              // Input Password Baru
                              TextFormField(
                                controller: _passController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                  prefixIcon: const Icon(Icons.lock_outline,
                                      color: AppColors.orangePrimary),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey),
                                    onPressed: () => setState(
                                        () => _obscureText = !_obscureText),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Input Konfirmasi
                              TextFormField(
                                controller: _confirmPassController,
                                obscureText: _obscureText,
                                decoration: const InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: Icon(Icons.lock_reset,
                                      color: AppColors.orangePrimary),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Tombol Save
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _changePassword,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)),
                                  ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: _isLoading
                                            ? [Colors.grey, Colors.grey.shade400]
                                            : [AppColors.orangeLight, AppColors.orangePrimary],
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2),
                                            )
                                          : const Text(
                                              'Save Password',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 10),
                              
                              // Tombol Cancel
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: AppColors.orangePrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}