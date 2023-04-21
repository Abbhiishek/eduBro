import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/core/common/error_text.dart';
import 'package:sensei/core/common/loader.dart';
import 'package:sensei/core/utlis.dart';
import 'package:sensei/features/community/controller/community_controller.dart';
import 'package:sensei/features/post/controller/post_controller.dart';
import 'package:sensei/models/community_model.dart';
import 'package:sensei/responsive/responsive.dart';
import 'package:sensei/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  Uint8List? bannerWebFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async {
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

    if (bannerFile != null) {
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: bannerFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio4x3
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Your Post Image',
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

  void sharePost() {
    if (widget.type == 'image' &&
        (bannerFile != null || bannerWebFile != null) &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
            webFile: bannerWebFile,
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);
    final currentTheme = Theme.of(context);

    final ispartcommunities = ref.watch(userCommunitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Responsive(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ref.watch(userCommunitiesProvider).when(
                                data: (data) {
                                  communities = data;

                                  if (data.isEmpty) {
                                    return const SizedBox();
                                  }

                                  return DropdownButton(
                                    underline: Container(),
                                    borderRadius: BorderRadius.circular(23),
                                    value: selectedCommunity ?? data[0],
                                    items: data
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  const SizedBox(height: 30),
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage:
                                                        NetworkImage(e.avatar),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(e.name),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        selectedCommunity = val;
                                      });
                                    },
                                  );
                                },
                                error: (error, stackTrace) => ErrorText(
                                  error: error.toString(),
                                ),
                                loading: () => const Loader(),
                              ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter Title here',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(18),
                          ),
                          maxLength: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isTypeImage)
                        GestureDetector(
                          onTap: selectBannerImage,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            color: Colors.amberAccent,
                            child: Container(
                              width: double.infinity,
                              // height: ,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: bannerWebFile != null
                                  ? Image.memory(bannerWebFile!)
                                  : bannerFile != null
                                      ? Image.file(bannerFile!)
                                      : const Center(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                          ),
                                        ),
                            ),
                          ),
                        ),
                      if (isTypeImage) const SizedBox(height: 10),
                      if (bannerFile != null || bannerWebFile != null)
                        InkWell(
                          onTap: _cropImage,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.crop,
                              // color: Colors.grey,
                            ),
                          ),
                        ),
                      if (isTypeText)
                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter Description here',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(18),
                          ),
                          maxLines: 5,
                        ),
                      if (isTypeLink)
                        TextField(
                          controller: linkController,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter link here',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(18),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: !ispartcommunities.hasValue
          ? null
          : FloatingActionButton(
              onPressed: () =>
                  Routemaster.of(context).push('/create-community'),
              child: const Icon(Icons.group_add),
            ),
    );
  }
}
