import 'package:favorite_countries/favorites/bloc/favorites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/country_bloc.dart';
import 'models/country.dart';

class CountriesPage extends StatefulWidget {
  @override
  _CountriesPageState createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  CountryBloc _countryBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _countryBloc = BlocProvider.of<CountryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Countries',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.2,
        actions: [
          TextButton(
            child: const Text(
              'Favorites',
            ),
            onPressed: () => Navigator.of(context).pushNamed('/favorites'),
          ),
        ],
      ),
      body: BlocBuilder<CountryBloc, CountryState>(
        builder: (context, state) {
          if (state is CountryInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CountryFailure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to fetch countries.',
                style: theme.textTheme.bodyText1,
              ),
            );
          }
          if (state is CountrySuccess) {
            if (state.countries.isEmpty) {
              return Center(
                child: Text('no posts'),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return index >= state.countries.length
                    ? BottomLoader()
                    : CountryWidget(country: state.countries[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.countries.length
                  : state.countries.length + 1,
              controller: _scrollController,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _countryBloc.add(CountryFetched());
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class CountryWidget extends StatelessWidget {
  final Country country;

  const CountryWidget({Key key, @required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${country.code} - ${country.countryName}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text('${country.region}'),
      trailing: FavoritesIconButton(
        country: country,
      ),
    );
  }
}

class FavoritesIconButton extends StatelessWidget {
  const FavoritesIconButton({
    Key key,
    @required this.country,
  }) : super(key: key);

  final Country country;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return CircularProgressIndicator(
            strokeWidth: 1.5,
          );
        }
        if (state is FavoritesLoaded) {
          var containsCountry =
              state.favorites.favoriteCountries.contains(country);
          return InkWell(
            child: Icon(
              containsCountry ? Icons.favorite : Icons.favorite_border,
            ),
            onTap: () {
              !containsCountry
                  ? context
                      .read<FavoritesBloc>()
                      .add(FavoritesItemAdded(country))
                  : context
                      .read<FavoritesBloc>()
                      .add(FavoritesItemRemoved(country));
            },
          );
        }
        print('State: $state');
        return CircularProgressIndicator(
          strokeWidth: 1.5,
        );
      },
    );
  }
}
