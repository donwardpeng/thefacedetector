// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;
import 'dart:math';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

enum Detector { barcode, face, label, cloudLabel, text, cloudText }

/* FaceDetectPainter class to draw a rectangle on the screen when a face is found */
class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces);

  final Size absoluteImageSize;
  final List<Face> faces;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = scaleX;
    final double yShift = size.height / 2 -
        (((absoluteImageSize.width / absoluteImageSize.aspectRatio) * scaleY) /
            2);
    //size.height / absoluteImageSize.height;

    final Paint redLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    final Paint blackLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..color = Colors.black54;

    for (Face face in faces) {
      Offset baseOfNose = face.getLandmark(FaceLandmarkType.noseBase).position;
      double baseOfNoseYShifted = baseOfNose.dy * scaleY + yShift;
      double baseOfNoseXShifted = baseOfNose.dx * scaleX;
      double bottomOfFaceShifted = face.boundingBox.bottom * scaleY + yShift;
      double rightSideOfFaceShifted = face.boundingBox.right * scaleX;
      double leftSideOfFaceShifted = face.boundingBox.left * scaleX;

      double rightThirdX = (rightSideOfFaceShifted - baseOfNoseXShifted) / 3.0;
      double leftThirdX = (baseOfNoseXShifted - leftSideOfFaceShifted) / 3.0;
      double thirdY = (bottomOfFaceShifted - baseOfNoseYShifted) / 3.0;

      // Arc 1 is the first arc of the mustache from the nose to the right
      Rect rightArc1BoundingBox = Rect.fromLTRB(baseOfNoseXShifted, baseOfNoseYShifted,
          baseOfNoseXShifted + (2 * rightThirdX), baseOfNoseYShifted + thirdY);

      canvas.drawArc(
          rightArc1BoundingBox,
          (0),
          (pi),
          false,
          blackLine);

      // Arc 1 is the first arc of the mustache from the nose to the right
      Rect leftArc1BoundingBox = Rect.fromLTRB(baseOfNoseXShifted - (leftThirdX * 2), baseOfNoseYShifted,
          baseOfNoseXShifted, baseOfNoseYShifted + thirdY);

      canvas.drawArc(
          leftArc1BoundingBox,
          (0),
          (pi),
          false,
          blackLine);


          // Offset baseOfNoseShifted = Offset(baseOfNoseXShifted, baseOfNoseYShifted);
//      double topOfRectForArc = baseOfNoseYShifted -
//          ((face.boundingBox.bottom * scaleY + yShift) - baseOfNoseYShifted) /
//              2;
//      double bottomOfRectForArc = face.boundingBox.bottom * scaleY +
//          yShift -
//          ((face.boundingBox.bottom * scaleY + yShift) - baseOfNoseYShifted) /
//              2;
//      canvas.drawArc(
//          Rect.fromLTRB(
//              baseOfNoseXShifted,
//              topOfRectForArc,
//              face.boundingBox.right * scaleX,
//              bottomOfRectForArc),
//          (0.5 * pi),
//          (0.5 * pi),
//          false,
//          blackLine);


      canvas.drawRect(
        Rect.fromLTRB(
          face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY + yShift,
          face.boundingBox.right * scaleX,
          face.boundingBox.bottom * scaleY + yShift,
        ),
        redLine,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
