import 'package:energy_monitor_app/blocs/app/app_bloc.dart';
import 'package:energy_monitor_app/cubits/profile/profile_cubit.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: BlocProvider(
            create: (context) => ProfileCubit(context.read<AuthRepository>()),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  child: user.photoURL != null
                      ? Image(image: AssetImage(user.photoURL!))
                      : const Icon(Icons.person, size: 80),
                ),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: Text(user.displayName ?? 'No name'),
                  ),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const EditProfileDialog(),
                    ),
                    icon: const Icon(Icons.edit),
                  ),
                ]),
                const SizedBox(height: 10),
                Text(user.email!),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Change Password'),
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    context.read<AppBloc>().add(const AppLogoutPressed()),
                  },
                  child: const Text('Logout'),
                ),
                const SizedBox(height: 40),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.inverseSurface),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(children: [
                      const Text(
                        'Shelly Cloud',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FilledButton(
                        onPressed: () {},
                        child: const Text('Connect'),
                      ),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditProfileDialog extends StatelessWidget {
  const EditProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Edit profile'),
      children: <Widget>[
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) => Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    initialValue: state.name,
                    onChanged: (value) => context.read<ProfileCubit>().onNameChanged(value),
                  ),
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: state.status != ProfileStatus.loading ? () => Navigator.of(context).pop() : null,
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: state.status != ProfileStatus.loading
                        ? () async {
                            await context.read<ProfileCubit>().onSave();
                            context.read<AppBloc>().add(const AppUserUpdated());
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
