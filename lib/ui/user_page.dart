import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louvor_bethel/locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:louvor_bethel/ui/drawer.dart';
import 'package:louvor_bethel/utils/constants.dart';
import 'package:louvor_bethel/utils/widgets.dart';
import 'package:louvor_bethel/ui/base_view.dart';
import 'package:louvor_bethel/models/auth_state_model.dart';
import 'package:louvor_bethel/models/auth_model.dart';

// ignore: must_be_immutable
class UserPage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController urlPhotoController = TextEditingController();
  // final AuthModel authModel;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AuthStateModel authStateModel = locator<AuthStateModel>();

    return BaseView<AuthModel>(
      builder: (context, AuthModel model, child) => Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          actions: [],
          titleSpacing: 0.0,
          title: Text(Constants.title), //Text('***LOUVOR BETHEL'),
        ),
        body: (model.user == null)
            ? expiredSessionCard(model)
            : Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dados do usuário',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          _emailTextField(model.user.email),
                          _namedFormField(model.user.name),
                          // _urlPhotoFormField(model.user.photoUrl),
                          _updateButton(
                            context,
                            formKey,
                            authStateModel,
                            model,
                          ),
                          ElevatedButton(
                            onPressed: () => _uploadImage(model.user.id),
                            child: Text(
                              'Foto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _namedFormField(String name) {
    nameController.text = name;
    return TextFormField(
      controller: nameController,
      autocorrect: false,
      validator: (value) => value.isEmpty ? 'Informe seu nome.' : null,
      decoration: InputDecoration(
        labelText: 'Nome',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  Widget _emailTextField(String email) {
    emailController.text = email;
    return TextFormField(
      controller: emailController,
      autocorrect: false,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Email',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  // Widget _urlPhotoFormField(String urlPhoto) {
  //   urlPhotoController.text = urlPhoto;
  //   return TextFormField(
  //     controller: urlPhotoController,
  //     autocorrect: false,
  //     decoration: InputDecoration(
  //       labelText: 'Foto',
  //       floatingLabelBehavior: FloatingLabelBehavior.auto,
  //     ),
  //   );
  // }

  Widget _updateButton(context, formKey, authStateModel, authModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ElevatedButton(
          child: Text('ATALIZAR'),
          onPressed: () {
            if (formKey.currentState.validate()) {
              authStateModel.updateProfiler(authModel, nameController);
              Navigator.popAndPushNamed(context, 'home');
            } else {
              return;
            }
          },
        ),
      ),
    );
  }

  Future _uploadImage(String uid) async {
    if (uid != null) {
      PickedFile pickedFile = await _imagePicker();
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('users/$uid}');

      UploadTask uploadTask = ref.putData(await pickedFile.readAsBytes());

      uploadTask.whenComplete(() async {
        TaskSnapshot snapshot = uploadTask.snapshot;
        var url = await snapshot.ref.getDownloadURL();
        print(url.toString());
      });
    }
  }

  Future<PickedFile> _imagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile compressedImage = await imagePicker.getImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    return compressedImage;
  }
}
