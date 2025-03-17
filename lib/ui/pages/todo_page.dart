import 'package:flutter/material.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Todo List"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            iconSize: 32,
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
          ),
        ],
      ),
      body: Builder(builder: (context) => const Center(child: Text('Not widget found'))),
    );
  }
}
