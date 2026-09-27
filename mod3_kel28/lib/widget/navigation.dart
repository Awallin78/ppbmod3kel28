import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/profile.dart';
import '../screens/country_collection.dart';
import '../services/country_store.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  final _store = CountryStore.instance;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomePage(),
          AnimatedBuilder(
            animation: _store,
            builder: (context, _) => CountryCollectionPage(
              title: 'Favorit',
              countries: _store.favorites,
            ),
          ),
          AnimatedBuilder(
            animation: _store,
            builder: (context, _) => CountryCollectionPage(
              title: 'Riwayat',
              countries: _store.history,
              allowDelete: true,
              onClear: _store.clearHistory,
            ),
          ),
          ProfilePage(onHomeTap: () => _onTabTapped(0)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
