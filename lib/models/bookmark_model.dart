import 'post_model.dart';

class BookmarkModel {
  String? id;
  PostModel? post;

  BookmarkModel({
    this.id,
    this.post,
  });

  BookmarkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    post = PostModel.fromJson(json['post']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "post": post!.toJson(),
      };
}
