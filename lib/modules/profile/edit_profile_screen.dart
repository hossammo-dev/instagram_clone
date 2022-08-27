import 'package:flutter/material.dart';

import '../../layouts/home_layout.dart';
import '../../models/user_model.dart';
import '../../shared/cubit/main_cubit/main_cubit.dart';
import '../../shared/widgets/cached_image.dart';
import '../../shared/widgets/components.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(this._userModel, {Key? key}) : super(key: key);

  final UserModel _userModel;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioControlller = TextEditingController();

  @override
  void didChangeDependencies() {
    _nameController.text = widget._userModel.username!;
    _bioControlller.text = widget._userModel.bio!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        title: 'Edit Profile',
        actions: [
          IconButton(
              onPressed: () => MainCubit.get(context)
                  .editProfile(_nameController.text, _bioControlller.text)
                  .whenComplete(
                      () => navigateRemove(context, page: const HomeLayout())),
              icon: const Icon(
                Icons.check,
                color: Colors.teal,
                size: 40,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              children: [
                CachedImage(
                  imageUrl: widget._userModel.avatarUrl!,
                  circle: true,
                  radius: 55,
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {},
                  child: const Text("Change profile photo",
                      style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                defaultTextField(
                    controller: _nameController,
                    hint: 'Username',
                    label: 'Username'),
                const SizedBox(height: 10),
                defaultTextField(
                    controller: _bioControlller, hint: 'Bio', label: 'Bio'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
