import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/modules/search/users_search_screen.dart';
import 'package:instagram_clone/shared/widgets/components.dart';

import '../../shared/constants.dart';
import '../../shared/cubit/main_cubit/main_cubit.dart';
import '../../shared/cubit/main_cubit/main_states.dart';
import '../../shared/widgets/cached_image.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => navigateTo(context, page: const UsersSearchScreen()),
              child: Container(
                height: 35,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white),
                    const SizedBox(width: 16),
                    Expanded(
                      child: defaultTextField(
                        controller: _searchController,
                        hint: 'Search',
                        border: InputBorder.none,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            BlocConsumer<MainCubit, MainStates>(
              listener: (context, state) {},
              builder: (context, state) {
                final _posts = MainCubit.get(context).posts;
                return GridView.builder(
                  itemCount: _posts.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                  ),
                  itemBuilder: (context, index) {
                    final _post = _posts[index];
                    return CachedImage(imageUrl: _post.postImageUrl!);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
