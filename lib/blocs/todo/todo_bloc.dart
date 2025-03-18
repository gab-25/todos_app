import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/models/todo.dart';
import 'package:todos_app/repositories/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(this._todoRepository) : super(const TodoState()) {
    on<LoadTodos>(_onLoadTodos);
    on<SaveTodo>(_onSaveTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<CheckedTodo>(_onCheckedTodo);
  }

  final TodoRepository _todoRepository;

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      final todos = await _todoRepository.getTodos();
      emit(state.copyWith(status: TodoStatus.success, todos: todos));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }

  Future<void> _onSaveTodo(SaveTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      await _todoRepository.saveTodo(event.todo);
      final todos = await _todoRepository.getTodos();
      emit(state.copyWith(status: TodoStatus.success, todos: todos));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      await _todoRepository.deleteTodo(event.todoId);
      final todos = await _todoRepository.getTodos();
      emit(state.copyWith(status: TodoStatus.success, todos: todos));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }

  Future<void> _onCheckedTodo(CheckedTodo event, Emitter<TodoState> emit) async {
    try {
      emit(state.copyWith(status: TodoStatus.loading));
      final todo = state.todos.firstWhere((todo) => todo.id == event.todoId);
      await _todoRepository.saveTodo(Todo(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        completed: event.completed,
      ));
      final todos = await _todoRepository.getTodos();
      emit(state.copyWith(status: TodoStatus.success, todos: todos));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }
}
