import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart'; //todo remove
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/shared/widgets/components.dart';
import 'package:uuid/uuid.dart';

import '../../../models/activity_model.dart';
import '../../../models/bookmark_model.dart';
import '../../../models/message_model.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../constants.dart';
import '../../network/local/cache_helper.dart';
import '../../network/remote/firebase_services.dart';
import 'main_states.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitState());

  static MainCubit get(BuildContext context) => BlocProvider.of(context);

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _isGrid = true;
  bool get isGrid => _isGrid;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  final List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  final List<UserModel> _users = [];
  List<UserModel> get users => _users;

  final List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  final List<ActivityModel> _activities = [];
  List<ActivityModel> get activities => _activities;

  //get user
  void getUserData() {
    FirebaseServices.get(collection: 'users', docId: Constants.userId)
        .then((user) {
      _userModel = UserModel.fromjson(user.data()!);
      emit(MainGetuserDataSuccessState());
    }).catchError((error) {
      emit(MainGetuserDataErrorState());
    });
  }

  //get all users
  void getAllUsers() {
    if (_users.isEmpty) {
      FirebaseServices.getAll(collection: 'users').then((users) {
        for (var user in users.docs) {
          _users.add(UserModel.fromjson(user.data()));
        }
        emit(MainGetAllUsersSuccessState());
      }).catchError((error) {
        emit(MainGetAllUsersErrorState());
      });
    }
  }

  //remove cached data
  void removeCachedData() async {
    await CacheHelper.remove('uid');
    _userModel = UserModel();
    _posts.clear();
    _users.clear();
    _currentIndex = 0;
    _isGrid = true;
  }

  //follow user
  Future<void> followUser({
    required String uid,
    required String username,
    required String avatarUrl,
  }) async {
    FollowModel _followerModel = FollowModel(
      uid: _userModel!.uid!,
      avatarUrl: _userModel!.avatarUrl,
      username: _userModel!.username,
    );

    //add data to follower
    //Me => Him
    FirebaseServices.update(collection: 'users', docId: uid, data: {
      'followers': FieldValue.arrayUnion([_followerModel.toJson()]),
    }).whenComplete(() {
      FollowModel _followingModel = FollowModel(
        uid: uid,
        avatarUrl: avatarUrl,
        username: username,
      );
      //add data to following
      //Him => Me
      FirebaseServices.update(
          collection: 'users',
          docId: _userModel!.uid!,
          data: {
            'following': FieldValue.arrayUnion([_followingModel.toJson()]),
          });
      //update user model
      _userModel?.followers?.add(_followerModel);
      _addToActivity(_userModel!,
          activityTitle: "${_userModel!.username} followed $username");
      emit(MainFollowUserSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(MainFollowUserErrorState());
    });
  }

  //unfollow user
  Future<void> unFollowUser({
    required String uid,
    required String username,
    required String avatarUrl,
  }) async {
    FollowModel _followerModel = FollowModel(
      uid: _userModel!.uid!,
      avatarUrl: _userModel!.avatarUrl,
      username: _userModel!.username,
    );
    FirebaseServices.update(collection: 'users', docId: uid, data: {
      'followers': FieldValue.arrayRemove([_followerModel.toJson()]),
    }).whenComplete(() {
      FollowModel _followingModel = FollowModel(
        uid: uid,
        avatarUrl: avatarUrl,
        username: username,
      );

      FirebaseServices.update(
          collection: 'users',
          docId: _userModel!.uid!,
          data: {
            'following': FieldValue.arrayRemove([_followingModel.toJson()]),
          });
      //update user model
      _userModel?.followers?.remove(_followerModel);
      _addToActivity(_userModel!,
          activityTitle: "${_userModel!.username} unfollowed $username");
      emit(MainFollowUserSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(MainFollowUserErrorState());
    });
  }

  //get posts
  Future<void> getPosts() async {
    _posts.clear();
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('created_at', descending: true)
        .get()
        .then((event) {
      for (var post in event.docs) {
        _posts.add(PostModel.fromJson(post.data()));
      }
      // event.docs.map((post) => _posts.add(PostModel.fromJson(post.data())));
    });
    emit(MainGetPostsSuccessState());
  }

  //create post
  Future<void> createPost(
      {required String caption, required File imageFile}) async {
    emit(MainLoadingState());
    String? _imageUrl = await FirebaseServices.saveToStorage(
        imageFile: imageFile,
        path: 'images/${Uri.file(imageFile.path)..pathSegments.last}');
    final String _postId = const Uuid().v4();

    PostModel _model = PostModel(
      uid: _userModel!.uid,
      username: _userModel!.username,
      avatarUrl: _userModel!.avatarUrl,
      postId: _postId,
      caption: caption,
      createdAt: DateTime.now(),
      postImageUrl: _imageUrl,
      likes: [],
      comments: [],
    );

    await FirebaseServices.save(
            collection: 'posts', docId: _postId, data: _model.toJson())
        .whenComplete(() async {
      await FirebaseServices.update(
        collection: 'users',
        docId: _userModel!.uid!,
        data: {
          'posts': FieldValue.arrayUnion([_model.toJson()]),
        },
      );
      await getPosts();
      getUserData();
      _addToActivity(_userModel!,
          activityTitle: "${_userModel!.username} created a new post");
      emit(MainCreatePostSuccessState());
    }).catchError((error) {
      defaultToast(
        message: error.toString(),
        bgColor: Colors.red,
        txColor: Colors.white,
      );
      emit(MainCreatePostErrorState());
    });
  }

  //like post
  void likePost(PostModel post, int index) {
    final String _likeId = const Uuid().v4();
    final Like _like = Like(
      likeId: _likeId,
      uid: _userModel!.uid,
      username: _userModel!.username,
      avatarUrl: _userModel!.avatarUrl,
    );
    FirebaseServices.update(collection: 'posts', docId: post.postId!, data: {
      'likes': FieldValue.arrayUnion([_like.toJson()])
    }).whenComplete(() async {
      await FirebaseServices.update(
          collection: 'users',
          docId: _userModel!.uid!,
          data: {
            'liked_posts': FieldValue.arrayUnion([post.toJson()])
          });
      _posts[index].likes!.add(_like);
      _userModel!.likedPosts!.add(post);
      _addToActivity(_userModel!,
          activityTitle:
              "${_userModel!.username} liked ${post.username}'s post");
      emit(MainLikePostSuccessState());
    }).catchError((error) {
      debugPrint('$error');
      emit(MainLikePostErrorState());
    });
  }

  //remove like
  void unlikePost(
      {required Like like, required PostModel post, required int index}) {
    FirebaseServices.update(collection: 'posts', docId: post.postId!, data: {
      'likes': FieldValue.arrayRemove([like.toJson()])
    }).whenComplete(() async {
      await FirebaseServices.update(
        collection: 'users',
        docId: userModel!.uid!,
        data: {
          'liked_posts': FieldValue.arrayRemove([post.toJson()]),
        },
      );
      _posts[index].likes!.remove(like);
      _userModel!.likedPosts!.remove(post);
      emit(MainLikePostSuccessState());
    }).catchError((error) {
      debugPrint('$error');
      emit(MainLikePostErrorState());
    });
  }

  //create comment
  void createComment({required String postId, required String comment}) async {
    final String _commentId = const Uuid().v4();
    final Comment _comment = Comment(
      commentId: _commentId,
      uid: _userModel!.uid,
      username: _userModel!.username,
      avatarUrl: _userModel!.avatarUrl,
      text: comment,
      createdAt: DateTime.now(),
    );
    FirebaseServices.update(collection: 'posts', docId: postId, data: {
      'comments': FieldValue.arrayUnion([_comment.toJson()])
    }).whenComplete(() async {
      await getPosts();
      _addToActivity(_userModel!,
          activityTitle:
              "${_userModel!.username} commented on post}"); //todo: repair this and set it to user's post
      emit(MainCommentPostSuccessState());
    }).catchError((error) {
      debugPrint('$error');
      emit(MainCommentPostErrorState());
    });
  }

  //bookmark post
  void bookmarkPost(PostModel post) async {
    final String _bookmarkId = const Uuid().v4();
    final _model = BookmarkModel(
      id: _bookmarkId,
      post: post,
    );
    await FirebaseServices.save(
            collection: 'bookmarked_posts',
            docId: _bookmarkId,
            data: _model.toJson())
        .whenComplete(() async {
      await FirebaseServices.update(
          collection: 'users',
          docId: _userModel!.uid!,
          data: {
            'bookmarks': FieldValue.arrayUnion([_model.toJson()]),
          });
      _userModel!.bookmarks!.add(_model);
      emit(MainBookmarkPostSuccessState());
    }).catchError((error) {
      debugPrint('Error');
      emit(MainBookmarkPostErrorState());
    });
  }

  //unbookmark post
  void unbookmarkPost(BookmarkModel model) async {
    await FirebaseServices.delete(
            collection: 'bookmarked_posts', docId: model.id!)
        .whenComplete(() {
      FirebaseServices.update(
          collection: 'users',
          docId: userModel!.uid!,
          data: {
            'bookmarks': FieldValue.arrayRemove([model.toJson()]),
          });
      _userModel!.bookmarks!.remove(model);
      emit(MainBookmarkPostSuccessState());
    }).catchError(
      (error) => emit(MainBookmarkPostErrorState()),
    );
  }

  //edit profile
  Future<void> editProfile(String username, String bio) async {
    await FirebaseServices.update(
        collection: 'users',
        docId: _userModel!.uid!,
        data: {
          'username': username,
          'bio': bio,
        }).whenComplete(() {
      getUserData();
      emit(MainEditProfileSuccessState());
    }).catchError((error) => emit(MainEditProfileErrorState()));
  }

  //messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String id) =>
      FirebaseServices.getStream(
          collection: 'users',
          docId: userModel!.uid!,
          secondCollection: 'chats',
          secondDocId: id,
          thirdCollection: 'messages');

  //send message
  Future<void> sendMessage({
    required String message,
    required String receiverId,
    required String receiverName,
  }) async {
    final _messageId = const Uuid().v4();
    final _message = MessageModel(
      id: _messageId,
      senderId: _userModel!.uid!,
      receiverId: receiverId,
      message: message,
      time: DateTime.now(),
    );

    //me chats
    FirebaseServices.save(
            collection: 'users',
            docId: _userModel!.uid!,
            secondCollection: 'chats',
            secondDocId: receiverName,
            thirdCollection: 'messages',
            thirdDocId: _messageId,
            data: _message.toJson())
        .whenComplete(() {
      //receiver chats
      FirebaseServices.save(
          collection: 'users',
          docId: receiverId,
          secondCollection: 'chats',
          secondDocId: _userModel?.username,
          thirdCollection: 'messages',
          thirdDocId: _messageId,
          data: _message.toJson());
      emit(MainSendMessageSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(MainSendMessageErrorState());
    });
  }

  //add to activity
  Future<void> _addToActivity(UserModel user,
      {required String activityTitle}) async {
    final _docId = const Uuid().v4();
    final _model = ActivityModel(
      id: _docId,
      uid: user.uid,
      avatarUrl: user.avatarUrl,
      activityTitle: activityTitle,
      time: DateTime.now(),
    );

    FirebaseServices.save(
      collection: 'activities',
      docId: _docId,
      data: _model.toJson(),
    ).whenComplete(() {
      _activities.add(_model);
      emit(MainAddToActivitySuccessState());
    });
  }

  //get activities
  Future<List<ActivityModel>> getActivities() async {
    _activities.clear();
    await FirebaseServices.getAll(collection: 'activities').then((activities) {
      activities.docs.map((activity) => _activities.add(ActivityModel.fromJson(activity.data()))).toList();
      emit(MainGetActivitiesSuccessState());
    });
    return _activities;
  }

  Future<File?> pickImage(ImageSource source) async {
    File? _imageFile;
    XFile? _pickedFile;

    _pickedFile = await ImagePicker().pickImage(source: source);
    if (_pickedFile != null) {
      _imageFile = File(_pickedFile.path);
    }
    return _imageFile;
  }

  //change grid state
  void changeGridState() {
    _isGrid = !_isGrid;
    emit(MainChangeGridState());
  }

  //change index
  void changeIndex(int index) {
    _currentIndex = index;
    emit(MainChangeIndexState());
  }
}
