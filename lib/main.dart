import 'package:favorite_countries/bloc/country_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'models/country.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider<CountryBloc>(
        create: (context) =>
            CountryBloc(httpClient: http.Client())..add(CountryFetched()),
        child: CountriesPage(),
      ),
    );
  }
}

class CountriesPage extends StatefulWidget {
  @override
  _CountriesPageState createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  int _counter = 0;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Countries'),
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
              child: Text('Failed to fetch countries.'),
            );
          }
          if (state is CountrySuccess) {
            if (state.countries.isEmpty) {
              return Center(
                child: Text('no posts'),
              );
            }
            return ListView.builder(
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
        country.countryName,
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text('Region: ${country.region}'),
      trailing: Icon(Icons.favorite_border),
    );
  }
}
