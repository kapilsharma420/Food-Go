import 'package:hot_bite/model/chaap_model.dart';

List<ChaapModel> getChaap() {
  List<ChaapModel> chapatiCategories = [];

  ChaapModel model = ChaapModel();
  model.name = 'Soya Chaap';
  model.price = '60';
  model.image = 'images/soyachaap.jpg';
  chapatiCategories.add(model);

  model = ChaapModel();
  model.name = 'Butter Chaap';
  model.price = '80';
  model.image = 'images/butterchaap.jpg';
  chapatiCategories.add(model);

  model = ChaapModel();
  model.name = 'Tandoori Chaap';
  model.price = '90';
  model.image = 'images/tandoorichaap.avif';
  chapatiCategories.add(model);

  model = ChaapModel();
  model.name = 'Malai Chaap';
  model.price = '125';
  model.image = 'images/malaichaap.jpg';
  chapatiCategories.add(model);

  model = ChaapModel();
  model.name = 'Fried Chaap';
  model.price = '100';
  model.image = 'images/friedchaap.jpg';
  chapatiCategories.add(model);

  return chapatiCategories;
}
