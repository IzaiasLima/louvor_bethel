import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/ui/commons/search_dialog.dart';

Widget circleAvatar(UserModel user, double radius) {
  try {
    if (user.photo == null)
      user.photo = Image.asset('assets/images/user_avatar.png');
  } catch (_) {}

  return CircleAvatar(
    radius: radius,
    backgroundImage: user?.photo?.image,
  );
}

SnackBar snackBar(String msg, {color}) {
  return SnackBar(
    content: Text(msg),
    duration: Duration(seconds: 3),
    backgroundColor: color ?? Colors.red,
  );
}

ScaffoldFeatureController customSnackBar(context, String msg) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(snackBar(msg, color: Theme.of(context).primaryColor));
}

ScaffoldFeatureController errorSnackBar(context, String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(
      snackBar(msg, color: const Color.fromARGB(255, 210, 20, 45)));
}

Widget searchLyrics(BuildContext context) {
  return Consumer<LyricRepository>(builder: (_, repo, __) {
    if (repo.search.isEmpty) {
      return IconButton(
        icon: Icon(Icons.search),
        onPressed: () async {
          final search = await showDialog<String>(
            context: context,
            builder: (_) => SearchDialog(),
          );
          if (search != null) {
            repo.search = search;
          }
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () => repo.search = '',
      );
    }
  });
}

Widget searchSongs(BuildContext context) {
  return Consumer<LyricRepository>(builder: (_, repo, __) {
    if (repo.search.isEmpty) {
      return IconButton(
        icon: Icon(Icons.search),
        onPressed: () async {
          final search = await showDialog<String>(
            context: context,
            builder: (_) => SearchDialog(),
          );
          if (search != null) {
            repo.search = search;
          }
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () => repo.search = '',
      );
    }
  });
}
