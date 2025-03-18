import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/blocs/todo/todo_bloc.dart';
import 'package:todos_app/cubits/todo_detail/todo_detail_cubit.dart';
import 'package:todos_app/models/todo.dart';
import 'package:todos_app/repositories/todo_repository.dart';
import 'package:todos_app/ui/components/todo_list.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(context.read<TodoRepository>())..add(const LoadTodos()),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Row(
            children: [
              Icon(Icons.edit_note, size: 32),
              SizedBox(width: 6),
              Text("Todo List"),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              iconSize: 32,
              onPressed: () => Navigator.of(context).pushNamed('/profile'),
            ),
          ],
        ),
        body: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) => state.status == TodoStatus.success
                ? const TodoList()
                : const Center(child: CircularProgressIndicator())),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () => {
              showDialog(
                context: context,
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => TodoDetailCubit()),
                    BlocProvider.value(value: BlocProvider.of<TodoBloc>(context)),
                  ],
                  child: const TodoDetailModal(),
                ),
              )
            },
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}

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
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => context.read<TodoDetailCubit>().onTitleChanged(value),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
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
                      child: const Text("Add"),
                    ),
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
