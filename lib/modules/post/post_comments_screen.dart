import 'package:flutter/material.dart';

import '../../models/post_model.dart';
import '../../shared/cubit/main_cubit/main_cubit.dart';
import '../../shared/widgets/cached_image.dart';
import '../../shared/widgets/field_container.dart';

// ignore: must_be_immutable
class PostCommentsScreen extends StatelessWidget {
  PostCommentsScreen({Key? key, required this.postId, required this.comments})
      : super(key: key);

  final List<Comment> comments;
  final String postId;

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: (comments.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.info_outline, size: 70),
                        SizedBox(height: 8),
                        Text(
                          "No comments yet!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final Comment _comment = comments[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CachedImage(
                            imageUrl: _comment.avatarUrl!, circle: true),
                        title: Text(_comment.username!),
                        subtitle: Text(_comment.text!),
                      ),
                    );
                  },
                ),
          ),
          FieldContainer(
            controller: _commentController,
            hint: 'Type a comment',
            onTap: () {
              MainCubit.get(context)
                  .createComment(
                      postId: postId, comment: _commentController.text);
              _commentController.clear();
            },
          ),
        ],
      ),
    );
  }
}
