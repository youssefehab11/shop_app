import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorite_model.dart';
import 'package:shop_app/models/get_favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/home/home_screen.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/constans.dart';
import 'package:shop_app/shared/navigation/navigation.dart';
import 'package:shop_app/shared/network/endpoints.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  List<Widget> screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];

  int bottomNavBarIndex = 0;

  void toggleBottomNavBarIndex(int index) {
    bottomNavBarIndex = index;
    emit(ToggleBottomNavBarState());
  }

  HomeModel? homeModel;

  CategoriesModel? categoriesModel;

  Map<int?, bool?> favorites = {};

  void getProducts() {
    emit(LoadingHomeState());
    DioHelper.getData(
        endPoint: HOME,
        token: TOKEN
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data!.products!) {
        favorites.addAll({element.id: element.inFavorites});
      }
      emit(GetHomeProductsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetHomeProductsErrorState());
    });
  }

  void getCategories() {
    emit(LoadingHomeState());
    DioHelper.getData(
      endPoint: CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(GetCategoriesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetCategoriesErrorState());
    });
  }

  ChangeFavoriteModel? changeFavoriteModel;

  GetFavoritesModel? getFavoritesModel;

  void changeFavorite(int id) {
    favorites[id] = !favorites[id]!;
    emit(ChangeFavoritesState());
    DioHelper.postData(
      endPoint: FAVORITES,
      token: TOKEN,
      data: {
        'product_id' : id,
      }
    ).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data);

      if(!changeFavoriteModel!.status!){
        favorites[id] = !favorites[id]!;
        emit(ChangeFavoritesFailedState());
      }
      else{
        getFavorites();
        emit(ChangeFavoritesSuccessState());
      }

    }).catchError((error){
      emit(ChangeFavoritesErrorState());
    });
  }

  void getFavorites() {
    DioHelper.getData(
      endPoint: FAVORITES,
      token: TOKEN
    ).then((value) {
      getFavoritesModel = GetFavoritesModel.fromJson(value.data);
      emit(GetFavoritesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetFavoritesErrorState());
    });
  }

  UserModel? profileModel;

  void getProfile(){
    DioHelper.getData(
      endPoint: PROFILE,
      token: TOKEN,
    ).then((value) {
      profileModel = UserModel.fromJson(value.data);
      emit(GetProfileSuccessState());
    }).catchError((error){
      emit(GetProfileErrorState());
    });
  }
  
  void logout(BuildContext context){
    CacheHelper.removeData('token').then((value){
      navigateAndRemove(context: context, widget: LoginScreen());
      emit(LogoutSuccessState());
    }).catchError((error){
      emit(LogoutErrorState());
    });
  }
}