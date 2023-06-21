import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImageView extends StatelessWidget {
  const ShowImageView({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
      ),
    );
  }
}
