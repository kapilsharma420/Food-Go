import 'package:hot_bite/model/noodles_model.dart';

List<NoodlesModel> getNoodles() {
  List<NoodlesModel> noodlesCategories = [];

  NoodlesModel noodlesModel = NoodlesModel();
  noodlesModel.name = 'Veg Noodles';
  noodlesModel.image = 'images/veg noodles.webp';
  noodlesModel.price = '₹80';
  noodlesCategories.add(noodlesModel);

  noodlesModel = NoodlesModel();
  noodlesModel.name = 'Egg Noodles';
  noodlesModel.image = 'images/Egg noodles.jpg';
  noodlesModel.price = '₹90';
  noodlesCategories.add(noodlesModel);

  noodlesModel = NoodlesModel();
  noodlesModel.name = 'Chicken Noodle';
  noodlesModel.image = 'images/chicken noodles.jpg';
  noodlesModel.price = '₹120';
  noodlesCategories.add(noodlesModel);

  noodlesModel = NoodlesModel();
  noodlesModel.name = ' Masala Maggi';
  noodlesModel.image = 'images/masala maggi.webp';
  noodlesModel.price = '₹60';
  noodlesCategories.add(noodlesModel);

  noodlesModel = NoodlesModel();
  noodlesModel.name = 'Garlic Noodles';
  noodlesModel.image = 'images/garlic noodles.webp';
  noodlesModel.price = '₹70';
  noodlesCategories.add(noodlesModel);

 
  return noodlesCategories;
}
