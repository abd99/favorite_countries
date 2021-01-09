import 'package:favorite_countries/favorites/bloc/favorites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.2,
      ),
      body: Column(
        children: [
          Expanded(
            child: _FavoritesList(),
          ),
        ],
      ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return Center(
            child: const CircularProgressIndicator(
              strokeWidth: 1.5,
            ),
          );
        }
        if (state is FavoritesLoaded) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 8.0,
            ),
            itemCount: state.favorites.favoriteCountries.length,
            itemBuilder: (context, index) {
              var country = state.favorites.favoriteCountries[index];
              return ListTile(
                title: Text(
                  '${country.code} - ${country.countryName}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text('${country.region}'),
              );
            },
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}
