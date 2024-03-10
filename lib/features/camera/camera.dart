import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../helpers/extensions.dart';
import '../../router/routes.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final XFile image;
  const DisplayPictureScreen({super.key, required this.image});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final logger = Logger();

  late IconData icon = Icons.save_alt_rounded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display the Picture'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // To save the image
          final String filename = widget.image.name;
          await widget.image
              .saveTo('/storage/emulated/0/DCIM/Camera/$filename');
          icon = Icons.check_rounded;
          setState(() {});
        },
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SizedBox(
        height: double.infinity,
        child: Image.file(
          File(widget.image.path),
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription firstCamera;
  const TakePictureScreen({
    super.key,
    required this.firstCamera,
  });
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Take a picture',
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            if (!context.mounted) return;

            await context.pushNamed(Routes.displayPictureScreen,
                arguments: image);
          } catch (e) {
            // If an error occurs, log the error to the console.
            logger.e(e);
          }
        },
        child: const Icon(
          Icons.camera_alt,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _controller = CameraController(
      widget.firstCamera,
      ResolutionPreset.max,
    );

    _initializeControllerFuture = _controller.initialize();
  }
}
