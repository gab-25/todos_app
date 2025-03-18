import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_detail_state.dart';

class TodoDetailCubit extends Cubit<TodoDetailState> {
  TodoDetailCubit() : super(const TodoDetailState());

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
