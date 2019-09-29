import 'dart:io';

/// Class that is valid only for 8 bit
/// uncompressed bitmap images with endianness
/// of little endian
class U8Bitmap {
  ///raw bytes of bitmap image in decimal
  List<int> _rawBytes;

  ///header bytes of bitmap image in decimal
  List<int> _headerBytes;

  ///the offset where pixel data can be
  ///found
  int _offsetToPixel;

  ///absolute path to imagefile
  final String _imagePath;

  ///bits per pixel
  int _bpp;

  ///size of bitmap file in bytes
  int fileSize;

  ///width and height of bitmap image in pixel
  int imageWidth, imageHeight;

  U8Bitmap(this._imagePath) {
    _rawBytes = File(_imagePath).readAsBytesSync();

    fileSize = _findFileSize();
    _offsetToPixel = _findOffsetToPixel();
    _headerBytes = _findHeaderBytes();
    imageHeight = _findImageHeight();
    imageWidth = _findImageWidth();
    _bpp = _bytesToValue(_rawBytes.sublist(28, 30));
  }

  ///getter for bits per pixel
  get bitsPerPixel => _bpp;

  ///finds header bytes
  _findHeaderBytes() => _rawBytes.sublist(0, _offsetToPixel);

  ///finds fileSize
  int _findFileSize() => _bytesToValue(_rawBytes.sublist(2, 6));

  ///finds offset(in bytes) where the bitmap data
  ///can be found
  int _findOffsetToPixel() => _bytesToValue(_rawBytes.sublist(10, 14));

  ///finds height of image
  int _findImageHeight() => _bytesToValue(_rawBytes.sublist(22, 26));

  ///finds width of image
  int _findImageWidth() => _bytesToValue(_rawBytes.sublist(18, 22));

  ///- takes list of integers (0-255).
  ///number of integer in list represents
  ///number of bytes.
  ///- converts each byte to hex, concatenates each
  ///byte in reverse order and calculates decimal
  ///values
  int _bytesToValue(List<int> intBytes) {
    String _hexString = '';
    List<int> littleEndianOrder = List<int>(intBytes.length);
    littleEndianOrder = intBytes.reversed.toList();

    ///concatenates each byte of hex string
    ///to form a single hex string
    for (int each in littleEndianOrder) {
      _hexString += _properHex(each);
    }

    return int.parse(_hexString, radix: 16);
  }

  ///returns proper hex value with two
  ///character. if hex value is 'F' returns
  ///'0F'
  String _properHex(int integer) {
    String _hexString;
    _hexString = integer.toRadixString(16);
    return _hexString.length == 2 ? _hexString : '0$_hexString';
  }

  ///- returns image pixels in the form of list
  List<List<int>> imread() {
    List<List<int>> pixelMat = List<List<int>>(imageHeight);
    List<int> rowColumn = _rawBytes.sublist(
        _offsetToPixel, _offsetToPixel + (imageHeight * imageWidth));
    int commonIndex = 0;
    for (int height = imageHeight - 1; height >= 0; height--) {
      List<int> tempList = List<int>(imageWidth);
      for (int width = 0; width < imageWidth; width++) {
        tempList[width] = rowColumn[commonIndex];
        commonIndex++;
      }
      pixelMat[height] = tempList;
    }
    return pixelMat;
  }

  ///- takes image name and pixel list, writes image pixels
  ///   in the form of bitmap
  imwrite(String imageName, List<List<int>> image) {
    List<int> finalImage = List();
    List<List<int>> tempList = List(imageWidth);
    int indexCounter = 0;
    for (int height = imageHeight - 1; height >= 0; height--) {
      tempList[indexCounter] = image[height];
      indexCounter++;
    }
    for (int i = 0; i < imageHeight; i++) {
      for (int j = 0; j < imageWidth; j++) {
        finalImage.add(tempList[i][j]);
      }
    }
    finalImage = _headerBytes + finalImage;
    File('$imageName.bmp').writeAsBytesSync(finalImage);
  }
}
