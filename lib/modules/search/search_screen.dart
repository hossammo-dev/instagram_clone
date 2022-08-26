import 'package:flutter/material.dart';
import 'package:instagram_clone/shared/widgets/components.dart';

import '../../shared/constants.dart';
import '../../shared/widgets/cached_image.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 45,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white),
                    const SizedBox(width: 16),
                    Expanded(
                      child: defaultTextField(
                          controller: _searchController,
                          hint: 'Search',
                          border: InputBorder.none),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                itemCount: 100,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                ),
                itemBuilder: (context, index) =>
                    CachedImage(imageUrl: Constants.dummyImage),
              ),
            ],
          ),
        ),
      );
  }
}
