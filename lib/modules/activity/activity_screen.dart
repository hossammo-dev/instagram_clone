import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../../models/activity_model.dart';
import '../../shared/cubit/main_cubit/main_cubit.dart';
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
          child: FutureBuilder<List<ActivityModel>>(
              future: MainCubit.get(context).getActivities(),
              builder: (context, activities) {
                if (activities.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: activities.data?.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final _activity = activities.data![index];
                      return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        leading: CachedImage(
                          imageUrl: _activity.avatarUrl!,
                          circle: true,
                        ),
                        title: Text(_activity.activityTitle!),
                        subtitle: Text(timeago.format(_activity.time!)),
                      ),
                    );
                    },
                  );
                }
              }),
        ),
      ),
    );
  }
}
