import 'package:flutter/material.dart';
import '../constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: const Center(
        child: CircularProgressIndicator(
          color: kBlueColor,
        ),
      ),
    );
  }
}
