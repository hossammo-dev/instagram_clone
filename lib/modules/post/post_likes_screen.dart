import 'package:flutter/material.dart';

import '../../models/post_model.dart';
import '../../shared/widgets/cached_image.dart';

class PostLikesScreen extends StatelessWidget {
  const PostLikesScreen(this._likes, {Key? key}) : super(key: key);

  final List<Like> _likes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Likes'),
      ),
      body: (_likes.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.info_outline, size: 70),
                  SizedBox(height: 8),
                  Text(
                    "No likes yet!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _likes.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final Like _like = _likes[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading:
                        CachedImage(imageUrl: _like.avatarUrl!, circle: true),
                    title: Text(_like.username!),
                    subtitle: const Text('Some text'),
                  ),
                );
              },
            ),
    );
  }
}
