import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/enum/states.dart';
import 'package:louvor_bethel/src/models/auth_model.dart';
import 'package:louvor_bethel/src/models/base_model.dart';

class AuthStateModel extends BaseModel {
  switchAuthState(AuthModel authModel) {
    authModel.authState == AuthState.SignIn
        ? authModel.setAuthState(AuthState.SignUp)
        : authModel.setAuthState(AuthState.SignIn);
  }

  switchAuthMethod(AuthModel authModel, TextEditingController emailController,
      TextEditingController passwordController) {
    authModel.authState == AuthState.SignIn
        ? authModel.signIn(
            emailController.text,
            passwordController.text,
          )
        : authModel.createNewUser(
            emailController.text,
            passwordController.text,
          );
  }

  updateProfiler(AuthModel authModel, TextEditingController nameController,
      TextEditingController urlController) {
    authModel.updateProfiler(nameController.text, urlController.text);
    authModel.firebaseAuth.currentUser.reload();
  }

  switchAuthText(AuthModel authModel) {
    return authModel.authState == AuthState.SignIn ? "ENTRAR" : "CADASTRAR";
  }

  switchAuthOption(AuthModel authModel) {
    return authModel.authState == AuthState.SignIn
        ? "Meu primeiro acesso. "
        : "Já sou cadastrado.";
  }
}
