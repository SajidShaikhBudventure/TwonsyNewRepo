

import 'package:flutter_native_image/flutter_native_image.dart';

class ImageUtils {



static Future<ImageProperties> getPropertyImage(String path) async{
   ImageProperties properties = await FlutterNativeImage.getImageProperties(path);

return  properties;

}

}