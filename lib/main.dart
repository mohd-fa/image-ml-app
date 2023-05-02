import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chily Classifier',
        theme: ThemeData(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    textStyle: const MaterialStatePropertyAll(TextStyle(
                      fontSize: 20,
                    )),
                    padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
                    fixedSize:
                        MaterialStateProperty.all(const Size.fromWidth(300)))),
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: const Color.fromARGB(255, 255, 240, 222)),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? image;

  showPermAlert() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Permission Denied.");
  }

  Future camImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } catch (e) {
      showPermAlert();
    }
  }

  Future galImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } catch (e) {
      showPermAlert();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chilly Classifier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image != null
                ? ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 500),
                    child: Image.file(image!))
                : Image.asset("assets/logo.png"),
            Column(
              children: [
                image == null
                    ? ElevatedButton.icon(
                        onPressed: camImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Capture Image'))
                    : ElevatedButton.icon(
                        onPressed: () {
                          setState(() => image = null);
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel selection'),
                      ),
                const SizedBox(height: 10),
                image == null
                    ? ElevatedButton.icon(
                        style: const ButtonStyle(),
                        onPressed: galImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Image from Gallery'))
                    : ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.check_circle_rounded),
                        label: const Text('Submit')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
