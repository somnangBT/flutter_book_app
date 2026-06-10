import 'package:mad/data/db_manager.dart';
import 'package:mad/model/orders.dart';
import 'package:sqflite/sqflite.dart';

class OrderService {
  static const String ordersTable = "orders";
  static final OrderService instance = OrderService._init();

  OrderService._init();

  Future<Database> get _db async {
    return await DbManager.instance.database;
  }

  // INSERT ORDER
  Future<void> insertOrder(Orders order) async {
    final db = await _db;

    await db.insert(
      ordersTable,
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ ORDERS
  Future<List<Orders>> readOrders() async {
    final db = await _db;

    final List<Map<String, dynamic>> maps = await db.query(ordersTable);

    return maps.map((e) => Orders.fromMap(e)).toList();
  }

  // DELETE ORDER
  Future<void> deleteOrder(int id) async {
    final db = await _db;

    await db.delete(
      ordersTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // CLEAR ALL CART
  Future<void> clearOrders() async {
    final db = await _db;

    await db.delete(ordersTable);
  }
}