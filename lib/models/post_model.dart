class PostModel {
  String? uid;
  String? username;
  String? avatarUrl;
  String? postId;
  String? caption;
  DateTime? createdAt;
  List<Like>? likes;
  List<Comment>? comments;
  String? postImageUrl;

  PostModel({
    this.uid,
    this.username,
    this.avatarUrl,
    this.postId,
    this.caption,
    this.createdAt,
    this.postImageUrl,
    this.likes,
    this.comments,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uid = json["post_owner"]["uid"];
    username = json["post_owner"]["username"];
    avatarUrl = json["post_owner"]["avatar_url"];
    postId = json["post_id"];
    caption = json["caption"];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    postImageUrl = json["post_image_url"];
    likes = json["likes"] != null
        ? List<Like>.from(json["likes"].map((x) => Like.fromJson(x)))
        : [];
    comments = List.from(json["comments"].map((x) => Comment.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        'post_owner': {
          'uid': uid,
          'username': username,
          'avatar_url': avatarUrl,
        },
        'post_id': postId,
        'caption': caption,
        'post_image_url': postImageUrl,
        'likes': likes!.map((x) => x.toJson()).toList(),
        'comments': comments!.map((x) => x.toJson()).toList(),
        'created_at': createdAt?.toIso8601String(),
      };
}

class Like {
  String? likeId;
  String? uid;
  String? username;
  String? avatarUrl;

  Like({
    this.likeId,
    this.uid,
    this.username,
    this.avatarUrl,
  });

  Like.fromJson(Map<String, dynamic> json) {
    likeId = json["like_id"];
    uid = json['uid'];
    username = json["username"];
    avatarUrl = json["avatar_url"];
  }
  Map<String, dynamic> toJson() => {
        "like_id": likeId,
        'uid': uid,
        'username': username,
        'avatar_url': avatarUrl,
      };
}

class Comment {
  String? commentId;
  String? uid;
  String? username;
  String? avatarUrl;
  String? text;
  DateTime? createdAt;

  Comment(
      {this.commentId,
      this.uid,
      this.username,
      this.avatarUrl,
      this.text,
      this.createdAt});

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json["comment_id"];
    uid = json['uid'];
    username = json["username"];
    avatarUrl = json["avatar_url"];
    text = json["text"];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
  }

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        'uid': uid,
        'username': username,
        'avatar_url': avatarUrl,
        'text': text,
        'created_at': createdAt?.toIso8601String(),
      };
}
