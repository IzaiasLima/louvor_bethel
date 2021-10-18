import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (context, value, child) {
        UserModel user = context.read<UserManager>().user;
        return AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: user == null
                  ? Icon(Icons.person_rounded)
                  : InkWell(
                      child: circleAvatar(user, 18),
                      onTap: () => {
                        Navigator.of(context).pushNamed('perfil'),
                      },
                    ),
            )
          ],
          titleSpacing: 0.0,
          title: Text(Constants.title),
        );
      },
    );
  }
}
