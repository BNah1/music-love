import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musiclove/core/constant/app_assets.dart';
import 'package:musiclove/core/constant/app_config.dart';
import 'package:musiclove/core/constant/app_path.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/widget/custom_textfield_widget.dart';
import 'package:musiclove/core/widget/tab_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    EasyLocalization.logger.enableLevels = [];
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppConfig Constants', () {
    test('provides required app configuration and locales', () {
      expect(AppConfig.appName, isNotEmpty);
      expect(AppConfig.defaultLocale, const Locale('vi'));
      expect(AppConfig.fallbackLocale, const Locale('vi'));
      expect(
        AppConfig.supportedLocales,
        containsAll([const Locale('vi'), const Locale('en')]),
      );
      expect(AppConfig.boxSongs, 'songs');
      expect(AppConfig.boxPlaylists, 'playlists');
      expect(AppConfig.boxSettings, 'settings');
      expect(AppConfig.androidNotificationChannelId, isNotEmpty);
      expect(AppConfig.androidNotificationChannelName, isNotEmpty);
    });
  });

  group('AppAssets and AppPath Constants', () {
    test('defines valid asset paths and backward compatibility', () {
      expect(AppAssets.nextButton, 'assets/icons/next_button.svg');
      expect(AppAssets.backButton, 'assets/icons/back_button.svg');
      expect(AppAssets.pauseButton, 'assets/icons/pause_button.svg');
      expect(AppAssets.playButton, 'assets/icons/play_button.svg');
      expect(AppAssets.translationVi, 'assets/translation/vi.json');
      expect(AppAssets.translationEn, 'assets/translation/en.json');
      expect(AppAssets.translationDir, 'assets/translation');
      expect(AppAssets.playMusicIcons.length, 4);

      // AppPath compatibility
      expect(AppPath.playMusicIcon, AppAssets.playMusicIcons);
    });
  });

  group('AppString Constants', () {
    test('defines required translation keys and music tab keys', () {
      expect(AppString.appName, 'app_name');
      expect(AppString.tabHome, 'tab_home');
      expect(AppString.tabLibrary, 'tab_library');
      expect(AppString.tabSettings, 'tab_settings');
      expect(AppString.tabSongs, 'tab_songs');
      expect(AppString.tabPlaylists, 'tab_playlists');
      expect(AppString.homeGreeting, 'home_greeting');
      expect(AppString.playlistSongsCount, 'playlist_songs_count');
      expect(AppString.settingsLanguage, 'settings_language');
      expect(AppString.errorOpenSong, 'error_open_song');
    });
  });

  group('Widgets and FIX verification', () {
    testWidgets('CustomTextFieldWidget displays errorText when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextFieldWidget(
              hintText: 'Enter name',
              controller: TextEditingController(),
              onToggleObscure: () {},
              errorText: 'Tên không hợp lệ',
            ),
          ),
        ),
      );

      expect(find.text('Tên không hợp lệ'), findsOneWidget);
      expect(find.text('error'), findsNothing);
    });
  });

  group('EasyLocalization Service & UI Integration', () {
    final viJson = json.encode({
      AppString.settingsTitle: 'Cài đặt',
      AppString.homeGreeting: 'Chào! 🌸🌸🌸',
      AppString.tabSongs: 'Bài hát',
      AppString.tabPlaylists: 'Danh sách phát',
      AppString.playlistSongsCount: '{count} bài hát',
      AppString.errorOpenSong: 'Lỗi mở bài hát: {error}',
    });
    final enJson = json.encode({
      AppString.settingsTitle: 'Settings',
      AppString.homeGreeting: 'Hello! 🌸🌸🌸',
      AppString.tabSongs: 'Songs',
      AppString.tabPlaylists: 'Playlists',
      AppString.playlistSongsCount: '{count} songs',
      AppString.errorOpenSong: 'Error opening song: {error}',
    });

    final mockAssetBundle = TestAssetBundle({
      'assets/translation/vi.json': viJson,
      'assets/translation/en.json': enJson,
    });

    Widget buildLocalizedApp({
      required Widget child,
      Locale locale = const Locale('vi'),
    }) {
      return DefaultAssetBundle(
        bundle: mockAssetBundle,
        child: EasyLocalization(
          key: UniqueKey(),
          supportedLocales: AppConfig.supportedLocales,
          path: AppAssets.translationDir,
          fallbackLocale: AppConfig.fallbackLocale,
          startLocale: locale,
          saveLocale: false,
          useOnlyLangCode: true,
          child: Builder(
            builder: (context) {
              return MaterialApp(
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                home: child,
              );
            },
          ),
        ),
      );
    }

    testWidgets(
      'Translates keys, interpolates namedArgs, and updates TabBarWidget on locale switch',
      (tester) async {
        await tester.pumpWidget(
          buildLocalizedApp(
            child: DefaultTabController(
              length: 2,
              child: Builder(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(48),
                        child: TabBarWidget(
                          tabController: DefaultTabController.of(context),
                        ),
                      ),
                    ),
                    body: Column(
                      children: [
                        Text(context.tr(AppString.settingsTitle)),
                        Text(
                          context.tr(
                            AppString.playlistSongsCount,
                            namedArgs: {'count': '5'},
                          ),
                        ),
                        Text(
                          AppString.errorOpenSong.tr(
                            namedArgs: {'error': 'File corrupted'},
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await context.setLocale(const Locale('en'));
                          },
                          child: const Text('Switch to English'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initial Vietnamese assertions
        expect(find.text('Cài đặt'), findsOneWidget);
        expect(find.text('5 bài hát'), findsOneWidget);
        expect(find.text('Lỗi mở bài hát: File corrupted'), findsOneWidget);
        expect(find.text('Bài hát'), findsOneWidget);
        expect(find.text('Danh sách phát'), findsOneWidget);
        expect(find.text('Payment'), findsNothing);
        expect(find.text('InCome'), findsNothing);

        // Switch locale to English
        await tester.tap(find.text('Switch to English'));
        await tester.pumpAndSettle();

        // English assertions
        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('5 songs'), findsOneWidget);
        expect(find.text('Error opening song: File corrupted'), findsOneWidget);
        expect(find.text('Songs'), findsOneWidget);
        expect(find.text('Playlists'), findsOneWidget);
        expect(find.text('Payment'), findsNothing);
        expect(find.text('InCome'), findsNothing);
      },
    );
  });
}

class TestAssetBundle extends CachingAssetBundle {
  final Map<String, String> stringAssets;

  TestAssetBundle(this.stringAssets);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final asset = stringAssets[key];
    if (asset != null) {
      return asset;
    }
    throw FlutterError('Unable to load asset: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    final asset = stringAssets[key];
    if (asset != null) {
      final encoded = utf8.encode(asset);
      return ByteData.view(Uint8List.fromList(encoded).buffer);
    }
    throw FlutterError('Unable to load asset: $key');
  }
}
