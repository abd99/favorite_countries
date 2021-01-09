import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String code;
  final String countryName;
  final String region;

  const Country({this.code, this.countryName, this.region});

  @override
  List<Object> get props => [code, countryName, region];

  @override
  String toString() => 'Country { name: $countryName }';

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': countryName,
      'region': region,
    };
  }
}
