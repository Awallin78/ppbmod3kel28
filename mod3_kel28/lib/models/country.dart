class Country {
  final String name;
  final String region;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<String> languages;
  final List<String> currencies;

  const Country({
    required this.name,
    required this.region,
    required this.population,
    this.capital,
    this.flagsPng,
    this.languages = const [],
    this.currencies = const [],
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final rawName = json['name'];
    final name = rawName is Map
        ? (rawName['common'] ?? rawName['official'] ?? 'N/A').toString()
        : rawName?.toString() ?? 'N/A';
    final flagsJson = json['flags'];
    final rawFlags = json['flag'];
    final countryCode = json['cca2']?.toString().toLowerCase();
    final rawLanguages = json['languages'];
    final rawCurrencies = json['currencies'];

    final languages = <String>[];
    if (rawLanguages is Map) {
      languages.addAll(rawLanguages.values.map((value) => value.toString()));
    } else if (rawLanguages is List) {
      languages.addAll(rawLanguages.map((value) => value.toString()));
    }

    final currencies = <String>[];
    if (rawCurrencies is Map) {
      currencies.addAll(rawCurrencies.values.map((value) {
        if (value is Map) {
          return (value['name'] ?? 'N/A').toString();
        }
        return value.toString();
      }));
    } else if (rawCurrencies is List) {
      currencies.addAll(rawCurrencies.map((value) => value.toString()));
    }

    final rawCapital = json['capital'];
    final capital = rawCapital is List && rawCapital.isNotEmpty
        ? rawCapital.first.toString()
        : rawCapital?.toString();

    return Country(
      name: name,
      region: json['region']?.toString() ?? 'N/A',
      population: (json['population'] as num?)?.toInt() ?? 0,
      capital: capital,
      flagsPng: countryCode != null && countryCode.length == 2
          ? 'https://flagcdn.com/w320/$countryCode.png'
          : flagsJson is Map
              ? flagsJson['png']?.toString()
              : rawFlags?.toString(),
      languages: languages,
      currencies: currencies,
    );
  }
}