import 'package:flutter/material.dart';
import 'package:singularity/Screens/Home/intro.dart';
import 'package:singularity/Screens/Library/downloads.dart';
import 'package:singularity/Screens/Library/nowplaying.dart';
import 'package:singularity/Screens/Library/playlists.dart';
import 'package:singularity/Screens/Library/recent.dart';
import 'package:singularity/Screens/Library/stats.dart';
import 'package:singularity/Screens/Settings/new_settings_page.dart';

Widget initialFuntion() {
  return const IntroScreen();
}

final Map<String, Widget Function(BuildContext)> namedRoutes = {
  '/': (context) => initialFuntion(),
  '/setting': (context) => const NewSettingsPage(),
  '/playlists': (context) => PlaylistScreen(),
  '/nowplaying': (context) => NowPlaying(),
  '/recent': (context) => RecentlyPlayed(),
  '/downloads': (context) => const Downloads(),
  '/stats': (context) => const Stats(),
};
