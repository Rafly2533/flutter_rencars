import 'package:flutter/material.dart';
import 'register.dart';
import 'dashboard.dart'; // pastikan dashboard.dart sudah dibuat

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  
  // Controllers untuk mengambil input dari text field
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Title
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Rent",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: "Cars",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4DA3FF),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Text(
                    "Rental Mobil",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 40),

                  // Email
                  _buildInput(
                    hint: "Email",
                    icon: Icons.email_outlined,
                    controller: _emailController,
                  ),

                  const SizedBox(height: 16),

                  // Password
                  _buildInput(
                    hint: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Tambahkan fungsi forgot password di sini
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur forgot password sedang dalam pengembangan'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.blue.shade200),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Button
                  GestureDetector(
                    onTap: _handleLogin,
                    child: _buildButton("Login"),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Don't have any account?",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  // Register Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterPage(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: const Text(
                      "Registrasi",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Social icons (dummy)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: const Text("G"),
                      ),
                      const SizedBox(width: 16),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: const Text("M"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Help  •  Privacy Policy",
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk handle login
  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validasi sederhana
    if (email.isEmpty) {
      _showErrorDialog('Email tidak boleh kosong');
      return;
    }

    if (password.isEmpty) {
      _showErrorDialog('Password tidak boleh kosong');
      return;
    }

    // Validasi email sederhana (minimal mengandung @)
    if (!email.contains('@')) {
      _showErrorDialog('Email tidak valid');
      return;
    }

    // Contoh validasi sederhana (bisa diganti dengan logic login sesungguhnya)
    // Untuk demo, semua email dan password yang tidak kosong akan berhasil login
    // Anda bisa mengganti dengan validasi ke API/database nantinya
    
    // Contoh validasi spesifik (opsional):
    // if (email == 'admin@rentcars.com' && password == 'admin123') {
    //   _loginSuccess();
    // } else {
    //   _showErrorDialog('Email atau password salah');
    // }
    
    // Untuk sementara, semua input yang valid akan berhasil login
    _loginSuccess();
  }

  // Fungsi ketika login berhasil
  void _loginSuccess() {
    // Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login berhasil!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    // Navigasi ke dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
  }

  // Fungsi untuk menampilkan error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5DA9E9), Color(0xFF3B6FE2)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}