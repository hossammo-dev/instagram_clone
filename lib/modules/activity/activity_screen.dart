import 'package:flutter/material.dart';
import 'package:instagram_clone/shared/constants.dart';

import '../../shared/widgets/cached_image.dart';
import '../../shared/widgets/components.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        title: 'Activity',
        actions: [],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: 100,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: CachedImage(
                  imageUrl: Constants.userImage,
                  circle: true,
                ),
                title: const Text(Constants.dummyText),
                subtitle: const Text('1w'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
