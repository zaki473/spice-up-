import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';
import 'customization_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'homepage_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.orangePrimary))
      );

      try {
        UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text,
        );

        if (!mounted) return;

        // Cek data User di Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).get();
        Navigator.pop(context); // Tutup loading

        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('avatar_settings')) {
          var avatar = data['avatar_settings'];
          // Langsung ke Homepage karena sudah pernah Customization
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomepageScreen(
                skinPath: avatar['skin'] ?? 'assets/images/skin/SU_AVATAR_SKIN01.svg',
                eyePath: avatar['eyes'] ?? 'assets/images/eye/SU_AVATAR_EYE1.svg',
                mouthPath: avatar['mouth'] ?? 'assets/images/mouth/SU_AVATAR_MOUTH1.svg',
                nosePath: avatar['nose'] ?? 'assets/images/nose/SU_AVATAR_NOSE1.svg',
                browsPath: avatar['brows'] ?? 'assets/images/brows/SU_AVATAR_BROWS1.svg',
                hairPath: avatar['hair'] ?? 'assets/images/hair/SU_AVATAR_HAIR1.png',
                bangsPath: avatar['bangs'] ?? 'assets/images/bangs/SU_AVATAR_BANGS1.svg',
                shirtPath: avatar['top'] ?? 'assets/images/top/SU_AVATAR_TOP1.png',
                shirtColor: Colors.white,
                hairStyle: Icons.face,
              ),
            ),
          );
        } else {
          // Belum punya avatar, paksa Customization dulu
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CharacterCustomizationScreen(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Tutup loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/logo_dan_bg/SU_MAIN_BG01.svg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Konten Utama
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
                      width: 280,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 40,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Input Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: AppColors.orangePrimary,
                                ),
                              ),
                              validator: (value) => !value!.contains('@')
                                  ? 'Enter a valid email'
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            // Input Password
                            TextFormField(
                              controller: _passController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.orangePrimary,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureText = !_obscureText,
                                  ),
                                ),
                              ),
                              validator: (value) => value!.length < 6
                                  ? 'Password too short'
                                  : null,
                            ),
                            const SizedBox(height: 40),
                            // Tombol Log In
                            GestureDetector(
                              onTap: _handleLogin,
                              child: Container(
                                width: 220,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.orangeLight,
                                      AppColors.orangePrimary,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Tombol Create Account
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.orangePrimary,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: AppColors.orangePrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
