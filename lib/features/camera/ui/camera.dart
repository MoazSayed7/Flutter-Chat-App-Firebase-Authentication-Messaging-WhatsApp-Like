import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../helpers/extensions.dart';
import '../../../router/routes.dart';

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
        title: Text(
          context.tr('takePicture'),
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
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            context.pushNamed(Routes.displayPictureScreen,
                arguments: [image, '', '', '']);
          } catch (e) {
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
