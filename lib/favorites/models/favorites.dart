import 'package:equatable/equatable.dart';
import 'package:favorite_countries/country/models/country.dart';

class Favorites extends Equatable {
  const Favorites({this.favoriteCountries = const <Country>[]});

  final List<Country> favoriteCountries;

  @override
  List<Object> get props => [favoriteCountries];
}
