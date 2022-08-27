import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/bookmark_model.dart';
import '../../models/user_model.dart';
import '../../shared/constants.dart';
import '../../shared/cubit/main_cubit/main_cubit.dart';
import '../../shared/cubit/main_cubit/main_states.dart';
import '../../shared/network/remote/firebase_services.dart';
import '../../shared/widgets/cached_image.dart';
import '../../shared/widgets/components.dart';
import '../archive/archive_screen.dart';
import '../bookmark/bookmarks_screen.dart';
import '../post/add_post_screen.dart';
import '../settings/settings_screen.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, this.userId}) : super(key: key);

  late String? userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _model;
  UserModel? _userModel;

  @override
  void initState() {
    if (widget.userId != null) {
      Future.delayed(const Duration(seconds: 1), () async {
        await _getUserData();
        _determineUser("alt");
      });
    } else {
      _determineUser("profile");
    }
    super.initState();
  }

  Future<void> _getUserData() async {
    await FirebaseServices.get(collection: 'users', docId: widget.userId!)
        .then((value) {
      _model = UserModel.fromjson(value.data()!);
    });
  }

  void _determineUser(String key) {
    if (key == "profile") {
      _userModel = MainCubit.get(context).userModel;
    } else {
      _userModel = _model;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final _mainCubit = MainCubit.get(context);
        if ((_userModel == null)) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final _admin = _userModel?.uid == Constants.userId;
          return Scaffold(
            appBar: defaultAppBar(
              title: _userModel!.username!,
              actions: (_admin)
                  ? [
                      IconButton(
                          onPressed: () =>
                              navigateTo(context, page: const AddPostScreen()),
                          icon: const Icon(Icons.add_box_outlined)),
                      IconButton(
                          onPressed: () =>
                              _showBottomSheet(context, _userModel!.bookmarks!),
                          icon: const Icon(Icons.menu)),
                    ]
                  : [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_outlined)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.more_vert)),
                    ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(_userModel!.avatarUrl!),
                                radius: 35,
                              ),
                              _buildProfileCard(
                                title: 'Posts',
                                number: _userModel!.posts!.length.toString(),
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
                            _userModel!.username!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Biography', //todo add bio for user
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.85)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    (_admin)
                        ? defaultButton(
                            title: 'Edit Profile',
                            btnColor: Colors.grey.shade900,
                            btnFun: () => navigateTo(
                                  context,
                                  page: BookmarksScreen(
                                      bookmarks: _userModel!.bookmarks),
                                ))
                        : Row(
                            children: [
                              Expanded(
                                  child: defaultButton(
                                      btnColor: Colors.grey.shade900,
                                      title: 'Follow',
                                      btnFun: () {})),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: defaultButton(
                                      btnColor: Colors.grey.shade900,
                                      title: 'Message',
                                      btnFun: () {})),
                            ],
                          ),
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
                    (_mainCubit.isGrid)
                        ? GridView.builder(
                            itemCount: _userModel!.posts!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                            ),
                            itemBuilder: (context, index) => CachedImage(
                                imageUrl:
                                    _userModel!.posts![index].postImageUrl!),
                          )
                        : ListView.builder(
                            itemCount: _userModel!.posts!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: CachedImage(
                                  imageUrl:
                                      _userModel!.posts![index].postImageUrl!),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        }
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
    List<BookmarkModel> bookmarks,
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
                    _buildRow(
                        Icons.settings,
                        'Settings',
                        () =>
                            navigateTo(context, page: const SettingsScreen())),
                    const SizedBox(height: 20),
                    _buildRow(Icons.archive_outlined, 'Archive',
                        () => navigateTo(context, page: const ArchiveScreen())),
                    const SizedBox(height: 20),
                    _buildRow(
                        Icons.bookmark_border_outlined,
                        'Saved',
                        () => navigateTo(context,
                            page: BookmarksScreen(
                              bookmarks: bookmarks,
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildRow(IconData icon, String title, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
}
