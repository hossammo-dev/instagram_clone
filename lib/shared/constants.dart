import 'package:flutter/material.dart';

import '../modules/activity/activity_screen.dart';
import '../modules/feed/feed_screen.dart';
import '../modules/profile/profile_screen.dart';
import '../modules/search/search_screen.dart';

class Constants {
  static const String appLogo = 'assets/animations/insta.json';

  static List<Widget> pages = [
    const FeedScreen(),
    SearchScreen(),
    const ActivityScreen(),
    const ProfileScreen(),
  ];

  

  static const String userImage =
      'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60';

  static const String dummyImage =
      'https://images.unsplash.com/photo-1659221483861-2957e5e5726a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80';

  static const String dummyText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';

  static const String username = 'Unknown';

  static String userId = '';
}
