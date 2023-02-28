// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:todos_data_source/todos_data_source.dart';

import '../../services/db_service.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  // final dataSource = context.read<TodoDataSource>();
  // final todo = await dataSource.read(id);

  // if (todo == null) {
  //   return Response(statusCode: HttpStatus.notFound, body: 'Not found');
  // }

  switch (context.request.method) {
    case HttpMethod.get:
      // return _get(context, todo);
      return await DatabaseService.startConnection(
        context,
        _get(context, id),
      );

    case HttpMethod.put:
      // return _put(context, id, todo);
      return await DatabaseService.startConnection(
        context,
        _put(context, id),
      );
    case HttpMethod.delete:
      // return _delete(context, id);
      return await DatabaseService.startConnection(
        context,
        _delete(context, id),
      );
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, String id) async {
  // return Response.json(body: todo);

  if (context.request.method == HttpMethod.get) {
    final doc =
        await DatabaseService.todosCollections.findOne(where.eq('id', id));
    if (doc != null && doc.isNotEmpty) {
      final todos = Todo.fromJson(doc);
      return Response.json(
        body: {'data': todos},
      );
    } else {
      return Response.json(
        statusCode: 400,
        body: {'message': 'ID not Found'},
      );
    }
  } else {
    return Response.json(
      statusCode: 404,
      body: {'message': 'Method not allowed'},
    );
  }
}

Future<Response> _put(RequestContext context, String id) async {
  if (context.request.method == HttpMethod.put) {
    final body = await context.request.json();

    if (body != null && body['title'] != null && body['description'] != null) {
      final doc =
          await DatabaseService.todosCollections.findOne(where.eq('id', id));
      final todos = Todo.fromJson({
        'id': id,
        'title': body['title'],
        'description': body['description'],
        'isCompleted': body['isCompleted'],
      });

      await DatabaseService.todosCollections.update(doc, todos.toJson());

      return Response.json(body: {'message': 'Success'});
    } else {
      return Response.json(
        statusCode: 404,
        body: {'message': 'All fields are required'},
      );
    }
  }
  return Response.json(
    statusCode: 404,
    body: {'message': 'Method not allowed'},
  );
}

Future<Response> _delete(RequestContext context, String id) async {
  if (context.request.method == HttpMethod.delete) {
    await DatabaseService.todosCollections.deleteOne({'id': id});
    return Response.json(
      statusCode: 404,
      body: {'message': 'Success'},
    );
  } else {
    return Response.json(
      statusCode: 404,
      body: {'message': 'Method not allowed'},
    );
  }
}
