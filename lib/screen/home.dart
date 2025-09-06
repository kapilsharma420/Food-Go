import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_bite/model/burger_model.dart';
import 'package:hot_bite/model/category_model.dart';
import 'package:hot_bite/model/chaap_model.dart';
import 'package:hot_bite/model/coffie_model.dart';
import 'package:hot_bite/model/icecream_model.dart';
import 'package:hot_bite/model/momo_model.dart';
import 'package:hot_bite/model/noodles_model.dart';
import 'package:hot_bite/model/pizza_model.dart';
import 'package:hot_bite/model/soup_model.dart';
import 'package:hot_bite/screen/detail_page.dart';
import 'package:hot_bite/service/burger_data.dart';
import 'package:hot_bite/service/category_data.dart';
import 'package:hot_bite/service/chaap_data.dart';
import 'package:hot_bite/service/coffie_data.dart';
import 'package:hot_bite/service/icecream_data.dart';
import 'package:hot_bite/service/momo_data.dart';
import 'package:hot_bite/service/noodles_data.dart';
import 'package:hot_bite/service/pizza_data.dart';
import 'package:hot_bite/service/soup_data.dart';
import 'package:hot_bite/service/widget_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  List<PizzaModel> pizza_categories = [];
  List<BurgerModel> burger_categories = [];
  List<NoodlesModel> noodles_categories = [];
  List<MomoModel> momo_categories = [];
  List<IcecreamModel> icecream_categories = [];
  List<ChaapModel> chaap_categories = [];
  List<SoupModel> soup_categories = [];
  List<CoffieModel> coffie_categories = [];
  String trackindex = '0';

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        //overlays: [SystemUiOverlay.bottom],
      );

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Brightness.dark, // ya dark depending on background
          systemNavigationBarColor: Colors.grey[100],
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    });

    categories = getCategories();
    pizza_categories = getPizza();
    burger_categories = getBurger();
    noodles_categories = getNoodles();
    momo_categories = getMomos();
    icecream_categories = getIcecreams();
    chaap_categories = getChaap();
    soup_categories = getSoups();
    coffie_categories = getCoffies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 20, top: 40, bottom: 50),
        child: Column(
          children: [
            // app name image , text and user image
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'images/name_logo.png',
                      height: 50,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Order your favorite Meals!',
                      style: AppWidget.onboarding_simple_textstyle(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      'images/user.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // this is search bar
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: double.infinity,
                child: TextField(
                    autofocus: false, // zaroori
                  decoration: InputDecoration(
                    hintText: 'Search food items ...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppWidget.primary_red_color(),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 0.002,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            //list view builder for catagories like pizza,icecream , momos etc
            Container(
              height: 60,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                physics: BouncingScrollPhysics(),

                itemBuilder: (context, index) {
                  return CategoryTile(
                    categories[index].name!,
                    categories[index].image!,
                    index.toString(),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            // grid view for pizza categories

            //pizza section
            trackindex == "0"
                ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .69,
                      mainAxisSpacing: 35,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: pizza_categories.length,
                    itemBuilder: (context, index) {
                      return FoodTile(
                        pizza_categories[index].name!,
                        pizza_categories[index].image!,
                        pizza_categories[index].price!,
                      );
                    },
                  ),
                )
                //burger section
                : trackindex == "1"
                ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .66,
                      mainAxisSpacing: 35,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: burger_categories.length,
                    itemBuilder: (context, index) {
                      return FoodTile(
                        burger_categories[index].name!,
                        burger_categories[index].image!,
                        burger_categories[index].price!,
                      );
                    },
                  ),
                )
                //noodles section
                : trackindex == "2"
                ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .69,
                      mainAxisSpacing: 35,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: noodles_categories.length,
                    itemBuilder: (context, index) {
                      return FoodTile(
                        noodles_categories[index].name!,
                        noodles_categories[index].image!,
                        noodles_categories[index].price!,
                      );
                    },
                  ),
                )
                //momos section
                : trackindex == "3"
                ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .66,
                      mainAxisSpacing: 35,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: momo_categories.length,
                    itemBuilder: (context, index) {
                      return FoodTile(
                        momo_categories[index].name!,
                        momo_categories[index].image!,
                        momo_categories[index].price!,
                      );
                    },
                  ),
                )
                //ice cream section
                : trackindex == "4"
                ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .66,
                      mainAxisSpacing: 35,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: icecream_categories.length,
                    itemBuilder: (context, index) {
                      return FoodTile(
                        icecream_categories[index].name!,
                        icecream_categories[index].image!,
                        icecream_categories[index].price!,
                      );
                    },
                  ),
                )
                // soya chaap  section
                : trackindex == "5"
                ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .66,
                      mainAxisSpacing: 35,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: chaap_categories.length,
                    itemBuilder: (context, index) {
                      return FoodTile(
                        chaap_categories[index].name!,
                        chaap_categories[index].image!,
                        chaap_categories[index].price!,
                      );
                    },
                  ),
                )
                //soup section
                : trackindex == "6"
                ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .66,
                      mainAxisSpacing: 35,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: soup_categories.length,
                    itemBuilder: (context, index) {
                      return FoodTile(
                        soup_categories[index].name!,
                        soup_categories[index].image!,
                        soup_categories[index].price!,
                      );
                    },
                  ),
                )
                :
                //coffie section
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .66,
                      mainAxisSpacing: 35,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: coffie_categories.length,
                    itemBuilder: (context, index) {
                      return FoodTile(
                        coffie_categories[index].name!,
                        coffie_categories[index].image!,
                        coffie_categories[index].price!,
                      );
                    },
                  ),
                ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  //simple widget (not statefull or stateless ) for show categoryTile
  Widget FoodTile(String name, image, price) {
    return Container(
      margin: EdgeInsets.only(right: 7),
      padding: EdgeInsets.only(left: 10, top: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                image,
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: AppWidget.bold_textfield_style(),
            ),
          ),
          Center(
            child: Text('₹' + price, style: AppWidget.price_textfield_style()),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap:
                    () => Get.to(
                      DetailPage(image: image, name: name, price: price),
                    ),
                child: Container(
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppWidget.primary_red_color(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //simple widget (not statefull or stateless ) for show categoryTile
  Widget CategoryTile(String name, image, categoryindex) {
    return GestureDetector(
      onTap: () {
        trackindex = categoryindex;
        setState(() {});
      },
      child:
          trackindex == categoryindex
              ? Container(
                margin: EdgeInsets.only(right: 20, bottom: 10),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),

                    decoration: BoxDecoration(
                      color: AppWidget.primary_red_color(),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          image,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Text(name, style: AppWidget.white_text_field_style()),
                      ],
                    ),
                  ),
                ),
              )
              : Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                margin: EdgeInsets.only(right: 20, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      image,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10),
                    Text(name, style: AppWidget.onboarding_simple_textstyle()),
                  ],
                ),
              ),
    );
  }
}
