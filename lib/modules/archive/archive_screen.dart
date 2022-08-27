import 'package:flutter/material.dart';

import '../../shared/constants.dart';
import '../../shared/widgets/cached_image.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

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
          itemCount: 30,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
          itemBuilder: (context, index) {
            // final _imageUrl = bookmarks?[index].post?.postImageUrl;
            return GridTile(
              child: CachedImage(
                imageUrl: Constants.dummyImage,
              ),
            );
          },
        ),
      ),
    );
  }
}
