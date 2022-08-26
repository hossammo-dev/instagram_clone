import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/cubit/main_cubit/main_cubit.dart';
import '../../shared/cubit/main_cubit/main_states.dart';
import '../../shared/widgets/cached_image.dart';
import '../../shared/widgets/components.dart';
import '../bookmark/bookmarks_screen.dart';
import '../post/add_post_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final _userModel = MainCubit.get(context).userModel;
        final _mainCubit = MainCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
            title: _userModel!.username!,
            actions: [
              IconButton(
                  onPressed: () =>
                      navigateTo(context, page: const AddPostScreen()),
                  icon: const Icon(Icons.add_box_outlined)),
              IconButton(
                  onPressed: () => _showBottomSheet(context),
                  icon: const Icon(Icons.menu)),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(_userModel.avatarUrl!),
                              radius: 35,
                            ),
                            _buildProfileCard(
                              title: 'Posts',
                              number: _userModel.posts!.length.toString(),
                            ),
                            _buildProfileCard(
                              title: 'Followers',
                              number: '0',
                            ),
                            _buildProfileCard(
                              title: 'Following',
                              number: '0',
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _userModel.username!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          _userModel.email!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Biography',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.85)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  defaultButton(
                      title: 'Edit Profile',
                      btnFun: () => navigateTo(
                            context,
                            page: BookmarksScreen(
                                bookmarks: _userModel.bookmarks),
                          )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildProfileMid(
                          icon: Icons.grid_on,
                          cubit: _mainCubit,
                          isGrid: _mainCubit.isGrid,
                          onTapped: () {
                            if (!_mainCubit.isGrid) {
                              _mainCubit.changeGridState();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: _buildProfileMid(
                          icon: Icons.list_alt_outlined,
                          cubit: _mainCubit,
                          isGrid: !_mainCubit.isGrid,
                          onTapped: () {
                            if (_mainCubit.isGrid) {
                              _mainCubit.changeGridState();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  GridView.builder(
                    itemCount: _userModel.posts!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                    ),
                    itemBuilder: (context, index) => CachedImage(
                        imageUrl: _userModel.posts![index].postImageUrl!),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column _buildProfileMid({
    required IconData icon,
    required MainCubit cubit,
    required bool isGrid,
    required VoidCallback onTapped,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapped,
          child: Icon(
            icon,
            size: 35,
            color: (isGrid) ? Colors.white : Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        if (isGrid)
          Container(
            height: 1.5,
            width: 200,
            color: Colors.white,
          ),
      ],
    );
  }

  Column _buildProfileCard({required String number, required String title}) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Future<dynamic> _showBottomSheet(
    BuildContext context,
  ) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.grey.shade900,
        elevation: 6.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        builder: (context) => SizedBox(
          height: 170,
          child: Column(
            children: [
              Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    _buildRow(Icons.settings, 'Settings'),
                    const SizedBox(height: 15),
                    _buildRow(Icons.archive_outlined, 'Archive'),
                    const SizedBox(height: 15),
                    _buildRow(Icons.bookmark_border_outlined, 'Saved'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Row _buildRow(IconData icon, String title) => Row(
      children: [
        Icon(icon, size: 30),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
}
