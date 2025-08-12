import 'package:hot_bite/model/icecream_model.dart';

List<IcecreamModel> getIcecreams() {
  List<IcecreamModel> icecreamCategories = [];

  IcecreamModel model = IcecreamModel();
  model.name = 'Vanilla IceCream';
  model.price = '50';
  model.image = 'images/vanilla.webp';
  icecreamCategories.add(model);

  model = IcecreamModel();
  model.name = 'Chocolate Ice Cream';
  model.price = '60';
  model.image = 'images/chocolate icecream.jpg';
  icecreamCategories.add(model);

  model = IcecreamModel();
  model.name = 'Strawberry Ice Cream';
  model.price = '55';
  model.image = 'images/strawberry.jpg';
  icecreamCategories.add(model);

  model = IcecreamModel();
  model.name = 'Butterscotch Ice Cream';
  model.price = '65';
  model.image = 'images/butterscotch.jpg';
  icecreamCategories.add(model);

  model = IcecreamModel();
  model.name = 'Mango Ice Cream';
  model.price = '50';
  model.image = 'images/mango.jpeg';
  icecreamCategories.add(model);

  model = IcecreamModel();
  model.name = 'Orange Ice Cream';
  model.price = '50';
  model.image = 'images/orange.jpeg';
  icecreamCategories.add(model);

  return icecreamCategories;
}
