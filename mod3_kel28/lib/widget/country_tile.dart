import 'package:flutter/material.dart';

import '../models/country.dart';
import '../services/country_store.dart';

class CountryTile extends StatelessWidget {
  final Country country;
  final VoidCallback onTap;
  final CountryStore store;

  const CountryTile({
    super.key,
    required this.country,
    required this.onTap,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, child) => Card(
        child: ListTile(
          leading: SizedBox(
            width: 50,
            height: 36,
            child: country.flagsPng == null
                ? const Icon(Icons.flag_outlined)
                : Image.network(
                    country.flagsPng!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.flag_outlined),
                  ),
          ),
          title: Text(country.name),
          subtitle: Text(country.region),
          onTap: onTap,
          trailing: IconButton(
            tooltip: store.isFavorite(country)
                ? 'Hapus dari favorit'
                : 'Tambah ke favorit',
            icon: Icon(
              store.isFavorite(country)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: store.isFavorite(country) ? Colors.red : null,
            ),
            onPressed: () => store.toggleFavorite(country),
          ),
        ),
      ),
    );
  }
}