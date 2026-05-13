
import 'package:mad/data/db_manager.dart';
import 'package:mad/model/orders.dart';
import 'package:sqflite/sqflite.dart';

class OrderService {
  static final ordersTable = "orders";
  static final OrderService instance = OrderService._init();

  OrderService._init();

  Future<void> insertOrder(Orders order) async {
    final db = await DbManager.instance.database;
    await db.insert(ordersTable, order.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Orders>> readOrders() async {
    final db = await DbManager.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(ordersTable);
    return List.generate(maps.length, (i) => Orders.fromMap(maps[i]));
  }

  Future<void> removeCart(int id) async {
    final db = await DbManager.instance.database;
    await db.delete(ordersTable, where: "id=?", whereArgs: [id]);
  }

}