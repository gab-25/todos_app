import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/blocs/todo/todo_bloc.dart';
import 'package:todos_app/cubits/todo_detail/todo_detail_cubit.dart';
import 'package:todos_app/repositories/todo_repository.dart';
import 'package:todos_app/ui/components/todo_detail_modal.dart';
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
                    BlocProvider.value(value: BlocProvider.of<TodoBloc>(context)),
                    BlocProvider(create: (_) => TodoDetailCubit()),
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
