import 'dart:io';

import 'package:flutter/material.dart';

class AllPhotos extends StatefulWidget {
  final String details;
  const AllPhotos({Key? key, required this.details}) : super(key: key);

  @override
  State<AllPhotos> createState() => _AllPhotosState();
}

class _AllPhotosState extends State<AllPhotos> {
  @override
  Widget build(BuildContext context) {
    final File img = File(widget.details);
    final String name = widget.details.split(':').last;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Hero(
          tag: widget.details,
          child: Image.file(img),
        ),
      ),
    );
  }
}
