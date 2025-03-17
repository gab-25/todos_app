import 'package:todos_app/blocs/app/app_bloc.dart';
import 'package:todos_app/cubits/profile/profile_cubit.dart';
import 'package:todos_app/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Profile'),
      ),
      body: BlocProvider(
        create: (context) => ProfileCubit(context.read<AuthRepository>()),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) => Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    child: state.avatar != null
                        ? Image(image: AssetImage(state.avatar!))
                        : const Icon(Icons.person, size: 80),
                  ),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: Text(state.name.isNotEmpty ? state.name : 'No Name'),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<ProfileCubit>(context),
                          child: const EditProfileDialog(),
                        ),
                      ),
                      icon: const Icon(Icons.edit),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Text(state.email),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<ProfileCubit>(context),
                        child: const ChangePasswordDialog(),
                      ),
                    ),
                    child: const Text('Change Password'),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () {
                      context.read<AppBloc>().add(const AppLogoutPressed());
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
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
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
        }
      },
      child: SimpleDialog(
        title: const Text('Edit profile', textAlign: TextAlign.center),
        children: <Widget>[
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Column(children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Avatar',
                      ),
                      initialValue: state.avatar,
                      // onChanged: (value) => context.read<ProfileCubit>().onEditAvatarChanged(value),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      initialValue: state.name,
                      onChanged: (value) => context.read<ProfileCubit>().onEditNameChanged(value),
                    ),
                  ]),
                  const SizedBox(height: 10),
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
                                await context.read<ProfileCubit>().onSaveEditProfile();
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
          ),
        ],
      ),
    );
  }
}

class ChangePasswordDialog extends StatelessWidget {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed')));
          context.read<AppBloc>().add(const AppLogoutPressed());
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        if (state.status == ProfileStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password change failed')));
        }
      },
      child: SimpleDialog(
        title: const Text('Change password', textAlign: TextAlign.center),
        children: <Widget>[
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Column(children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'New password',
                      ),
                      obscureText: true,
                      onChanged: (value) => context.read<ProfileCubit>().onNewPasswordChanged(value),
                    ),
                  ]),
                  const SizedBox(height: 10),
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
                                await context.read<ProfileCubit>().onSaveChangePassword();
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
          ),
        ],
      ),
    );
  }
}
