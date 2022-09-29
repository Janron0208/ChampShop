import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/cart_model.dart';

class SQLiteHelper {
  final String nameDatabase = 'champShop.db';
  final String tableDatabase = 'orderTABLE';
  int version = 1;

  final String idColumn = 'id';
  final String idShopColumn = 'idShop';
  final String nameShop = 'nameShop';
  final String idProduct = 'idProduct';
  final String nameProduct = 'nameProduct';
  final String price = 'price';
  final String amount = 'amount';
  final String sum = 'sum';
  final String distance = 'distance';
  final String transport = 'transport';

  SQLiteHelper() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), nameDatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableDatabase ($idColumn INTEGER PRIMARY KEY, $idShopColumn TEXT, $nameShop TEXT, $idProduct TEXT, $nameProduct TEXT, $price TEXT, $amount TEXT, $sum TEXT, $distance TEXT, $transport TEXT)'),
        version: version);
  }

  Future<Database> connectedDatabase() async {
    return openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertDataToSQLite(CartModel cartModel) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        tableDatabase,
        cartModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('e insertData ==>> ${e.toString()}');
    }
  }
}
