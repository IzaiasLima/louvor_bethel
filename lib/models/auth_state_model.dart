import 'package:flutter/material.dart';

import 'package:louvor_bethel/enum/states.dart';
import 'package:louvor_bethel/models/base_model.dart';
import 'package:louvor_bethel/models/auth_model.dart';

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

  switchAuthText(AuthModel authModel) {
    return authModel.authState == AuthState.SignIn ? "ENTRAR" : "CADASTRAR";
  }

  switchAuthOption(AuthModel authModel) {
    return authModel.authState == AuthState.SignIn
        ? "Meu primeiro acesso. "
        : "Já sou cadastrado.";
  }
}
