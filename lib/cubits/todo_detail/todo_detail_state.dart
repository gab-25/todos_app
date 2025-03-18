part of 'todo_detail_cubit.dart';

class TodoDetailState extends Equatable {
  const TodoDetailState({
    this.id,
    this.title = '',
    this.description = '',
    this.completed = false,
  });

  final int? id;
  final String title;
  final String description;
  final bool completed;

  bool get isValid => title.isNotEmpty && description.isNotEmpty;

  @override
  List<Object?> get props => [id, title, description, completed];

  TodoDetailState copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
  }) {
    return TodoDetailState(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
