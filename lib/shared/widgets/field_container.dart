import 'package:flutter/material.dart';

class FieldContainer extends StatelessWidget {
  const FieldContainer(
      {Key? key, this.controller, this.hint, required this.onTap})
      : super(key: key);

  final TextEditingController? controller;
  final String? hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white30,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          FloatingActionButton(
            onPressed: () {},
            mini: true,
            backgroundColor: Colors.blueAccent.shade200,
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: onTap,
              child: const Text(
                'Send',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
