import 'package:hot_bite/model/pizza_model.dart';

List<PizzaModel> getPizza() {
  List<PizzaModel> pizza_categories = [];

  PizzaModel pizzaModel = PizzaModel();
  pizzaModel.name = 'Loaded Pizza';
  pizzaModel.image = 'images/loded pizza.jpg';
    pizzaModel.price = '₹180';
  pizza_categories.add(pizzaModel);

  pizzaModel = PizzaModel();
  pizzaModel.name = 'Momos pizza';
  pizzaModel.image = 'images/momos pizza.avif';
  pizzaModel.price = '₹200';
  pizza_categories.add(pizzaModel);

  pizzaModel = PizzaModel();
  pizzaModel.name = 'Chesse Pizza';
  pizzaModel.image = 'images/mozzarella pizza.jpg';
  pizzaModel.price = '₹200';
  pizza_categories.add(pizzaModel);

  pizzaModel = PizzaModel();
  pizzaModel.name = 'Mushroom Pizza';
  pizzaModel.image = 'images/mushroom pizza.jpg';
  pizzaModel.price = '₹160';
  pizza_categories.add(pizzaModel);

  pizzaModel = PizzaModel();
  pizzaModel.name = 'Non Veg Pizza';
  pizzaModel.image = 'images/non veg pizza.png';
  pizzaModel.price = '₹250';
  pizza_categories.add(pizzaModel);

  pizzaModel = PizzaModel();
  pizzaModel.name = 'Veg pizza ';
  pizzaModel.image = 'images/veg_pizza.png';
  pizzaModel.price = '₹190';
  pizza_categories.add(pizzaModel);

  return pizza_categories;
}
