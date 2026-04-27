import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 140, 202, 253),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(255, 41, 158, 255),
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Card Profile
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Username
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: const Text('Username'),
                      subtitle: const Text('your_username'),
                    ),

                    const Divider(),

                    // Password
                    ListTile(
                      leading: const Icon(Icons.lock, color: Colors.blue),
                      title: const Text('Password'),
                      subtitle: const Text('••••••••'),
                    ),

                    const Divider(),

                    // Gmail
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.blue),
                      title: const Text('Gmail'),
                      subtitle: const Text('your_email@gmail.com'),
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