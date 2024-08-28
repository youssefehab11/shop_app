class CategoriesModel {
  bool? status;
  CategoriesListData? categoriesData;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    categoriesData = json['data'] != null ? CategoriesListData.fromJson(json['data']) : null;
  }
}

class CategoriesListData {
  List<CategoriesItemData>? categoriesListData;

  CategoriesListData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      categoriesListData = <CategoriesItemData>[];
      json['data'].forEach((v) {
        categoriesListData!.add(CategoriesItemData.fromJson(v));
      });
    }
  }
}

class CategoriesItemData {
  int? id;
  String? name;
  String? image;

  CategoriesItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
