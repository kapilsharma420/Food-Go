import 'package:hot_bite/model/soup_model.dart';

List<SoupModel> getSoups() {
  List<SoupModel> soupCategories = [];

  SoupModel model = SoupModel();
  model.name = 'Tomato Soup';
  model.price = '50';
  model.image = 'images/tomatosoup.jpg';
  soupCategories.add(model);

  model = SoupModel();
  model.name = 'Sweet Corn Soup';
  model.price = '60';
  model.image = 'images/cornsoup.jpeg';
  soupCategories.add(model);

  model = SoupModel();
  model.name = 'Hot and Sour Soup';
  model.price = '65';
  model.image = 'images/soursoup.jpeg';
  soupCategories.add(model);

  model = SoupModel();
  model.name = 'Manchow Soup';
  model.price = '70';
  model.image = 'images/manchowsoup.jpg';
  soupCategories.add(model);

  model = SoupModel();
  model.name = 'Channa Soup';
  model.price = '40';
  model.image = 'images/channasoup.jpg';
  soupCategories.add(model);

  return soupCategories;
}
