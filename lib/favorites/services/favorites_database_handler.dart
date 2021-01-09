import 'package:favorite_countries/country/models/country.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FavoritesDatabaseHandler {
  Database db;

  Future open({String path}) async {
    db = await openDatabase(
      join(await getDatabasesPath(), path),
      version: 1,
      onCreate: (Database db, int version) async {
        print('Run create table........');
        await db.execute(
            '''create table favorites (code text not null, name text unique not null, region text not null )''');
      },
    );
  }

  Future<void> insertCountry(Country country) async {
    print('Insert calling....');
    await db.insert(
      'favorites',
      country.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Insert called');
  }

  Future<void> removeCountry(Country country) async {
    print('Delete calling...');
    await db.delete(
      'favorites',
      where: "name = ?",
      whereArgs: [country.countryName],
    );
    print('Delete called');
  }

  Future<List<Country>> getStoredFavorites() async {
    print('Read calling....');
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    print('Read called');

    var favoritesList = List.generate(maps.length, (i) {
      return Country(
        code: maps[i]['code'],
        countryName: maps[i]['name'],
        region: maps[i]['region'],
      );
    });
    return favoritesList;
  }

  Future close() async => db.close();
}
