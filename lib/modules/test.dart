// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class Test extends StatelessWidget {
//   const Test({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//                 onPressed: () {
//                   FirebaseFirestore.instance.collection('test').doc('id').set({
//                     'test': {
//                       'id': {
//                         'test': 'test',
//                         'id': 1,
//                       },
//                     },
//                   });
//                   print('Done');
//                 },
//                 icon: const Icon(
//                   Icons.add,
//                   size: 40,
//                 )),
//             IconButton(
//                 onPressed: () {
//                   FirebaseFirestore.instance
//                       .collection('test')
//                       .doc('id')
//                       .update({
//                     'test.id3': {
//                       'test': 'test3',
//                       'id': 3,
//                     },
//                   });
//                   print('Done');
//                 },
//                 icon: const Icon(
//                   Icons.edit,
//                   size: 40,
//                 )),
//             IconButton(
//                 onPressed: () {
//                   FirebaseFirestore.instance
//                       .collection('test')
//                       .doc('id')
//                       .update({
//                     'test.id2': FieldValue.delete(),
//                   });
//                   print('Done');
//                 },
//                 icon: const Icon(
//                   Icons.remove,
//                   size: 40,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
