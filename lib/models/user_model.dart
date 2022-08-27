import 'bookmark_model.dart';
import 'post_model.dart';

class UserModel {
  String? uid;
  String? username;
  String? email;
  String? phoneNumber;
  String? avatarUrl;
  String? bio;
  List<PostModel>? likedPosts;
  List<PostModel>? posts;
  List<BookmarkModel>? bookmarks;
  // List<Follower>? followers;
  // List<Following>? following;

  UserModel({
    this.uid,
    this.username,
    this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.bio,
    this.likedPosts,
    this.posts,
    this.bookmarks,
  });

  //Map<String, PostModel>

  UserModel.fromjson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    avatarUrl = json['avatar_url'];
    bio = json['bio'];
    likedPosts =
        List.from(json['liked_posts'].map((x) => PostModel.fromJson(x)));
    posts = List.from(json['posts'].map((x) => PostModel.fromJson(x)));
    bookmarks =
        List.from(json['bookmarks'].map((x) => BookmarkModel.fromJson(x)));

    // followers = json['followers']
    //     .forEach((follower) => Follower.fromJson(follower.data()));
    // following = json['following']
    //     .forEach((following) => Follower.fromJson(following.data()));
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'avatar_url': avatarUrl,
        'bio': bio,
        'liked_posts': likedPosts,
        'posts': posts,
        'bookmarks': bookmarks,
        // 'followers': followers,
        // 'following': following,
      };
}

class Follower {
  String? uid;
  String? username;
  String? avatarUrl;

  Follower.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'avatar_url': avatarUrl,
      };
}

class Following {
  String? uid;
  String? username;
  String? avatarUrl;

  Following.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'avatar_url': avatarUrl,
      };
}
