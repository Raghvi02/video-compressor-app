import 'package:video_compressor/video_compressor.dart';
import 'dart:io';


class VideoCompressorApi{
  static Future<MediaInfo?> compressVideo (File file) async{

  try{
    return VideoCompressor.compressVideo(
      file.path,
      includeAudio: true,
    );

  }catch(e){
    VideoCompressor.cancelCompression();
  }

  }

}