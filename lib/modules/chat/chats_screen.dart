import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/cubit/main_cubit/main_cubit.dart';
import '../../shared/cubit/main_cubit/main_states.dart';
import '../../shared/widgets/cached_image.dart';
import '../../shared/widgets/components.dart';
import 'chat_details_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void didChangeDependencies() {
    MainCubit.get(context).getAllUsers();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final _admin = MainCubit.get(context).userModel;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(
             _admin!.username!,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.add))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('All Users'),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: MainCubit.get(context).users.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final _user = MainCubit.get(context).users[index];
                      return (_user.uid == _admin.uid)
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () => navigateTo(context,
                                    page: ChatDetailsScreen()),
                                leading: CachedImage(
                                  imageUrl: _user.avatarUrl!,
                                  circle: true,
                                ),
                                title: Text(_user.username!),
                                subtitle: const Text('message . 2w'),
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
