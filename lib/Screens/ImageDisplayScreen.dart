import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageDisplayScreen extends StatefulWidget {
  final String imageName; // Pass an identifier (e.g., image name) to fetch the image URL

  ImageDisplayScreen({required this.imageName}); // Constructor with named parameter

  @override
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  late String imageUrl;

  // Initialize Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    // Fetch the image URL when the widget is initialized
    fetchImageUrl();
  }

  Future<void> fetchImageUrl() async {
    try {
      imageUrl = await downloadURL(widget.imageName);
      setState(() {});
    } catch (e) {
      print('Error fetching image URL: $e');
      // Handle the error as needed
    }
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage
        .ref('Live_Images/$imageName')
        .getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Display'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the image if the URL is available
            imageUrl != null
                ? Image.network(
              imageUrl,
              width: 300,
              height: 300,
            )
                : CircularProgressIndicator(), // Display a loading indicator while fetching URL
          ],
        ),
      ),
    );
  }
}
