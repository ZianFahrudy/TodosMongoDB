import 'package:todos_data_source/todos_data_source.dart';

/// An interface for a todos data source.
/// A todos data source supports basic C.R.U.D operations.
/// * C - Create
/// * R - Read
/// * U - Update
/// * D - Delete

abstract class TodoDataSource {
  /// create
  Future<Todo> create(Todo todo);

  /// get list
  Future<List<Todo>> readAll();

  /// get
  Future<Todo?> read(String id);

  /// update
  Future<Todo> update(String id, Todo todo);

  /// delete
  Future<void> delete(String id);
}
