import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/blocs/todo/todo_bloc.dart';
import 'package:todos_app/cubits/todo_detail/todo_detail_cubit.dart';
import 'package:todos_app/ui/components/todo_detail_modal.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) => state.todos.isEmpty
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber, size: 96),
                SizedBox(height: 6),
                Text('No todos found!', style: TextStyle(fontSize: 18)),
              ],
            ))
          : ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return Card(
                  child: ListTile(
                    title: Text(todo.title),
                    subtitle: Text(todo.description),
                    trailing: Checkbox(
                      value: todo.completed,
                      onChanged: (value) {
                        context.read<TodoBloc>().add(CheckedTodo(todo.id!, value!));
                      },
                    ),
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: BlocProvider.of<TodoBloc>(context)),
                          BlocProvider(create: (context) => TodoDetailCubit(todo: todo)),
                        ],
                        child: const TodoDetailModal(),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
