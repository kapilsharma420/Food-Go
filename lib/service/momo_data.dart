import 'package:hot_bite/model/momo_model.dart';

List<MomoModel> getMomos() {
  List<MomoModel> momoCategories = [];

  MomoModel momoModel = MomoModel();
  momoModel.name = 'Steam Momos';
  momoModel.price = '60';
  momoModel.image = 'images/veg momo.jpg';
  momoCategories.add(momoModel);

  momoModel = MomoModel();
  momoModel.name = 'Paneer Tandoori Momos';
  momoModel.price = '90';
  momoModel.image = 'images/tandoori momo.jpg';
  momoCategories.add(momoModel);

  momoModel = MomoModel();
  momoModel.name = 'Fried Chicken Momos';
  momoModel.price = '110';
  momoModel.image = 'images/fried chicken momo.jpg';
  momoCategories.add(momoModel);

  momoModel = MomoModel();
  momoModel.name = 'Tandoori Momos';
  momoModel.price = '100';
  momoModel.image = 'images/paneer momo.webp';
  momoCategories.add(momoModel);

  momoModel = MomoModel();
  momoModel.name = 'Kurkure Momo';
  momoModel.price = '120';
  momoModel.image = 'images/kurkure momo.jpg';
  momoCategories.add(momoModel);

  momoModel = MomoModel();
  momoModel.name = 'Chocolate Momos';
  momoModel.price = '80';
  momoModel.image = 'images/chocolate momo.jpg';
  momoCategories.add(momoModel);

  momoModel = MomoModel();
  momoModel.name = 'Egg Momos';
  momoModel.price = '90';
  momoModel.image = 'images/egg momo.jpeg';
  momoCategories.add(momoModel);

  momoModel = MomoModel();
  momoModel.name = 'Peri Peri Momo';
  momoModel.price = '90';
  momoModel.image = 'images/peri peri momo.jpeg';
  momoCategories.add(momoModel);

  return momoCategories;
}
