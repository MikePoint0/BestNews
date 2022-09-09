import 'package:flutter/material.dart';

Widget NoConnectionWidget() {
  return const Center(
      child: SizedBox(
        height: 500,
        width:350,
        child: Text("No Connection", style: TextStyle(color: Colors.white)),
      )
  );
}