import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/shared/constants.dart';
import 'package:instagram_clone/shared/widgets/components.dart';

import '../../shared/cubit/main_cubit/main_cubit.dart';
import '../../shared/cubit/main_cubit/main_states.dart';
import '../../shared/widgets/cached_image.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();

  File? _imageFile;

  void _getImageFile(value) => setState(() {
        _imageFile = value;
      });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final MainCubit _mainCubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back)),
            title: const Text('New Post'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                    onPressed: () {
                      if (_imageFile != null) {
                        _mainCubit
                            .createPost(
                                caption: _captionController.text,
                                imageFile: _imageFile!)
                            .whenComplete(() => Navigator.pop(context));
                      } else {
                        defaultToast(message: 'Please select an image');
                      }
                    },
                    icon: (state is MainLoadingState)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(Icons.check,
                            size: 40, color: Colors.teal)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showModalSheet(context, _mainCubit),
                        child: (_imageFile != null)
                            ? Image.file(
                                _imageFile!,
                                height: 80,
                                width: 80,
                              )
                            : CachedImage(
                                imageUrl: Constants.dummyImage, withSize: true),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _captionController,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a caption...',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      color: Colors.white60,
                    ),
                  ),
                  const Text(
                    'Tag People',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      color: Colors.white60,
                    ),
                  ),
                  const Text(
                    'Add Location',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future _showModalSheet(BuildContext context, MainCubit mainCubit) =>
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 100,
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: defaultButton(
                  title: 'Camera',
                  btnColor: Colors.blue,
                  btnFun: () => mainCubit
                      .pickImage(ImageSource.camera)
                      .then((value) => _getImageFile(value))
                      .whenComplete(() => Navigator.pop(context)),
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: defaultButton(
                  title: 'Gallery',
                  btnFun: () => mainCubit
                      .pickImage(ImageSource.gallery)
                      .then((value) => _getImageFile(value))
                      .whenComplete(() => Navigator.pop(context)),
                )),
              ],
            ),
          ),
        ),
      );
}
