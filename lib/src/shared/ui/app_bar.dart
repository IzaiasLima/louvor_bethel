import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/locator.dart';
import 'package:louvor_bethel/src/models/auth_model.dart';
import 'package:louvor_bethel/src/shared/ui/widgets.dart';
import 'package:louvor_bethel/src/shared/utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    AuthModel model = locator<AuthModel>();
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: userAvatar(model, 22),
        )
      ],
      titleSpacing: 0.0,
      title: Text(Constants.title),
    );
  }
}
