import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/app_cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/get_favorites_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:shop_app/shared/styles/styles.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        if (cubit.getFavoritesModel != null && cubit.homeModel != null) {
          if (cubit.getFavoritesModel!.data!.data!.isEmpty) {
            return Center(
              child: Text(
                'No favorite items yet',
                style: titleStyle,
              ),
            );
          } else {
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => favoriteItem(
                  cubit.getFavoritesModel!.data!.data![index].product!,
                  context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: cubit.getFavoritesModel!.data!.data!.length,
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      listener: (context, state) {
        if (state is ChangeFavoritesFailedState) {
          showToast(
            message: AppCubit.get(context).changeFavoriteModel!.message!,
            state: ToastStates.ERROR,
          );
        }
      },
    );
  }

  Widget favoriteItem(Product product, BuildContext context) {
    return Container(
      height: 140.0,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(
                  product.image!,
                ),
                height: 140.0,
                width: 140.0,
              ),
              if (product.discount! > 0)
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
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          if (product.discount! > 0)
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
                        color: AppCubit.get(context).favorites[product.id]!
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
