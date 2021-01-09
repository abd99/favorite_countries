import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:favorite_countries/country/models/country.dart';
import 'package:favorite_countries/favorites/models/favorites.dart';
import 'package:favorite_countries/favorites/services/favorites_database_handler.dart';

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
      var favoritesTable = FavoritesDatabaseHandler();
      await favoritesTable.open(path: 'favorites.db');
      var favoritesList = await favoritesTable.getStoredFavorites();
      yield FavoritesLoaded(
        favorites: Favorites(
          favoriteCountries: favoritesList,
        ),
      );
    } catch (e) {
      yield FavoritesError();
    }
  }

  Stream<FavoritesState> _mapFavoritesItemAddedToState(
    FavoritesItemAdded event,
    FavoritesState state,
  ) async* {
    if (state is FavoritesLoaded) {
      try {
        var favoritesTable = FavoritesDatabaseHandler();
        await favoritesTable.open(path: 'favorites.db');
        favoritesTable.insertCountry(event.country);
        var favorites = await favoritesTable.getStoredFavorites();
        yield FavoritesLoaded(
          favorites: Favorites(favoriteCountries: favorites),
        );
      } on Exception catch (e) {
        print('FavoritesException: $e');
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
        var favoritesTable = FavoritesDatabaseHandler();
        await favoritesTable.open(path: 'favorites.db');
        favoritesTable.removeCountry(event.country);
        var favorites = await favoritesTable.getStoredFavorites();
        yield FavoritesLoaded(
          favorites: Favorites(favoriteCountries: favorites),
        );
      } on Exception {
        yield FavoritesError();
      }
    }
  }
}
