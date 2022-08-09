import 'dart:io';

import 'package:camera_gallery/all_photos.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

ValueNotifier<List> imgs = ValueNotifier([]);

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Zedge',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (() {
              pickPhotos();
            }),
            icon: const Icon(
              Icons.camera_alt_outlined,
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 52, 49, 49),
        child: ValueListenableBuilder(
          valueListenable: imgs,
          builder: (
            BuildContext context,
            List data,
            Widget? child,
          ) {
            return GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (BuildContext context, index) {
                final String imgPath = data[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AllPhotos(
                          details: imgPath,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: index,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(
                            File(
                              data[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

pickPhotos() async {
  final img = await ImagePicker().pickImage(
    source: ImageSource.camera,
  );
  if (img == null) {
    return;
  } else {
    var directory = await getExternalStorageDirectory();
    File imgPath = File(img.path);
    final newPhoto = await imgPath.copy(
      '${directory!.path}/${DateTime.now()}.jpg',
    );
    imgs.value.add(newPhoto.path);
    imgs.notifyListeners();
  }
}

listCreation() async {
  final directory = await getExternalStorageDirectory();
  if (directory != null) {
    var directList = await directory.list().toList();
    for (var i = 0; i < directList.length; i++) {
      if (directList[i].path.endsWith('.jpg')) {
        imgs.value.add(directList[i].path);
      }
    }
  }
  imgs.notifyListeners();
}
