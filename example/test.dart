

import 'package:dart_image_processing/dart_image_processing.dart';

void main() {
  U8Bitmap object = U8Bitmap('sampleImages/bridge.bmp');
  final imageArray = object.imread();

  // SpatialFiltering filterObj = SpatialFiltering();
  // var filteredImage = filterObj.simpleFilter(kernelSize: 5, image: imageArray);
  IntensityTransformation transform =
      IntensityTransformation(srcImage: imageArray);

  // var negativeImage = transform.negative(bpp: object.bitsPerPixel);
  // var logTransformedImage = transform.logTransformation(constant: 70);
  var gammaTransformedImage =
      transform.gammaTransformation(constant: 50, gammaConstant: .4);
  object.imwrite('outputs/output', gammaTransformedImage);
}
