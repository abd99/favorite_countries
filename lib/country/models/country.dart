import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String countryName;
  final String region;

  const Country({this.countryName, this.region});

  @override
  List<Object> get props => [countryName, region];

  @override
  String toString() => 'Country { name: $countryName }';
}
