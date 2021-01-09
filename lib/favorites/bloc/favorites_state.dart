part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesLoading extends FavoritesState {
  @override
  List<Object> get props => [];
}

class FavoritesLoaded extends FavoritesState {
  final Favorites favorites;

  const FavoritesLoaded({@required this.favorites});

  @override
  List<Object> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  @override
  List<Object> get props => [];
}
