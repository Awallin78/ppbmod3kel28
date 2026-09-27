import 'package:flutter/material.dart';

import '../models/country.dart';
import '../services/country_store.dart';
import '../widget/country_tile.dart';
import 'detail.dart';

class CountryCollectionPage extends StatelessWidget {
  final String title;
  final List<Country> countries;
  final bool allowDelete;
  final VoidCallback? onClear;

  const CountryCollectionPage({
    super.key,
    required this.title,
    required this.countries,
    this.allowDelete = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final store = CountryStore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (allowDelete && countries.isNotEmpty)
            IconButton(
              tooltip: 'Hapus semua riwayat',
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _confirmClear(context),
            ),
        ],
      ),
      body: countries.isEmpty
          ? Center(child: Text('Belum ada $title'))
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                return Dismissible(
                  key: ValueKey('$title-${country.name}'),
                  direction: allowDelete
                      ? DismissDirection.endToStart
                      : DismissDirection.none,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: allowDelete
                      ? (_) => _confirmDelete(context, country)
                      : null,
                  child: CountryTile(
                    country: country,
                    store: store,
                    onTap: () {
                      store.addToHistory(country);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(country: country),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, Country country) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus riwayat?'),
        content: Text('Hapus ${country.name} dari riwayat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              CountryStore.instance.removeFromHistory(country);
              Navigator.pop(context, true);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus semua riwayat?'),
        content: const Text('Semua riwayat akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus semua'),
          ),
        ],
      ),
    );
    if (shouldClear == true) onClear?.call();
  }
}