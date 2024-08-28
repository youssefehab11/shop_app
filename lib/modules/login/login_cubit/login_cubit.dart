import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/modules/login/login_cubit/login_states.dart';
import 'package:shop_app/shared/components/constans.dart';
import 'package:shop_app/shared/network/endpoints.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  
  LoginCubit() : super(LoginInitialState());
  
  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  late UserModel loginModel;

  void loginRequest({
    required String email,
    required String password
})
  {
    emit(LoginLoadingState());
    DioHelper.postData(endPoint: LOGIN,data: {
      'email' : email,
      'password' : password,
    }).then((value) {
      loginModel = UserModel.fromJson(value.data);
      TOKEN = loginModel.data!.token;
      print(loginModel.message);
      emit(LoginSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }

  bool isPasswordVisible = false;

  void togglePasswordVisibility(){
    isPasswordVisible = !isPasswordVisible;
    emit(TogglePasswordVisibilityState());
  }
}
