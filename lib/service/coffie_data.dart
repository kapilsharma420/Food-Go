import 'package:hot_bite/model/coffie_model.dart';

List<CoffieModel> getCoffies() {
  List<CoffieModel> coffieCategories = [];

  CoffieModel model = CoffieModel();
  model.name = 'Espresso';
  model.price = '80';
  model.image = 'images/espresso.jpeg';
  coffieCategories.add(model);

  model = CoffieModel();
  model.name = 'Cappuccino';
  model.price = '100';
  model.image = 'images/cappuccino.jpg';
  coffieCategories.add(model);

  model = CoffieModel();
  model.name = 'Latte';
  model.price = '90';
  model.image = 'images/latte.jpg';
  coffieCategories.add(model);

  model = CoffieModel();
  model.name = 'Cold Coffee';
  model.price = '110';
  model.image = 'images/coldcoffie.jpg';
  coffieCategories.add(model);

  model = CoffieModel();
  model.name = 'Filter Coffee';
  model.price = '70';
  model.image = 'images/filtercoffie.webp';
  coffieCategories.add(model);

  return coffieCategories;
}
