import 'dart:io';
import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sensei/core/common/loader.dart';
import 'package:sensei/core/constants/constants.dart';
import 'package:sensei/core/utlis.dart';
import 'package:sensei/features/community/controller/community_controller.dart';
import 'package:sensei/responsive/responsive.dart';
import 'package:sensei/theme/pallete.dart';

final tagListProvider =
    StateNotifierProvider<TagListNotifier, List<String>>((ref) {
  return TagListNotifier();
});

class TagListNotifier extends StateNotifier<List<String>> {
  TagListNotifier() : super(['Flutter', 'Dart', 'Python', 'Java']);

  void addTag(String tag) {
    state = [...state, tag];
  }

  void removeTag(String tag) {
    state = [...state]..remove(tag);
  }
}

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();
  final communityBioController = TextEditingController();
  File? bannerFile;
  Uint8List? bannerWebFile;

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
    communityBioController.dispose();
  }

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: bannerFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Your Community Logo',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Pallete.mintColor,
          activeControlsWidgetColor: Pallete.tealColor,
          cropFrameColor: Pallete.mintColor,
          hideBottomControls: false,
          statusBarColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Your Community Logo',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        bannerFile = File(croppedFile.path);
      });
    }
  }

  void selectCommunityProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      }
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void createCommunity() {
    // check if community name is valid - no special characters, no capital letters , no emojis and no spaces in between

    if (communityNameController.text.contains(RegExp(r'[^\u0000-\u007F]'))) {
      showSnackBar(context, 'Community name cannot contain emojis');
      return;
    }
    if (communityNameController.text.contains(RegExp(r'[A-Z]'))) {
      showSnackBar(context, 'Community name cannot contain capital letters');
      return;
    }
    if (communityNameController.text.contains(RegExp(r'\s'))) {
      showSnackBar(context, 'Community name cannot contain spaces');
      return;
    }

    if (communityNameController.text.isNotEmpty &&
            communityBioController.text.isNotEmpty &&
            bannerFile != null ||
        bannerWebFile != null) {
      ref.read(communityControllerProvider.notifier).createCommunity(
            communityNameController.text.trim().toLowerCase(),
            communityBioController.text.trim(),
            bannerFile,
            bannerWebFile,
            ref.read(tagListProvider).toList(),
            context,
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final tags = ref.watch(tagListProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Create a community'),
      ),
      body: isLoading
          ? const Loader()
          : Responsive(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      // community photo and banner
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Community photo'),
                      ),
                      const SizedBox(height: 30),
                      DottedBorder(
                        color: Pallete.mintColor,
                        strokeWidth: 1,
                        dashPattern: const [5, 5],
                        borderType: BorderType.Rect,
                        radius: const Radius.circular(10),
                        child: InkWell(
                          onTap: selectCommunityProfileImage,
                          child: Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              // color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: bannerFile != null
                                ? Image.file(
                                    bannerFile!,
                                    fit: BoxFit.cover,
                                  )
                                : bannerWebFile != null
                                    ? Image.memory(
                                        bannerWebFile!,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.add_a_photo,
                                        // color: Colors.grey,
                                      ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: _cropImage,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.crop,
                            // color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      /// Community name
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Community name'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: communityNameController,
                        decoration: const InputDecoration(
                          hintText: 'r/Community_name',
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        maxLength: 21,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Bio of the community'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: communityBioController,
                        decoration: const InputDecoration(
                          hintText: 'About the community',
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        maxLength: 150,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Chosen tags for the community'),
                      ),
                      const SizedBox(height: 10),
                      if (tags.isNotEmpty)
                        Wrap(
                          spacing: 8.0, // spacing between tags
                          children: tags
                              .map((tag) => Chip(
                                    padding: const EdgeInsets.all(10),
                                    backgroundColor: Colors.blue,
                                    label: Text(
                                      tag,
                                      style: const TextStyle(
                                        // color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    onDeleted: () {
                                      ref
                                          .read(tagListProvider.notifier)
                                          .removeTag(tag);
                                    },
                                  ))
                              .toList(),
                          // add new tag button
                          // children: <Widget>[
                          //
                        ),
                      if (tags.isEmpty)
                        const SizedBox(
                          height: 50,
                          child: Center(
                            child: Text('No tags selected'),
                          ),
                        ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Select tags for the community'),
                      ),
                      const SizedBox(height: 10),
                      InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Wrap(
                          spacing: 8.0, // spacing between tags
                          verticalDirection: VerticalDirection.up,
                          children: Constants.tags.map((tag) {
                            final bool isSelected = tags.contains(tag);

                            return GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  ref
                                      .read(tagListProvider.notifier)
                                      .removeTag(tag);
                                } else {
                                  ref
                                      .read(tagListProvider.notifier)
                                      .addTag(tag);
                                }
                              },
                              child: Chip(
                                // labelPadding: const EdgeInsets.only(
                                //     left: 4.0, right: 4.0),\
                                padding: const EdgeInsets.all(10),
                                backgroundColor:
                                    isSelected ? Colors.green : Colors.black26,
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      tag,
                                      style: const TextStyle(
                                        // color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    if (isSelected)
                                      GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(tagListProvider.notifier)
                                              .removeTag(tag);
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          // color: Colors.white,
                                          size: 16.0,
                                        ),
                                      ),
                                    if (!isSelected)
                                      GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(tagListProvider.notifier)
                                              .removeTag(tag);
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          // color: Colors.white,
                                          size: 16.0,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: createCommunity,
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            // backgroundColor: Pall,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: const Text(
                          'Create community',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
