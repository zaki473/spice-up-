import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:flutter/services.dart'; // Untuk kontrol status bar
import 'package:flutter_svg/flutter_svg.dart';
import 'firebase_options.dart';
import 'constants/app_colors.dart';
import 'screens/login_screen.dart';
import 'utils/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SpiceUpApp());
}

class SpiceUpApp extends StatelessWidget {
  const SpiceUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spice Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.backgroundBottom,
      ),
      home: const SplashScreen(), 
    );
  }
}

// --- SPLASH SCREEN DENGAN ANIMASI ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // 1. Sembunyikan Status Bar (Baterai/Jam) agar terlihat Fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // 2. Inisialisasi Animasi (Logo akan membesar perlahan)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();

    // 3. Timer untuk pindah halaman
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        // Kembalikan Status Bar ke mode normal
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // Inisialisasi SizeConfig HANYA SEKALI di root
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Efek Dekorasi Lingkaran di Background (Opsional agar tidak terlalu polos)
            Positioned(
              top: -50.h,
              right: -50.w,
              child: CircleAvatar(radius: 100.w, backgroundColor: Colors.white.withOpacity(0.1)),
            ),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo dengan Animasi Scale (Membesar perlahan)
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 250.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                
                // Teks Tambahan agar terlihat eksklusif
                Text(
                  "SPICE UP",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 4.w,
                  ),
                ),
                Text(
                  "Authentic Indonesian Taste",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 1.2.w,
                  ),
                ),
                
                SizedBox(height: 60.h),
                
                // Loading Indicator yang lebih halus
                SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                ),
              ],
            ),
            
            // Penanda Versi di bagian bawah
            Positioned(
              bottom: 30.h,
              child: Text(
                "v1.0.0",
                style: TextStyle(color: Colors.white54, fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}