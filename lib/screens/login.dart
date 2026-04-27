import 'package:flutter/material.dart';
import 'login1.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back2.png'), // Ganti dengan path foto Anda
            fit: BoxFit.cover, // Cover seluruh layar
          ),
        ),
        child: Container(
          // Overlay gelap agar teks lebih terbaca (opsional)
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: const Color.fromARGB(255, 192, 190, 190).withOpacity(0.4),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // Title
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Rent",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 46, 2, 112),
                        ),
                      ),
                      TextSpan(
                        text: "Cars",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Rental Mobil",
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(179, 0, 0, 0),
                  ),
                ),

                const SizedBox(height: 40),

                // Gambar mobil
                Image.asset(
                  'assets/images/mobil.png', // masukkan gambar mobil ke assets
                  height: 300,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 40),

                // Tombol Get Started
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // bisa arahkan ke dashboard atau onboarding
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tombol Login
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // ignore: deprecated_member_use
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 40);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 40,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 80,
      size.width,
      size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}