// ignore_for_file: lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  static final db = Db('mongodb://localhost:27017/todos_db');

  //start the database
  static Future<void> startDb() async {
    if (db.isConnected == false) {
      try {
        await db.open();
      } catch (e) {
        throw Exception();
      }
    }
  }

  //close the database
  static Future<void> closeDb() async {
    if (db.isConnected == true) {
      await db.close();
    }
  }

  //collections
  static final todosCollections = db.collection('todos');

  // we will use this method to start the database connection and use it in our routes
  static Future<Response> startConnection(
    RequestContext context,
    Future<Response> callBack,
  ) async {
    try {
      await startDb();
      return await callBack;
    } catch (e) {
      return Response.json(
        statusCode: 500,
        body: {'message': 'Internal server errors'},
      );
    }
  }
}
