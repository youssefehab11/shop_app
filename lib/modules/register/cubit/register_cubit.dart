import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/modules/register/cubit/register_states.dart';
import 'package:shop_app/shared/network/endpoints.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(TogglePasswordVisibilityState());
  }

  late UserModel registerModel;

  void registerRequest({
    required String name,
    required String email,
    required String password,
    required String phone,
}) {
    emit(RegisterLoadingState());
    DioHelper.postData(
        endPoint: REGISTER,
        data: {
          'name': name,
          'email' : email,
          'password' : password,
          'phone' : phone,
        }
    ).then((value){
      registerModel = UserModel.fromJson(value.data);
      emit(RegisterSuccessState());
    }).catchError((error){
      emit(RegisterErrorState());
    });
  }

}