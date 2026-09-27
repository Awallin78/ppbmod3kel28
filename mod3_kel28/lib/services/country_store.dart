import 'package:flutter/foundation.dart';

import '../models/country.dart';

class CountryStore extends ChangeNotifier {
  CountryStore._();

  static final CountryStore instance = CountryStore._();

  final Set<String> _favoriteNames = <String>{};
  final List<Country> _history = <Country>[];
  List<Country> _catalog = const [];

  List<Country> get history => List.unmodifiable(_history);

  void updateCatalog(List<Country> countries) {
    _catalog = List.unmodifiable(countries);
    notifyListeners();
  }

  bool isFavorite(Country country) => _favoriteNames.contains(country.name);

  List<Country> get favorites => _catalog
      .where((country) => _favoriteNames.contains(country.name))
      .toList();

  void toggleFavorite(Country country) {
    if (!_favoriteNames.add(country.name)) {
      _favoriteNames.remove(country.name);
    }
    notifyListeners();
  }

  void addToHistory(Country country) {
    _history.removeWhere((item) => item.name == country.name);
    _history.insert(0, country);
    notifyListeners();
  }

  void removeFromHistory(Country country) {
    _history.removeWhere((item) => item.name == country.name);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}