import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/app_cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        if (cubit.homeModel == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return body(cubit.homeModel, cubit.categoriesModel);
        }
      },
      listener: (context, state){
        if(state is ChangeFavoritesFailedState){
          showToast(
            message: AppCubit.get(context).changeFavoriteModel!.message!,
            state: ToastStates.ERROR,
          );
        }
      },
    );
  }

  Widget body(HomeModel? homeModel, CategoriesModel? categoriesModel) {
    return Container(
      color: Colors.grey[100],
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          banners(homeModel!.data!.banners!),
          const SizedBox(
            height: 10,
          ),
          categories(categoriesModel!.categoriesData!.categoriesListData!),
          const SizedBox(
            height: 10,
          ),
          newProducts(homeModel.data!.products!),
        ],
      ),
    );
  }

  Widget banners(List<Banners> banners) {
    return CarouselSlider(
      items: banners.map((element) => bannerItem(element)).toList(),
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
      ),
    );
  }

  Widget bannerItem(Banners banner) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: Image(
        image: NetworkImage(
          '${banner.image}',
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget newProducts(List<Products> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        defaultTitle(
          title: 'New Products',
        ),
        const SizedBox(
          height: 5.0,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.59,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => newProductItem(products[index], context),
        ),
      ],
    );
  }

  Widget newProductItem(Products product, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(
                  product.image!,
                ),
                width: double.infinity,
                height: 200,
              ),
              if (product.discount > 0)
                const Text(
                  'SALE',
                  style: TextStyle(
                    backgroundColor: Colors.red,
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              product.name!,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    if (product.discount > 0)
                      Text(
                        'EGP${product.oldPrice!.round()}',
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.grey,
                          fontSize: 15.0,
                          decoration: TextDecoration.lineThrough,
                        ),
                        maxLines: 2,
                      ),
                    Text(
                      'EGP${product.price!.round()}',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: primaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    AppCubit.get(context).changeFavorite(product.id!);
                  },
                  splashRadius: 0.1,
                  icon: AppCubit.get(context).favorites[product.id]!
                      ? const Icon(
                          Icons.favorite,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                        ),
                  color: AppCubit.get(context).favorites[product.id]! ? Colors.red : Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categories(List<CategoriesItemData> categoriesList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        defaultTitle(title: 'Categories'),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                categoriesItem(categoriesList[index]),
            itemCount: categoriesList.length,
          ),
        ),
      ],
    );
  }

  Widget categoriesItem(CategoriesItemData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0.5, 0.5),
                    color: Colors.grey[350]!,
                    spreadRadius: 0.2,
                    blurRadius: 0.5),
              ],
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image(
              image: NetworkImage(item.image!),
              height: 150.0,
              width: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              color: Colors.black.withOpacity(0.8),
            ),
            width: 150.0,
            child: Text(
              item.name!,
              style: const TextStyle(color: Colors.white, fontSize: 17.0),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
