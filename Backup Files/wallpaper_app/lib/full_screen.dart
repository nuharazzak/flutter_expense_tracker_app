import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullScreen extends StatefulWidget {
  const FullScreen({
    super.key,
    required this.imageUrl,
  });
  final String imageUrl;

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  // Future<void> setWallpaper() async {
  //   int location = WallpaperManager.HOME_SCREEN;
  //   var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
  //   String result =
  //       await WallpaperManager.setWallpaperFromFile(file.path, location)
  //           .toString();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Image.network(widget.imageUrl),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Set as wallpaper'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
