import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/blocs/todo/todo_bloc.dart';
import 'package:todos_app/cubits/todo_detail/todo_detail_cubit.dart';
import 'package:todos_app/models/todo.dart';

class TodoDetailModal extends StatelessWidget {
  const TodoDetailModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoDetailCubit, TodoDetailState>(
      builder: (context, state) => SimpleDialog(
        title: state.id == null ? const Text("Add Todo") : const Text("Edit Todo"),
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: state.title,
                  onChanged: (value) => context.read<TodoDetailCubit>().onTitleChanged(value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  initialValue: state.description,
                  onChanged: (value) => context.read<TodoDetailCubit>().onDescriptionChanged(value),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: state.completed,
                      onChanged: (value) => context.read<TodoDetailCubit>().onCompletedChanged(value!),
                    ),
                    const Text("Completed"),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: state.isValid
                          ? () {
                              context.read<TodoBloc>().add(
                                    SaveTodo(
                                      Todo(
                                        id: state.id,
                                        title: state.title,
                                        description: state.description,
                                        completed: state.completed,
                                      ),
                                    ),
                                  );
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: state.id == null ? const Text("Add") : const Text("Save"),
                    ),
                    state.id != null
                        ? TextButton(
                            onPressed: () {
                              context.read<TodoBloc>().add(DeleteTodo(state.id!));
                              Navigator.of(context).pop();
                            },
                            child: const Text("Delete"),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
