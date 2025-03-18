import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/models/todo.dart';

part 'todo_detail_state.dart';

class TodoDetailCubit extends Cubit<TodoDetailState> {
  TodoDetailCubit({Todo? todo}) : super(const TodoDetailState()) {
    if (todo != null) {
      emit(state.copyWith(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        completed: todo.completed,
      ));
    }
  }

  onTitleChanged(String title) {
    emit(state.copyWith(title: title));
  }

  onDescriptionChanged(String description) {
    emit(state.copyWith(description: description));
  }

  onCompletedChanged(bool completed) {
    emit(state.copyWith(completed: completed));
  }
}
