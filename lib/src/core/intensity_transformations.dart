import 'dart:math';

import 'package:meta/meta.dart';

///- provides funcationalities for
///   - image negative (s = L-1-r)
///   - log transformation (s = c log(1+r))
///   - power-law (gamma) transformation (s = cr^gamma)
class IntensityTransformation {
  ///source image of type List<List<int>>
  final List<List<int>> srcImage;

  ///Constructor that take source image
  IntensityTransformation({@required this.srcImage});

  ///- takes bits per pixel and
  ///- returns image negative
  List<List<int>> negative({@required int bpp}) {
    List<List<int>> tempImage = List();

    ///populate list with garbage
    for (int i = 0; i < srcImage.length; i++) {
      List<int> tempImage1 = List();
      for (int j = 0; j < srcImage[0].length; j++) {
        tempImage1.add(j);
      }
      tempImage.add(tempImage1);
    }

    for (int i = 0; i < srcImage.length; i++) {
      for (int j = 0; j < srcImage[0].length; j++) {
        tempImage[i][j] = (pow(2, bpp) - 1 - srcImage[i][j]).abs();
      }
    }
    return tempImage;
  }

  ///returns log transformed image
  List<List<int>> logTransformation({@required int constant}) {
    List<List<int>> tempImage = List();

    ///populate list with garbage
    for (int i = 0; i < srcImage.length; i++) {
      List<int> tempImage1 = List();
      for (int j = 0; j < srcImage[0].length; j++) {
        tempImage1.add(j);
      }
      tempImage.add(tempImage1);
    }

    for (int i = 0; i < srcImage.length; i++) {
      for (int j = 0; j < srcImage[0].length; j++) {
        tempImage[i][j] = (constant * log(1 + srcImage[i][j]).round()).abs();
      }
    }
    return tempImage;
  }

  ///returns power-law transformed image
  List<List<int>> gammaTransformation(
      {@required int constant, @required double gammaConstant}) {
    List<List<int>> tempImage = List();

    ///populate list with garbage
    for (int i = 0; i < srcImage.length; i++) {
      List<int> tempImage1 = List();
      for (int j = 0; j < srcImage[0].length; j++) {
        tempImage1.add(j);
      }
      tempImage.add(tempImage1);
    }

    for (int i = 0; i < srcImage.length; i++) {
      for (int j = 0; j < srcImage[0].length; j++) {
        tempImage[i][j] =
            (constant * pow(srcImage[i][j], gammaConstant).round()).abs();
      }
    }
    return tempImage;
  }
}
