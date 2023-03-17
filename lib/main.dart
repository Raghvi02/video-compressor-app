
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_compressor/video_compressor.dart';
import 'package:untitled15/videocom.dart';
void main() {
  runApp(MyApp());
}
    class MyApp extends StatefulWidget {
      const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? fileVideo;
  Uint8List? thumbnailBytes;
  int? videosize;
  int? size;
  MediaInfo? compressedVideoInfo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
          backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('VIDEO COMPRESSOR', style: TextStyle(
          color: Colors.blueGrey,
          fontWeight:  FontWeight.bold,
        ),),
        centerTitle: true,
      ),
      body: Container(

        alignment: Alignment.center,
        padding: EdgeInsets.all(40),
        child: buildContent(),


      ),
        ),
    );
  }

  Widget buildContent() {
    if (fileVideo == null) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.black,

          ),

          onPressed: () {
        pickVideo();

      }, child: const Text('Pick Video',
      style: TextStyle(
        color: Colors.blueGrey,
        fontWeight: FontWeight.normal,
        fontSize: 30,
      ),));

    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildThumbnail(),
          SizedBox(height: 24,),
          buildVideoInfo(),
          SizedBox(height: 24,),
         // buildVideoCompressedInfo(),
          SizedBox(height: 24,),
          ElevatedButton(
    style: ElevatedButton.styleFrom(
    primary: Colors.black,
    ),
    onPressed:(){
              compressVideo();}, child: Text('Compress Video',
          style: TextStyle(
            fontSize: 25,
          ),),
          )

        ],
      );
    }
  }

  Widget buildThumbnail() =>
      thumbnailBytes == null
          ? CircularProgressIndicator()
          : Image.memory(thumbnailBytes!, height: 100,);

  Widget buildVideoInfo() =>
  videosize == null
  ? CircularProgressIndicator()
  : Text('$size KB', style: const TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  ),);
Widget buildVideoCompressedInfo(){
    if(compressedVideoInfo == null) {
      return Container(

    );
    }
    final size = compressedVideoInfo!.filesize! / 1000;
    return Column(
      children: [
        const Text('Compressed Video Info',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,color: Colors.black),),
        const SizedBox(height: 8,),
        Text('Size: $size KB',
          style: const TextStyle(fontSize: 20,
          color: Colors.black),),
        Text(
          '${compressedVideoInfo!.path}',
          style: const TextStyle(
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),

      ],
    );
}

  Future pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final file = File(pickedFile.path);
    setState(() => fileVideo = file);

    generateThumbnail(fileVideo!);
  }

  Future generateThumbnail(File file) async {
    final thumbnailBytes = await VideoCompressor.getByteThumbnail(file.path);
    setState(() => this.thumbnailBytes = thumbnailBytes);
  }

  Future getVideoSize(File file) async {
    final size = await file.length();

    setState(() => this.size = videosize);
  }

  Future compressVideo() async {
    final info = await VideoCompressorApi.compressVideo(fileVideo!);
    setState(() => compressedVideoInfo = info);
    Navigator.of(context).pop();
  }
}