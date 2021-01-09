part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class FavoritesStarted extends FavoritesEvent {
  @override
  List<Object> get props => [];
}

class FavoritesItemAdded extends FavoritesEvent {
  const FavoritesItemAdded(this.country);

  final Country country;

  @override
  List<Object> get props => [country];
}

class FavoritesItemRemoved extends FavoritesEvent {
  const FavoritesItemRemoved(this.country);

  final Country country;

  @override
  List<Object> get props => [country];
}
