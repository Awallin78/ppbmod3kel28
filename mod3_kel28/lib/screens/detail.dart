import 'package:flutter/material.dart';

import '../models/country.dart';

class DetailPage extends StatelessWidget {
  final Country country;

  const DetailPage({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (country.flagsPng != null)
              Center(
                child: Image.network(
                  country.flagsPng!,
                  width: 200,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.flag_outlined,
                    size: 120,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              'Name: ${country.name}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Capital: ${country.capital ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Region: ${country.region}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Population: ${country.population}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Languages: ${country.languages.isEmpty ? 'N/A' : country.languages.join(', ')}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Currencies: ${country.currencies.isEmpty ? 'N/A' : country.currencies.join(', ')}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
