import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CachedImage extends StatelessWidget {
  CachedImage({
    Key? key,
    required this.imageUrl,
    this.circle = false,
    this.withSize = false,
    this.radius = 20,
  }) : super(key: key);

  final String imageUrl;
  late bool circle;
  late bool withSize;
  late double radius;
  

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      height: withSize ? 80 : null,
      width: withSize ? 80 : null,
      imageBuilder: (circle)
          ? (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
                radius: radius,
              )
          : null,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const SizedBox(
        height: 200,
        width: double.infinity,
        child: Center(
          child: Icon(Icons.error, size: 40),
        ),
      ),
    );
  }
}
