import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'detail.dart';
import '../models/country.dart';
import '../services/country_store.dart';
import '../widget/country_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countries;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _sortByContinent = false;

  CountryStore get store => CountryStore.instance;

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://www.apicountries.com/countries');
    final client = HttpClient();
    final request = await client.getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(responseBody);

      if (decoded is List) {
        final result = decoded
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .map(Country.fromJson)
            .toList();
        store.updateCatalog(result);
        return result;
      }

      throw const FormatException('Unexpected response format from country API');
    }

    throw Exception('Failed to load countries: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          IconButton(
            tooltip: _sortByContinent
                ? 'Urutkan berdasarkan urutan awal'
                : 'Urutkan berdasarkan benua',
            icon: Icon(_sortByContinent ? Icons.sort_by_alpha : Icons.public),
            onPressed: () => setState(() => _sortByContinent = !_sortByContinent),
          ),
        ],
      ),
      body: FutureBuilder<List<Country>>(
        future: countries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No countries found'));
          }

          final list = snapshot.data!
              .where((country) => country.name.toLowerCase().contains(_searchQuery))
              .toList();
          if (_sortByContinent) {
            list.sort((a, b) {
              final regionCompare = a.region.compareTo(b.region);
              return regionCompare == 0 ? a.name.compareTo(b.name) : regionCompare;
            });
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Cari negara',
                    hintText: 'Masukkan nama negara',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.clear),
                            onPressed: _searchController.clear,
                          ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text('Negara tidak ditemukan'))
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final country = list[index];
                          return CountryTile(
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
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
