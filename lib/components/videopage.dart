import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:limanplatform/components/videocard.dart';
import 'package:limanplatform/constants.dart';
import 'package:limanplatform/dao/videoitem.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final List<videoitem> _videos = Constants.videos;
  List<videoitem> _filteredVideos = Constants.videos;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVideos = _videos.where((video) {
        final titleTranslated = video.title.tr().toLowerCase();
        final q = query.toLowerCase();
        return titleTranslated.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('videos'.tr()),
        backgroundColor: Constants.primary,
        foregroundColor: Constants.background,
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search videos...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Constants.primary, // custom icon color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Constants
                        .primary, // custom border color when not focused
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color:
                        Constants.primary, // custom border color when focused
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          // --- Video List ---
          Expanded(
            child: _filteredVideos.isEmpty
                ? Center(child: Text("novideo".tr()))
                : ListView.builder(
                    itemCount: _filteredVideos.length,
                    itemBuilder: (context, index) {
                      return VideoCard(video: _filteredVideos[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
