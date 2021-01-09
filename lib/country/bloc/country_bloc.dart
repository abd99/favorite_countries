import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../country/models/country.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final http.Client httpClient;

  CountryBloc({@required this.httpClient}) : super(CountryInitial());

  @override
  Stream<CountryState> mapEventToState(
    CountryEvent event,
  ) async* {
    final currentState = state;
    if (event is CountryFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is CountryInitial) {
          final countries = await _fetchCountries(0, 20);
          yield CountrySuccess(countries: countries, hasReachedMax: false);
          return;
        }
        if (currentState is CountrySuccess) {
          final countries =
              await _fetchCountries(currentState.countries.length, 20);
          yield countries.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : CountrySuccess(
                  countries: currentState.countries + countries,
                  hasReachedMax: false,
                );
        }
      } on SocketException catch (e) {
        print('Socket exception: ${e.message}');

        if (e.message == "Failed host lookup: 'api.first.org'") {
          yield CountryFailure(errorMessage: 'Please check your network connectivity.');
        } else
          yield CountryFailure();
      } catch (e) {
        print('CountryFailure: ${e.toString()}');
        yield CountryFailure();
      }
    }
  }

  bool _hasReachedMax(CountryState state) =>
      state is CountrySuccess && state.hasReachedMax;

  Future<List<Country>> _fetchCountries(int startIndex, int limit) async {
    var url =
        'https://api.first.org/data/v1/countries?offset=$startIndex&limit=$limit';
    print(url);
    final response = await httpClient.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      try {
        Map<String, dynamic> data = responseData['data'];
        return data.entries
            .map((entry) => Country(
                  countryName: entry.value['country'],
                  region: entry.value['region'],
                ))
            .toList();
      } on TypeError catch (e) {
        print('TypeError: $e');
        return [];
      } catch (e) {
        print('Error occurred: $e');
      }
    } else {
      print(json.decode(response.body));
      throw Exception('Error fetching countries');
    }
    return [];
  }
}
