import 'package:energy_monitor_app/blocs/app/app_bloc.dart';
import 'package:energy_monitor_app/cubits/profile/profile_cubit.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/repositories/db_repository.dart';
import 'package:energy_monitor_app/services/shelly_cloud_service.dart';
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
        create: (context) => ProfileCubit(context.read<AuthRepository>(), context.read<DbRepository>(), context.read<ShellyCloudService>()),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) => Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    child: state.avatar.isNotEmpty
                        ? Image(image: AssetImage(state.avatar))
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
                    onPressed: () => {
                      context.read<AppBloc>().add(const AppLogoutPressed()),
                      Navigator.of(context).pop(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Shelly Cloud',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            state.shellyCloudConnected ? const Icon(Icons.check_circle) : const Icon(Icons.cancel),
                          ],
                        ),
                        const SizedBox(height: 10),
                        FilledButton(
                          onPressed: state.shellyCloudConnected == false
                              ? () => showDialog(
                                    context: context,
                                    builder: (_) => BlocProvider.value(
                                      value: BlocProvider.of<ProfileCubit>(context),
                                      child: const ShellyCloudConnectDialog(),
                                    ),
                                  )
                              : null,
                          child: const Text('Connect'),
                        ),
                      ])),
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
          Navigator.of(context).pop();
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

class ShellyCloudConnectDialog extends StatelessWidget {
  const ShellyCloudConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shelly Cloud connected')));
        }
        if (state.status == ProfileStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shelly Cloud connection failed')));
        }
      },
      child: SimpleDialog(
        title: const Text('Login Shelly Cloud', textAlign: TextAlign.center),
        children: <Widget>[
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Column(children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: (value) => context.read<ProfileCubit>().onShellyCloudEmailChanged(value),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      onChanged: (value) => context.read<ProfileCubit>().onShellyCloudPasswordChanged(value),
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
                                await context.read<ProfileCubit>().onShellyCloudSignIn();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: const Text('Sign In'),
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
