import 'package:energy_monitor_app/blocs/app/app_bloc.dart';
import 'package:energy_monitor_app/blocs/app/app_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User user = context.select((AppBloc bloc) => bloc.state.user!);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                child: Image(image: AssetImage(user.photoURL!)),
              ),
              FilledButton(
                onPressed: () =>
                    context.read<AppBloc>().add(const AppLogoutPressed()),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
