import 'package:favorite_countries/favorites/bloc/favorites_bloc.dart';
import 'package:favorite_countries/favorites/favorites_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'country/bloc/country_bloc.dart';
import 'country/countries_page.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(FavoriteCountries());
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }
}

class FavoriteCountries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CountryBloc>(
          create: (context) =>
              CountryBloc(httpClient: http.Client())..add(CountryFetched()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => FavoritesBloc()..add(FavoritesStarted()),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => CountriesPage(),
          '/favorites': (context) => FavoritesPage(),
        },
      ),
    );
  }
}
