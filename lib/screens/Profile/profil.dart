import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  
  // Data profil
  Map<String, dynamic> _profileData = {};
  
  // Controllers untuk form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  // Tanggal lahir
  DateTime? _selectedBirthDate;
  
  // Foto profil
  String? _profilePhotoUrl;
  File? _selectedImage;
  
  // 🔥 PERBAIKAN: Buat instance ApiService
  final ApiService _apiService = ApiService();
  
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  
  // Ambil data profil dari API
  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // 🔥 PERBAIKAN: Panggil method melalui instance
      final response = await _apiService.getProfile();
      
      if (response['name'] != null) {
        setState(() {
          _profileData = response;
          _nameController.text = response['name'] ?? '';
          _phoneController.text = response['phone'] ?? '';
          _addressController.text = response['address'] ?? '';
          _profilePhotoUrl = response['profile_photo_url'];
          
          if (response['birth_date'] != null && response['birth_date'] != '') {
            _selectedBirthDate = DateTime.parse(response['birth_date']);
          }
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data profil: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Simpan perubahan profil
  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      // 🔥 PERBAIKAN: Panggil method melalui instance
      final response = await _apiService.updateProfile(
        name: _nameController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        birthDate: _selectedBirthDate != null 
            ? "${_selectedBirthDate!.year}-${_selectedBirthDate!.month.toString().padLeft(2, '0')}-${_selectedBirthDate!.day.toString().padLeft(2, '0')}"
            : null,
        address: _addressController.text.isEmpty ? null : _addressController.text,
      );
      
      if (response['message'] != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
          // Refresh data setelah update
          await _fetchProfile();
        }
      }
    } catch (e) {
      print('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan profil: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  
  // Pilih gambar dari galeri
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        
        // Upload foto
        await _uploadPhoto();
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: ${e.toString()}')),
        );
      }
    }
  }
  
  // Upload foto profil
  Future<void> _uploadPhoto() async {
    if (_selectedImage == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // 🔥 PERBAIKAN: Panggil method melalui instance
      final response = await _apiService.uploadProfilePhoto(_selectedImage!);
      
      if (response['message'] != null) {
        // Refresh profil untuk mendapatkan URL foto baru
        await _fetchProfile();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      }
    } catch (e) {
      print('Error uploading photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal upload foto: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _selectedImage = null;
        });
      }
    }
  }
  
  // Pilih tanggal lahir
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }
  
  // Logout
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      // 🔥 PERBAIKAN: Panggil method melalui instance
      await _apiService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: const Color.fromARGB(255, 140, 202, 253),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ========== FOTO PROFIL ==========
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: const Color.fromARGB(255, 41, 158, 255),
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
                                    ? NetworkImage(_profilePhotoUrl!)
                                    : null) as ImageProvider?,
                            child: (_selectedImage == null && (_profilePhotoUrl == null || _profilePhotoUrl!.isEmpty))
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _profileData['role'] == 'owner' ? 'Pemilik Mobil' : 
                    (_profileData['role'] == 'admin' ? 'Administrator' : 'Pelanggan'),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // ========== FORM PROFIL ==========
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email (Read Only)
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.email, size: 20, color: Colors.grey),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _profileData['email'] ?? '-',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Nama Lengkap
                          const Text(
                            'Nama Lengkap',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan nama lengkap',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.person, color: Colors.blue),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // No HP
                          const Text(
                            'Nomor HP',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Masukkan nomor HP (opsional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.phone, color: Colors.blue),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Tanggal Lahir
                          const Text(
                            'Tanggal Lahir',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => _selectBirthDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.cake, color: Colors.blue),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _selectedBirthDate != null
                                          ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
                                          : 'Pilih tanggal lahir (opsional)',
                                      style: TextStyle(
                                        color: _selectedBirthDate != null 
                                            ? Colors.black 
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down, color: Colors.blue),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Alamat
                          const Text(
                            'Alamat Rumah',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _addressController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Masukkan alamat lengkap (opsional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.home, color: Colors.blue),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Tombol Simpan
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 41, 158, 255),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'SIMPAN PERUBAHAN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}