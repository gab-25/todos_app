part of 'todo_bloc.dart';

sealed class TodoEvent {
  const TodoEvent();
}

final class LoadTodos extends TodoEvent {
  const LoadTodos();
}

final class SaveTodo extends TodoEvent {
  const SaveTodo(this.todo);

  final Todo todo;
}

final class DeleteTodo extends TodoEvent {
  const DeleteTodo(this.todoId);

  final int todoId;
}

final class CheckedTodo extends TodoEvent {
  const CheckedTodo(this.todoId, this.completed);

  final int todoId;
  final bool completed;
}
