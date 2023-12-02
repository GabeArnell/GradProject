import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:thrift_exchange/constants/global_variables.dart';

class TempImage {
  final String name;
  final Uint8List bytes;
  const TempImage(
    this.name, this.bytes
  );
}