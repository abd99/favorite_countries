part of 'country_bloc.dart';

abstract class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object> get props => [];
}

class CountryInitial extends CountryState {}

class CountryFailure extends CountryState {}

class CountrySuccess extends CountryState {
  final List<Country> countries;
  final bool hasReachedMax;

  const CountrySuccess({
    this.countries,
    this.hasReachedMax,
  });

  CountrySuccess copyWith({
    List<Country> posts,
    bool hasReachedMax,
  }) {
    return CountrySuccess(
      countries: posts ?? this.countries,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [countries, hasReachedMax];

  @override
  String toString() =>
      'CountrySuccess { countries: ${countries.length}, hasReachedMax: $hasReachedMax }';
}
