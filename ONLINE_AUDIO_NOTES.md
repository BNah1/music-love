# Online audio from a YouTube URL

## Current boundary

- `YoutubeVideoUrl.parse` accepts a single video URL and extracts its ID. It rejects unrelated hosts and playlist-only URLs.
- On Android, `YoutubeAudioAdapter` calls the local `audio_ytb_pluggin` bridge to NewPipeExtractor for metadata and a short-lived audio URI. The URI exists only in memory and is not written to Hive. Other platforms return an explicit unsupported error.
- `OnlineAudioHandler` owns a separate one-item queue and `AudioPlayer`. `OnlineAudioController` exposes page state, retries native resolution once after a player error, and preserves the seek position for that retry.
- `CoordinatedAudioHandler` is the only `AudioService.init` entry point. It pauses the other source on activation and forwards active media, state and headset controls to the system. The existing offline handler remains the offline feature provider.
- Online is its own bottom tab and page. The shell mini player reads the active source and navigates to the matching page.

## Source limitations

YouTube's developer policies prohibit isolating audio from audiovisual content and background playback through its API services. The official policy guide explicitly lists audio extraction and background playback as prohibited examples. Personal use does not change those terms. A reverse-engineered source adapter may fail when YouTube changes delivery or access rules; video availability, region restrictions, authentication and expiring stream URLs are additional failure cases. No audio stream URL should be persisted.

Sources: https://developers.google.com/youtube/terms/developer-policies and https://developers.google.com/youtube/terms/developer-policies-guide

## Verification

URL parsing passed local assertions for watch and short URLs, rejected lookalike hosts and playlist-only URLs. The owner confirmed single-video playback through the Android native plugin. Background controls, expiry recovery and offline regression still need device verification. The earlier Dart extractor and its one-byte Range probe were removed after its selected streams returned HTTP 403 in ExoPlayer; the Android source now uses NewPipeExtractor exclusively.
