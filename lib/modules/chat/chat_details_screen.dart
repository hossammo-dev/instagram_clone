import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../shared/constants.dart';
import '../../shared/cubit/main_cubit/main_cubit.dart';
import '../../shared/cubit/main_cubit/main_states.dart';
import '../../shared/widgets/cached_image.dart';
import '../../shared/widgets/field_container.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen(this._user, {Key? key}) : super(key: key);

  final UserModel _user;

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final _mainCubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Row(
              children: [
                CachedImage(
                  imageUrl: _user.avatarUrl ?? Constants.userImage,
                  circle: true,
                  radius: 15,
                ),
                const SizedBox(width: 10),
                Text(
                  _user.username ?? Constants.username,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _mainCubit.getMessages(_user.username!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final _admin = (_mainCubit.userModel!.uid! ==
                                snapshot.data?.docs[index]['sender_id']);
                            return Align(
                              alignment: (_admin)
                                  ? AlignmentDirectional.centerEnd
                                  : AlignmentDirectional.centerStart,
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                margin: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  color: (_admin)
                                      ? Colors.blue
                                      : Colors.grey.shade800,
                                  borderRadius: (_admin)
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        )
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                ),
                                child:
                                    Text(snapshot.data?.docs[index]['message']),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                FieldContainer(
                  controller: _messageController,
                  hint: 'Type a message',
                  onTap: () => _mainCubit
                      .sendMessage(
                          message: _messageController.text,
                          receiverId: _user.uid!,
                          receiverName: _user.username!)
                      .whenComplete(() => _messageController.clear()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
