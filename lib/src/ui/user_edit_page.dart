import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';

class UserEditPage extends StatefulWidget {
  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController urlPhotoController = TextEditingController();

  UserModel user = new UserModel();
  bool changedPhoto = false;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: SingleChildScrollView(
            child: Consumer<UserManager>(
              builder: (ctx, value, child) {
                UserManager repo = ctx.watch<UserManager>();
                emailController.text = repo.user.email;
                nameController.text = repo.user.name;
                user = repo.user;

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _circleUserPhoto(repo),
                    _namedFormField(),
                    _emailTextField(),
                    _updateButton(context, formKey),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleUserPhoto(repo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        repo.viewState == ViewState.Busy
            ? CircularProgressIndicator()
            : InkWell(
                onTap: () => repo.uploadImage(user.id),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: circleAvatar(user, 80),
                ),
              ),
      ],
    );
  }

  Widget _namedFormField() {
    return TextFormField(
      controller: nameController,
      autocorrect: false,
      validator: (name) => validName(name) ? null : Constants.neededUserName,
      decoration: InputDecoration(
        labelText: 'Nome',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => user.name = value,
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      controller: emailController,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Email (inalterável)',
      ),
      onSaved: (value) => user.email = value,
    );
  }

  Widget _updateButton(BuildContext context, GlobalKey<FormState> formState) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ElevatedButton(
          child: Text('ATUALIZAR'),
          onPressed: () {
            if (!formState.currentState.validate()) return;
            formState.currentState.save();
            context.read<UserManager>().save();
            // Navigator.popAndPushNamed(context, 'home');
          },
        ),
      ),
    );
  }
}
