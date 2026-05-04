import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.orangePrimary))
      );

      try {
        // 1. Buat user di Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text,
        );

        // 2. Set Firebase Profil Name
        await userCredential.user?.updateDisplayName(_nameController.text.trim());

        // 3. Simpan data user ke Cloud Firestore (Tabel Users)
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'display_name': _nameController.text.trim(), 
          'full_name': _nameController.text.trim(),  
          'email': _emailController.text.trim(),
          'total_score': 0,
          'badges': [],
        });

        if (!mounted) return;
        Navigator.pop(context); // Tutup loading loading

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful! Silakan Login.'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Kembali ke login screen
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Tutup loading loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed'), backgroundColor: Colors.red),
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
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/logo_dan_bg/SU_MAIN_BG01.svg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
                      width: 200, // Ukuran sedikit lebih kecil untuk memberi ruang form
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
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
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text('Create Account', 
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark)
                            ),
                            const SizedBox(height: 25),

                            // Name
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person_outline, color: AppColors.orangePrimary),
                              ),
                              validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
                            ),
                            const SizedBox(height: 15),

                            // Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined, color: AppColors.orangePrimary),
                              ),
                              validator: (value) => !value!.contains('@') ? 'Invalid email' : null,
                            ),
                            const SizedBox(height: 15),

                            // Password
                            TextFormField(
                              controller: _passController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.orangePrimary),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                                  onPressed: () => setState(() => _obscureText = !_obscureText),
                                ),
                              ),
                              validator: (value) => value!.length < 6 ? 'Min. 6 characters' : null,
                            ),
                            const SizedBox(height: 15),

                            // Confirm Password
                            TextFormField(
                              controller: _confirmPassController,
                              obscureText: _obscureText,
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock_reset, color: AppColors.orangePrimary),
                              ),
                              validator: (value) => value != _passController.text ? 'Passwords do not match' : null,
                            ),
                            const SizedBox(height: 30),

                            // Tombol Register
                            GestureDetector(
                              onTap: _handleRegister,
                              child: Container(
                                width: 220, height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: const LinearGradient(colors: [AppColors.orangeLight, AppColors.orangePrimary]),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
                                ),
                                child: const Center(child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Back to Login
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Already have an account? Log In', style: TextStyle(color: AppColors.orangePrimary)),
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