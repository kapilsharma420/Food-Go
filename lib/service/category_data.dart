import 'package:hot_bite/model/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> categories = [];

  CategoryModel categoryModel = CategoryModel();
  categoryModel.name = "Pizza";
  categoryModel.image = "images/pizza.png";
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.name = "Burger";
  categoryModel.image = "images/burger.png";
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.name = "Noodles";
  categoryModel.image = "images/noodles.png";
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.name = "Momos";
  categoryModel.image = "images/momos.png";
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.name = "Ice-Cream";
  categoryModel.image = "images/ice-cream.png";
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.name = " Soya Chaap";
  categoryModel.image = "images/roti.png";
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.name = "Soup";
  categoryModel.image = "images/soup.png";
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.name = 'Coffie';
  categoryModel.image = 'images/coffie.png';
  categories.add(categoryModel);

  return categories;
}
