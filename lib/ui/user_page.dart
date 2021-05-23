import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:louvor_bethel/locator.dart';
import 'package:louvor_bethel/models/user.dart';
import 'package:louvor_bethel/utils/constants.dart';
import 'package:louvor_bethel/utils/widgets.dart';
import 'package:louvor_bethel/ui/drawer.dart';
import 'package:louvor_bethel/ui/base_view.dart';
import 'package:louvor_bethel/models/auth_state_model.dart';
import 'package:louvor_bethel/models/auth_model.dart';

// ignore: must_be_immutable
class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController urlPhotoController = TextEditingController();

  String urlPhoto;
  bool changedPhoto = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AuthStateModel authStateModel = locator<AuthStateModel>();

    return BaseView<AuthModel>(
      builder: (context, AuthModel model, child) {
        return Scaffold(
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
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            avatar(model),
                            Text(
                              'Dados do usuário',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            _emailTextField(model.user.email),
                            _namedFormField(model.user.name),
                            _urlPhotoFormField(),
                            _updateButton(
                              context,
                              formKey,
                              authStateModel,
                              model,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget avatar(AuthModel model) {
    UserModel user = model.user;
    urlPhoto = changedPhoto ? urlPhoto : user.photoUrl;

    return InkWell(
      onTap: () => user == null ? {} : _uploadImage(model.user.id),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: circleAvatar(urlPhoto, 80)),
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

  Widget _urlPhotoFormField() {
    return TextFormField(
      controller: urlPhotoController,
      autocorrect: false,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Url da foto',
      ),
    );
  }

  Widget _updateButton(context, formKey, authStateModel, authModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ElevatedButton(
          child: Text('ATALIZAR'),
          onPressed: () {
            if (formKey.currentState.validate()) {
              authStateModel.updateProfiler(
                  authModel, nameController, urlPhotoController);
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
    String url;

    if (uid != null) {
      PickedFile pickedFile = await _imagePicker();
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('users/$uid');

      UploadTask uploadTask = ref.putData(await pickedFile.readAsBytes());

      uploadTask.whenComplete(() async {
        TaskSnapshot snapshot = uploadTask.snapshot;
        url = await snapshot.ref.getDownloadURL();

        setState(() {
          changedPhoto = true;
          urlPhotoController.text = url;
          urlPhoto = url;
        });
      });
    }
  }

  Future<PickedFile> _imagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile compressedImage = await imagePicker.getImage(
      source: ImageSource.gallery,
      maxHeight: 400.0,
      maxWidth: 400.0,
      imageQuality: 90,
    );
    return compressedImage;
  }
}
