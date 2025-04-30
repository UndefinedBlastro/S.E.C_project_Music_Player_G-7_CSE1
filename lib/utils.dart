import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:singularity/APIs/api.dart';
import 'package:singularity/Screens/Search/albums.dart';
import 'package:singularity/Screens/Search/artists.dart';

Future<void> navigateToArtistPage(
  BuildContext context, {
  required String albumId,
  required String artistName,
}) async {
  final artistInfo = await SaavnAPI().getArtistDetails(albumId, artistName);
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => artistInfo.containsKey('id')
          ? ArtistSearchPage(
              data: artistInfo,
              artistId: artistInfo['id'].toString(),
            )
          : AlbumSearchPage(
              query: artistName,
              type: 'Artists',
            ),
    ),
  );
}
