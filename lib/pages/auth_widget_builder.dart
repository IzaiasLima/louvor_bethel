import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:louvor_bethel/providers/auth_provider.dart';
import 'package:louvor_bethel/models/user.dart';

class AuthWidgetBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<UserModel>) builder;

  final FirebaseFirestore Function(BuildContext context, String uid) dbBuilder;

  AuthWidgetBuilder(Key key, this.builder, this.dbBuilder) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);

    return StreamBuilder<UserModel>(
      stream: authService.user,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        final UserModel user = snapshot.data;
        if (user != null) {
          return MultiProvider(
            providers: [
              Provider<UserModel>.value(value: user),
              Provider<FirebaseFirestore>(
                create: (context) => dbBuilder(context, user.id),
              ),
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
