class YoutubeVideoUrl {
  const YoutubeVideoUrl._(this.videoId);

  final String videoId;

  static YoutubeVideoUrl? parse(String input) {
    final uri = Uri.tryParse(input.trim());
    if (uri == null || !{'https', 'http'}.contains(uri.scheme)) return null;
    final host = uri.host.toLowerCase();
    final segments = uri.pathSegments;
    String? id;
    if (host == 'youtu.be' || host == 'www.youtu.be') {
      id = segments.isEmpty ? null : segments.first;
    } else if ({
      'youtube.com',
      'www.youtube.com',
      'm.youtube.com',
      'music.youtube.com',
    }.contains(host)) {
      if (uri.path == '/watch') {
        id = uri.queryParameters['v'];
      } else if (segments.length == 2 &&
          {'shorts', 'live', 'embed'}.contains(segments.first)) {
        id = segments.last;
      }
    }
    if (id == null || !RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(id)) {
      return null;
    }
    return YoutubeVideoUrl._(id);
  }
}
