part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  const TodoState({
    this.status = TodoStatus.initial,
    this.todos = const [],
  });

  final TodoStatus status;
  final List<Todo> todos;

  @override
  List<Object?> get props => [status, todos];

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
    );
  }
}
