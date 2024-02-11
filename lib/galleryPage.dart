import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late Future<List<String>> futureImages;


  @override
  void initState() {
    super.initState();
    futureImages = fetchImages();
  }

  Future<List<String>> fetchImages() async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      print('Fetching images for user: $uid');

      ListResult result = await FirebaseStorage.instance.ref('images/$uid').listAll();

      List<String> urls = [];
      for (var item in result.items) {
        String url = await item.getDownloadURL();
        urls.add(url);
      }

      print('Fetched ${urls.length} images');
      print('Image URLs: $urls');
      return urls;
    } catch (e) {
      print('fetchImages error: $e');
      return [];
    }
  }
  Future<void> _saveImage(BuildContext context, String imageUrl) async {
    var response = await http.readBytes(Uri.parse(imageUrl));
    final result = await ImageGallerySaver.saveImage(response);
    print(result);

    // ModalBottomSheet'i kapat
    Navigator.pop(context);
    // "İndirildi" bildirimini göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('İndirildi')),
    );
  }

  void _onImageTap(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.network(imageUrl),
      ),
    );
  }

  void _onImageLongPress(String imageUrl) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Sil'),
            onTap: () async {
              // Firebase Storage'dan fotoğrafı sil
              await FirebaseStorage.instance.refFromURL(imageUrl).delete();
              // ModalBottomSheet'i kapat
              Navigator.pop(context);
              // Fotoğrafları tekrar yükle
              setState(() {
                futureImages = fetchImages();
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text('İndir'),
            onTap: () {
              _saveImage(context, imageUrl);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 40, 39, 81),
        iconTheme: IconThemeData(color: Colors.white, size: 48),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 81),
      body: FutureBuilder<List<String>>(
        future: futureImages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          } else {
            final List<String> images = snapshot.data!;
            if (images.isEmpty) {
              return Center(child: Text('Hiç resim yok.', style: TextStyle(color: Colors.white)));
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onImageTap(images[index]),
                    onLongPress: () => _onImageLongPress(images[index]),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: GridTile(
                        child: Image.network(images[index], fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text('Resim yüklenemedi.', style: TextStyle(color: Colors.white)));
                        }),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}