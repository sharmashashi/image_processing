import 'package:meta/meta.dart';

///- spatial filtering using different kernels
class SpatialFiltering {
  ///to filter and return an image

  List<List<int>> simpleFilter(
      {@required List<List<int>> image, @required int kernelSize}) {
    int imageHeight = image.length, imageWidth = image[0].length;

    ///to store filtered pixels
    List<List<int>> filteredImage = List();

    ///populate list with garbage
    for (int i = 0; i < image.length; i++) {
      List<int> tempImage1 = List();
      for (int j = 0; j < image[0].length; j++) {
        tempImage1.add(j);
      }
      filteredImage.add(tempImage1);
    }

    ///visit each pixel and find the average value for it
    ///excluding border pixels
    for (int i = 0; i < imageHeight; i++) {
      for (int j = 0; j < imageWidth; j++) {
        filteredImage[i][j] = _pixelAverage(
            image: image,
            i: i,
            j: j,
            kernelSize: kernelSize,
            imageHeight: imageHeight,
            imageWidth: imageWidth);
      }
    }
    return filteredImage;
  }

  ///calculates average of neighbour pixels
  ///default order of kernel matrix is 3x3
  int _pixelAverage(
      {List<List<int>> image,
      int i,
      int j,
      int kernelSize,
      int imageHeight,
      int imageWidth}) {
    int pixel = 0;

    ///if pixels can't be covered with given,
    /// kernel matrix set as border
    if (i <= (kernelSize ~/ 2) - 1 ||
        i >= imageHeight - kernelSize ~/ 2 ||
        j <= (kernelSize ~/ 2) - 1 ||
        j >= imageWidth - kernelSize ~/ 2) {
      ///do nothing
    }

    ///else calculate average pixel
    ///with give kernel size
    else {
      int minIndexDiff = kernelSize ~/ 2;
      for (int p = i - minIndexDiff; p <= i + minIndexDiff; p++) {
        for (int q = j - minIndexDiff; q <= j + minIndexDiff; q++) {
          pixel += (image[p][q]).round();
        }
      }

      ///divide to calculate average
      pixel = (pixel / (kernelSize * kernelSize)).round();
    }
    return pixel;
  }
}
