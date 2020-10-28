import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

List<CategoryModel> getCategoryModelList(List<dynamic> list) {
  List<CategoryModel> result = [];
  list.forEach((item) {
    result.add(CategoryModel.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class CategoryModel extends Object {
  @JsonKey(name: 'categoryName')
  String categoryName;

  @JsonKey(name: 'items')
  List<CategoryItem> items;

  CategoryModel(
      this.categoryName,
      this.items,
      );

  factory CategoryModel.fromJson(Map<String, dynamic> srcJson) =>
      _$CategoryModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

@JsonSerializable()
class CategoryItem extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'image')
  String image;

  CategoryItem(this.name, this.image, [this.id]);

  factory CategoryItem.fromJson(Map<String, dynamic> srcJson) =>
      _$CategoryItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CategoryItemToJson(this);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'name': name, 'image': image};
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  CategoryItem.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    image = map['image'];
    id = map['id'];
  }
}
