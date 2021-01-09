import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:favorite_countries/country/models/country.dart';
import 'package:favorite_countries/favorites/models/favorites.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesLoading());

  @override
  Stream<FavoritesState> mapEventToState(
    FavoritesEvent event,
  ) async* {
    if (event is FavoritesStarted) {
      yield* _mapFavoritesStartedToState();
    } else if (event is FavoritesItemAdded) {
      yield* _mapFavoritesItemAddedToState(event, state);
    } else if (event is FavoritesItemRemoved) {
      yield* _mapFavoritesItemRemovedFromState(event, state);
    }
  }

  Stream<FavoritesState> _mapFavoritesStartedToState() async* {
    yield FavoritesLoading();
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      yield const FavoritesLoaded();
    } catch (_) {
      yield FavoritesError();
    }
  }

  Stream<FavoritesState> _mapFavoritesItemAddedToState(
    FavoritesItemAdded event,
    FavoritesState state,
  ) async* {
    if (state is FavoritesLoaded) {
      try {
        yield FavoritesLoaded(
          favorites: Favorites(
              favoriteCountries: List.from(state.favorites.favoriteCountries)
                ..add(event.country)),
        );
      } on Exception {
        yield FavoritesError();
      }
    }
  }

  Stream<FavoritesState> _mapFavoritesItemRemovedFromState(
    FavoritesItemRemoved event,
    FavoritesState state,
  ) async* {
    if (state is FavoritesLoaded) {
      try {
        yield FavoritesLoaded(
          favorites: Favorites(
              favoriteCountries: List.from(state.favorites.favoriteCountries)
                ..remove(event.country)),
        );
      } on Exception {
        yield FavoritesError();
      }
    }
  }
}
