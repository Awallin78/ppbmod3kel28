import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback? onHomeTap;

  const ProfilePage({super.key, this.onHomeTap});

  static const teamMembers = [
    {
      'name': 'HAFIZH MUHAMMAD AKBAR',
      'nim': '21120124130098',
      'image': 'assets/images/akbar.jpeg',
    },

  {
      'name': 'Awallin Yusuf Ikrar Putra',
      'nim': '21120123140045',
      'image': 'assets/images/awallinn.jpeg',
    },

     {
      'name': 'Henidar Sekar Mayang',
      'nim': '21120124120008',
      'image': 'assets/images/heni.jpeg',
    },

     {
      'name': 'CHATRINE DENORA SIHALOHO',
      'nim': '21120124120005',
      'image': 'assets/images/chaterine.jpeg',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Kelompok'),
        actions: [
          IconButton(
            tooltip: 'Ke Home',
            icon: const Icon(Icons.home),
            onPressed: onHomeTap,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://i.pinimg.com/1200x/b1/38/b5/b138b5213ee781543c0f83d704fb7476.jpg',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Anggota Kelompok',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (final member in teamMembers)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  radius: 32,
                  backgroundImage: member['image']!.startsWith('http')
                      ? NetworkImage(member['image']!)
                      : AssetImage(member['image']!),
                ),
                title: Text(
                  member['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('NIM: ${member['nim']}'),
              ),
            ),
        ],
      ),
    );
  }
}
