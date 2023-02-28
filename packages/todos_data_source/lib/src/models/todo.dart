// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'todo.g.dart';

@immutable
@JsonSerializable()
class Todo extends Equatable {
  const Todo({
    required this.title,
    this.id,
    this.description = '',
    this.isCompleted = false,
  });
  final String? id;
  final String title;
  final String description;
  final bool isCompleted;

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [id!, title, description, isCompleted];

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
