import 'package:flutter/material.dart';

import '../../domain/entities/color_loader_3.dart';

class DefaultLoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: ColorLoader3(
          radius: 20.0,
          dotRadius: 5.0,
        ));
  }
}