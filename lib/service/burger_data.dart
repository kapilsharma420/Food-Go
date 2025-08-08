import 'package:hot_bite/model/burger_model.dart';

List<BurgerModel> getBurger() {
  List<BurgerModel> burgerCategories = [];

  BurgerModel burgerModel = BurgerModel();
  burgerModel.name = 'Veg Burger';
  burgerModel.image = 'images/veg cheese burger.jpg';
  burgerModel.price = '₹80';
  burgerCategories.add(burgerModel);

  burgerModel = BurgerModel();
  burgerModel.name = 'Chicken Burger';
  burgerModel.image = 'images/chicken burger.jpg';
  burgerModel.price = '₹110';
  burgerCategories.add(burgerModel);

  burgerModel = BurgerModel();
  burgerModel.name = 'Cheese Burger';
  burgerModel.image = 'images/cheese burger.jpg';
  burgerModel.price = '₹90';
  burgerCategories.add(burgerModel);

  burgerModel = BurgerModel();
  burgerModel.name = 'Grill Burger';
  burgerModel.image = 'images/grill burger.jpg';
  burgerModel.price = '₹105';
  burgerCategories.add(burgerModel);

  burgerModel = BurgerModel();
  burgerModel.name = 'Butter Burger';
  burgerModel.image = 'images/butter burger.jpeg';
  burgerModel.price = '₹125';
  burgerCategories.add(burgerModel);

  burgerModel = BurgerModel();
  burgerModel.name = 'Combo Meal';
  burgerModel.image = 'images/combo burger.jpg';
  burgerModel.price = '₹200';
  burgerCategories.add(burgerModel);


   burgerModel = BurgerModel();
  burgerModel.name = 'Fried Chicken Burger';
  burgerModel.image = 'images/fried chicken burger.jpg';
  burgerModel.price = '₹170';
  burgerCategories.add(burgerModel);


  return burgerCategories;
}
