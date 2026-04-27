import 'package:flutter/material.dart';
import 'car_detail_page.dart'; // Import halaman detail mobil
import 'owner_page.dart'; // Import halaman pemilik
import 'profile/profil.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? _buildHomeContent()
          : _selectedIndex == 1
              ? _buildRentalContent()
              : _selectedIndex == 2
                  ? const OwnerPage() // LANGSUNG KE HALAMAN PEMILIK
                  : _selectedIndex == 3
                      ? _buildMapsContent()
                      : _buildSettingContent(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Home Content dengan BACKGROUND FOTO
  Widget _buildHomeContent() {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND FOTO
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // OVERLAY GELAP (opsional, agar teks lebih terbaca)
          Container(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.3),
          ),
          // KONTEN DI ATAS BACKGROUND
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AppBar manual
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            child: const Icon(Icons.person, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hallo, Admin!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              'Mau kemana hari ini?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.notifications_none, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari mobil, merek, atau lokasi...',
                          prefixIcon: Icon(Icons.search, color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Menu Navigation (Rental, Pemilik, Maps, Setting)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMenuButton(Icons.car_rental, 'Rental', 1),
                        _buildMenuButton(Icons.person_outline, 'Pemilik', 2),
                        _buildMenuButton(Icons.map_outlined, 'Maps', 3),
                        _buildMenuButton(Icons.settings_outlined, 'Setting', 4),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Title "Mobil Populer"
                    const Text(
                      'Mobil Populer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Vertical Car List - DENGAN NAVIGASI KE HALAMAN DETAIL
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: carList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigasi ke halaman detail mobil (file terpisah)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarDetailPage(car: carList[index]),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCarCard(carList[index]),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black54, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Car Card
  Widget _buildCarCard(Map<String, dynamic> car) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: _buildCarImage(car['image']),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${car['price']} / hari',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.local_gas_station, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      car['fuel'] ?? '12L',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.people, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      '${car['seats']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      car['location'] ?? 'Pekandangan',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
            ),
          );
        },
      );
    } else {
      return Image.network(
        imagePath,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
            ),
          );
        },
      );
    }
  }

  // Rental Page
  Widget _buildRentalContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Mobil'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.car_rental, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Halaman Rental Mobil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur sedang dalam pengembangan',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Maps Page
  Widget _buildMapsContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Lokasi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Halaman Peta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur sedang dalam pengembangan',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Setting Page
  Widget _buildSettingContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Halaman Pengaturan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur sedang dalam pengembangan',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental_outlined),
            activeIcon: Icon(Icons.car_rental),
            label: 'Rental',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Pemilik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}

// Data Mobil
final List<Map<String, dynamic>> carList = [
  {
    'name': 'Honda HR-V',
    'image': 'assets/images/mobil.png',
    'price': '500.000',
    'fuel': '12L',
    'seats': '6',
    'location': 'Pekandangan',
  },
  {
    'name': 'Avanza 2024',
    'image': 'assets/images/mobil.png',
    'price': '500.000',
    'fuel': '12L',
    'seats': '5',
    'location': 'Pekandangan',
  },
  {
    'name': 'Ferrari 24013',
    'image': 'assets/images/mobil.png',
    'price': '500.000',
    'fuel': '12L',
    'seats': '2',
    'location': 'Pekandangan',
  },
  {
    'name': 'Yaris 2025',
    'image': 'assets/images/mobil.png',
    'price': '500.000',
    'fuel': '12L',
    'seats': '6',
    'location': 'Pekandangan',
  },
];