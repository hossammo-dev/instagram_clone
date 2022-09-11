import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/widgets/cached_image.dart';


class UsersSearchScreen extends StatefulWidget {
  const UsersSearchScreen({Key? key}) : super(key: key);

  @override
  State<UsersSearchScreen> createState() => _UsersSearchScreenState();
}

class _UsersSearchScreenState extends State<UsersSearchScreen> {
  final TextEditingController _queryController = TextEditingController();

  var _isWriting = false;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _queryStream;

  void _checkStatus(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _isWriting = true;
      });
    } else {
      setState(() {
        _isWriting = false;
      });
    }
  }

  void _searchForUser(query) {
    setState(() {
      _queryStream = FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + 'z')
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //header
              Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 25)),
                  Expanded(
                    child: Container(
                      height: 38,
                      width: double.infinity,
                      padding: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _queryController,
                              decoration: const InputDecoration(
                                  hintText: 'Search', border: InputBorder.none),
                              onChanged: (query) {
                                _checkStatus(query);
                                _searchForUser(query);
                              },
                            ),
                          ),
                          if (_isWriting)
                            GestureDetector(
                              onTap: () => _queryController.clear(),
                            child: const Icon(Icons.close, color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              //body
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _queryStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || _queryController.text.isEmpty) {
                    print("no data");
                    return const SizedBox();
                  } else {
                    print("has data");
                    print(snapshot.data!.docs.length);
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final _user = snapshot.data!.docs[index].data();
                          print(_user['avatar_url']);
                          return ListTile(
                            leading: CachedImage(
                              imageUrl: _user['avatar_url'],
                              circle: true,
                            ),
                            title: Text(_user['username']),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
