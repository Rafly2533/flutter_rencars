// TODO Implement this library.// TODO Implement this library.import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ⚠️ GANTI DENGAN IP KOMPUTER KAMU!
  // Untuk emulator Android: 10.0.2.2
  // Untuk HP real: IP komputer (contoh: 192.168.1.100)
  static const String baseUrl = 'http://10.10.10.182:8000/api';
  
  // ========== HELPER: GET HEADERS WITH TOKEN ==========
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  
  // ========== AUTH ==========
  
  // REGISTER
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );
    
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('role', data['user']['role']);
      await prefs.setInt('userId', data['user']['id']);
      await prefs.setString('userName', data['user']['name']);
      await prefs.setString('userEmail', data['user']['email']);
      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Register gagal');
    }
  }
  
  // LOGIN
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('role', data['role']);
      await prefs.setInt('userId', data['user']['id']);
      await prefs.setString('userName', data['user']['name']);
      await prefs.setString('userEmail', data['user']['email']);
      return data;
    } else {
      throw Exception('Email atau password salah');
    }
  }
  
  // LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token != null) {
      try {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        print('Logout error: $e');
      }
    }
    
    await prefs.clear(); // Hapus semua data SharedPreferences
  }
  
  // GET TOKEN
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  
  // GET ROLE
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
  
  // ========== PROFILE (BARU) ==========
  
  // GET PROFILE - Mengambil data profil lengkap
  Future<Map<String, dynamic>> getProfile() async {
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data profil');
    }
  }
  
  // UPDATE PROFILE - Mengupdate nama, no HP, tanggal lahir, alamat
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    String? phone,
    String? birthDate,
    String? address,
  }) async {
    final headers = await _getHeaders();
    
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'phone': phone ?? '',
        'birth_date': birthDate ?? '',
        'address': address ?? '',
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Update nama di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      
      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['errors'] ?? error['message'] ?? 'Gagal mengupdate profil');
    }
  }
  
  // UPLOAD PHOTO - Upload foto profil
  Future<Map<String, dynamic>> uploadProfilePhoto(File photoFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/profile/photo'),
    );
    
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('photo', photoFile.path));
    
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    
    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      final error = jsonDecode(responseBody);
      throw Exception(error['errors'] ?? error['message'] ?? 'Gagal upload foto');
    }
  }
}