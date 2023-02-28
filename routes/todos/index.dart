// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:todos_data_source/todos_data_source.dart';

import '../../services/db_service.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return await DatabaseService.startConnection(context, _get(context));
    case HttpMethod.post:
      return await DatabaseService.startConnection(context, _post(context));
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    final params = context.request.uri.queryParameters;

    if (params.containsKey('id')) {
      final id = params['id'];
      final doc =
          await DatabaseService.todosCollections.findOne(where.eq('id', id));
      if (doc != null && doc.isNotEmpty) {
        final todos = Todo.fromJson(doc);
        return Response.json(
          body: {'data': todos},
        );
      } else {
        return Response.json(
          statusCode: 404,
          body: {'message': 'Not Found'},
        );
      }
    } else {
      final docs = await DatabaseService.todosCollections.find().toList();
      final todos = docs.map(Todo.fromJson).toList();

      return Response.json(
        body: {
          'status': 200,
          'data': todos,
        },
      );
    }
  } else {
    return Response.json(
      statusCode: 404,
      body: {'message': 'Method not allowed'},
    );
  }
}

Future<Response> _post(RequestContext context) async {
  final uuid = const Uuid().v4();

  if (context.request.method == HttpMethod.post) {
    final contentType = context.request.headers['Content-Type'];
    if (contentType == 'application/json') {
      final body = await context.request.json();

      if (body != null &&
          body['title'] != null &&
          body['description'] != null) {
        final todos = Todo.fromJson({
          'id': uuid,
          'title': body['title'],
          'description': body['description'],
          'isCompleted': body['isCompleted'],
        });

        await DatabaseService.todosCollections.insert(todos.toJson());
        return Response.json(
          statusCode: 201,
          body: {
            'message': 'Order created successfully with order id ${todos.id}'
          },
        );
      } else {
        return Response.json(
          statusCode: 404,
          body: {'message': 'All fields are required'},
        );
      }
    }
    return Response.json(
      statusCode: 404,
      body: {'message': 'Content-Type must be application/json'},
    );
  }
  return Response.json(
    statusCode: 404,
    body: {'message': 'Method not allowed'},
  );
}
