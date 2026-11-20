# Online audio from a YouTube URL

## Current boundary

- `YoutubeVideoUrl.parse` accepts a single video URL and extracts its ID. It rejects unrelated hosts and playlist-only URLs.
- `YoutubeAudioAdapter` resolves metadata and a short-lived audio URI on demand. The URI exists only in memory and is not written to Hive.
- `OnlineAudioHandler` owns a separate one-item queue and `AudioPlayer`. `OnlineAudioController` exposes page state, retries resolution once after a player error, and preserves the seek position for that retry.
- `CoordinatedAudioHandler` is the only `AudioService.init` entry point. It pauses the other source on activation and forwards active media, state and headset controls to the system. The existing offline handler remains the offline feature provider.
- Online is its own bottom tab and page. The shell mini player reads the active source and navigates to the matching page.

## Source limitations

YouTube's developer policies prohibit isolating audio from audiovisual content and background playback through its API services. The official policy guide explicitly lists audio extraction and background playback as prohibited examples. Personal use does not change those terms. A reverse-engineered source adapter may fail when YouTube changes delivery or access rules; video availability, region restrictions, authentication and expiring stream URLs are additional failure cases. No audio stream URL should be persisted.

Sources: https://developers.google.com/youtube/terms/developer-policies and https://developers.google.com/youtube/terms/developer-policies-guide

## Verification

The one-byte Range probe is disabled by default because it may consume a one-use stream URL. Enable only with `--dart-define=ONLINE_AUDIO_PROBE=true`; it logs status, elapsed time, stream tag/type, header names and relative expiry, never signed URLs or header values. On device, video `K6rrVCFGAE8` returned HTTP 206 to the probe in 32 ms with about six hours until expiry, followed by ExoPlayer HTTP 403. This proves that the URL was initially usable, but does not yet prove whether the probe caused the next request to fail or whether ExoPlayer's request differs.

URL parsing passed local assertions for watch and short URLs, rejected lookalike hosts and playlist-only URLs. The owner ran `dart pub get` successfully, fetching `youtube_explode_dart 3.1.0`. `dart analyze lib` then passed with no errors or warnings (45 existing style/deprecation info notices). Metadata resolution, playback while locked, headset controls, expiry recovery and offline regression all require a device; none have been verified yet. The package README's `withHigestBitrate` helper is absent from 3.1.0, so the adapter selects the highest bitrate using `Bitrate.compareTo`.
