import 'package:flutter/material.dart';

import '../../models/bookmark_model.dart';
import '../../shared/widgets/cached_image.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({Key? key, required this.bookmarks}) : super(key: key);

  final List<BookmarkModel>? bookmarks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: bookmarks?.length,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
          itemBuilder: (context, index) {
            final _imageUrl = bookmarks?[index].post?.postImageUrl;
            return GridTile(
              child: CachedImage(
                imageUrl: _imageUrl!,
              ),
            );
          },
        ),
      ),
    );
  }
}
