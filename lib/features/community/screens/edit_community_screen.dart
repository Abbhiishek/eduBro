import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sensei/core/common/error_text.dart';
import 'package:sensei/core/common/loader.dart';
import 'package:sensei/core/constants/constants.dart';
import 'package:sensei/core/utlis.dart';
import 'package:sensei/features/community/controller/community_controller.dart';

import 'package:sensei/models/community_model.dart';
import 'package:sensei/responsive/responsive.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

  late TextEditingController communityNameController;
  late TextEditingController communityBioController;

  @override
  void initState() {
    super.initState();
    communityNameController = TextEditingController(
      text: ref.read(getCommunityByNameProvider(widget.name)).value?.name,
    );
    communityBioController = TextEditingController(
      text: ref.read(getCommunityByNameProvider(widget.name)).value?.bio,
    );
  }

  // void addTag(String tag) {
  //   ref.read(TagsProvider.notifier).addTag(tag);
  // }

  // void removeTag(String tag) {
  //   ref.read(TagsProvider.notifier).removeTag(tag);
  // }

  Future<void> _cropBannerImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: bannerFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio7x5,
      ],
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio3x2,
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

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }

    if (res != null) {
      setState(() {
        _cropBannerImage();
      });
    }
  }

  Future<void> _cropProfileImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: profileFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Your Profile Picture',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
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
        profileFile = File(croppedFile.path);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }

    if (profileFile != null) {
      _cropProfileImage();
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          community: community,
          profileWebFile: profileWebFile,
          bannerWebFile: bannerWebFile,
          bio: communityBioController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            // backgroundColor: currentTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit Community'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => save(community),
                  child: const Text('Save'),
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
                            SizedBox(
                              height: 250,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: selectBannerImage,
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      dashPattern: const [10, 4],
                                      strokeCap: StrokeCap.round,
                                      color: Colors.indigo,
                                      child: Container(
                                        width: double.infinity,
                                        height: 190,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: bannerWebFile != null
                                            ? Image.memory(bannerWebFile!)
                                            : bannerFile != null
                                                ? Image.file(
                                                    bannerFile!,
                                                    fit: BoxFit.fitWidth,
                                                  )
                                                : community.banner.isEmpty &&
                                                        community.banner ==
                                                            Constants
                                                                .bannerDefault
                                                    ? const Center(
                                                        child: Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          size: 40,
                                                        ),
                                                      )
                                                    : Image.network(
                                                        community.banner,
                                                        fit: BoxFit.cover,
                                                      ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 20,
                                    child: GestureDetector(
                                      onTap: selectProfileImage,
                                      child: profileWebFile != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  MemoryImage(profileWebFile!),
                                              radius: 60,
                                            )
                                          : profileFile != null
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      FileImage(profileFile!),
                                                  radius: 60,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      community.avatar),
                                                  radius: 60,
                                                ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: communityNameController,
                              // initialValue: community.name,
                              decoration: const InputDecoration(
                                labelText: 'Community Name',
                                border: OutlineInputBorder(),
                                enabled: false,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: communityBioController,
                              // initialValue: community.bio,
                              decoration: const InputDecoration(
                                labelText: 'Community Bio',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // *** tags widget
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text('Chosen tags for the community'),
                            ),
                            const SizedBox(height: 10),
                            if (community.tags.isNotEmpty)
                              Wrap(
                                spacing: 8.0, // spacing between tags
                                children: community.tags
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
                                            // ref
                                            //     .read(community.tags.notifier)
                                            //     .removeTag(tag);
                                          },
                                        ))
                                    .toList(),
                                // add new tag button
                                // children: <Widget>[
                                //
                              ),
                            if (community.tags.isEmpty)
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
                                  final bool isSelected =
                                      community.tags.contains(tag);

                                  return GestureDetector(
                                    onTap: () {
                                      if (isSelected) {
                                        // ref
                                        //     .read(tagListProvider.notifier)
                                        //     .removeTag(tag);
                                      } else {
                                        // ref
                                        //     .read(tagListProvider.notifier)
                                        //     .addTag(tag);
                                      }
                                    },
                                    child: Chip(
                                      // labelPadding: const EdgeInsets.only(
                                      //     left: 4.0, right: 4.0),\
                                      padding: const EdgeInsets.all(10),
                                      backgroundColor: isSelected
                                          ? Colors.green
                                          : Colors.black26,
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
                                                // ref
                                                //     .read(tagListProvider
                                                //         .notifier)
                                                //     .removeTag(tag);
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
                                                // ref
                                                //     .read(tagListProvider
                                                //         .notifier)
                                                //     .removeTag(tag);
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
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
        );
  }
}
