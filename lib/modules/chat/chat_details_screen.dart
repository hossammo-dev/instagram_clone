import 'package:flutter/material.dart';
import 'package:instagram_clone/shared/constants.dart';

import '../../shared/widgets/field_container.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({Key? key}) : super(key: key);
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          children: const [
            CircleAvatar(
              backgroundImage: NetworkImage(Constants.userImage),
              radius: 15,
            ),
            SizedBox(width: 10),
            Text(
              Constants.username,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 30,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => Align(
                alignment: (index % 2 == 0)
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text('Hello World!'),
                ),
              ),
            ),
          ),
          FieldContainer(
            controller: _messageController,
            hint: 'Type a message',
            onTap: (){},
          ),
        ],
      ),
    );
  }
}
