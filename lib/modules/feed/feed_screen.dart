import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/modules/profile/profile_screen.dart';

import '../../models/bookmark_model.dart';
import '../../models/post_model.dart';
import '../../shared/constants.dart';
import '../../shared/cubit/main_cubit/main_cubit.dart';
import '../../shared/cubit/main_cubit/main_states.dart';
import '../../shared/widgets/cached_image.dart';
import '../../shared/widgets/components.dart';
import '../chat/chats_screen.dart';
import '../post/add_post_screen.dart';
import '../post/post_comments_screen.dart';
import '../post/post_likes_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void didChangeDependencies() {
    if (MainCubit.get(context).userModel == null &&
        MainCubit.get(context).posts.isEmpty) {
      MainCubit.get(context).getUserData();
      MainCubit.get(context).getPosts();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final MainCubit _mainCubit = MainCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
            title: 'Instagram',
            actions: [
              IconButton(
                  onPressed: () =>
                      navigateTo(context, page: const AddPostScreen()),
                  icon: const Icon(Icons.add_box_outlined)),
              IconButton(
                  onPressed: () =>
                      navigateTo(context, page: const ChatsScreen()),
                  icon: const Icon(Icons.send_outlined)),
            ],
          ),
          body: (_mainCubit.posts.isEmpty)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _mainCubit.posts.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final PostModel _post = _mainCubit.posts[index];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              (_post.uid == Constants.userId)
                                  ? _mainCubit.changeIndex(3)
                                  : navigateTo(
                                      context,
                                      page: ProfileScreen(userId: _post.uid),
                                    );
                            },
                            child: Row(
                              children: [
                                CachedImage(
                                  imageUrl: _post.avatarUrl!,
                                  circle: true,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _post.username!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          CachedImage(imageUrl: _post.postImageUrl!),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _checkForPostLikes(
                                        _post, _mainCubit, index),
                                    onLongPress: () => navigateTo(context,
                                        page: PostLikesScreen(_post.likes!)),
                                    child: (_post.likes!.any((element) =>
                                            element.uid == Constants.userId))
                                        ? const Icon(Icons.favorite,
                                            color: Colors.red, size: 30)
                                        : const Icon(
                                            Icons.favorite_border_outlined,
                                            size: 30,
                                          ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                      onPressed: () => navigateTo(context,
                                          page: PostCommentsScreen(
                                            comments: _post.comments!,
                                            postId: _post.postId!,
                                          )),
                                      icon: const Icon(Icons.comment)),
                                  IconButton(
                                      onPressed: () {
                                        print(_post.likes!.any((element) =>
                                            element.uid ==
                                            _mainCubit.userModel!.uid));
                                      },
                                      icon: const Icon(Icons.share)),
                                ],
                              ),
                              IconButton(
                                  onPressed: () =>
                                      _checkForPostBookmarks(_mainCubit, _post),
                                  icon: (_mainCubit.userModel!.bookmarks!.any(
                                          (element) =>
                                              _post.postId ==
                                              element.post?.postId))
                                      ? const Icon(Icons.bookmark)
                                      : const Icon(
                                          Icons.bookmark_outline_outlined))
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  void _checkForPostLikes(PostModel _post, MainCubit _mainCubit, int index) {
    if (_post.likes!.isNotEmpty) {
      //check for user id
      for (Like like in _post.likes!) {
        if (like.uid != _mainCubit.userModel!.uid) {
          _mainCubit.likePost(_post, index);
          debugPrint('Liked2');
          break;
        } else {
          //user already liked post
          _mainCubit.unlikePost(like: like, post: _post, index: index);
          debugPrint('unLiked');
          break;
        }
      }
    } else {
      //no likes
      _mainCubit.likePost(_post, index);
      debugPrint('Liked1');
    }
  }

  void _checkForPostBookmarks(MainCubit _mainCubit, PostModel _post) {
    if (_mainCubit.userModel!.bookmarks!.isNotEmpty) {
      BookmarkModel _model = _mainCubit.userModel!.bookmarks!.firstWhere(
          (element) => element.post?.postId == _post.postId,
          orElse: () => BookmarkModel());
      if (_model.post?.postId == _post.postId && _model.post?.postId != null) {
        //user already bookmarked post
        _mainCubit.unbookmarkPost(_model);
        debugPrint('unbookmarked');
      } else {
        //user not bookmarked post
        _mainCubit.bookmarkPost(_post);
        debugPrint('Bookmarked2');
      }
    } else {
      _mainCubit.bookmarkPost(_post);
      debugPrint('Bookmarked');
    }
  }
}
