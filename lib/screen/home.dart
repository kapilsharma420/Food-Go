import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_bite/controller/nav_controller.dart';
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
import 'package:hot_bite/service/share_pref.dart';
import 'package:hot_bite/service/soup_data.dart';
import 'package:hot_bite/service/widget_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];

  // All food lists
  List<PizzaModel> pizza_categories = [];
  List<BurgerModel> burger_categories = [];
  List<NoodlesModel> noodles_categories = [];
  List<MomoModel> momo_categories = [];
  List<IcecreamModel> icecream_categories = [];
  List<ChaapModel> chaap_categories = [];
  List<SoupModel> soup_categories = [];
  List<CoffieModel> coffie_categories = [];

  String trackindex = '0';
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();
  String? userName;

  @override
  void initState() {
    super.initState();
    _initSystemUI();
    _loadData();
    _loadUserName();
  }

  void _initSystemUI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey[100],
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    });
  }

  void _loadData() {
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

  Future<void> _loadUserName() async {
    userName = await SharedPrefHelper().getUserName();
    if (mounted) setState(() {});
  }

  // 🔹 Current category ki list return karo
  List<Map<String, String>> get _currentList {
    List<Map<String, String>> list = [];

    switch (trackindex) {
      case '0':
        list = pizza_categories
            .map((e) => {'name': e.name!, 'image': e.image!, 'price': e.price!})
            .toList();
        break;
      case '1':
        list = burger_categories
            .map((e) => {'name': e.name!, 'image': e.image!, 'price': e.price!})
            .toList();
        break;
      case '2':
        list = noodles_categories
            .map((e) => {'name': e.name!, 'image': e.image!, 'price': e.price!})
            .toList();
        break;
      case '3':
        list = momo_categories
            .map((e) => {'name': e.name!, 'image': e.image!, 'price': e.price!})
            .toList();
        break;
      case '4':
        list = icecream_categories
            .map((e) => {'name': e.name!, 'image': e.image!, 'price': e.price!})
            .toList();
        break;
      case '5':
        list = chaap_categories
            .map((e) => {'name': e.name!, 'image': e.image!, 'price': e.price!})
            .toList();
        break;
      case '6':
        list = soup_categories
            .map((e) => {'name': e.name!, 'image': e.image!, 'price': e.price!})
            .toList();
        break;
      default:
        list = coffie_categories
            .map((e) => {'name': e.name!, 'image': e.image!, 'price': e.price!})
            .toList();
    }

    // 🔹 Search filter apply karo
    if (searchQuery.isNotEmpty) {
      list = list
          .where((item) =>
              item['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return list;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _currentList;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Top Header ──
          Container(
            padding: const EdgeInsets.only(
                top: 48, left: 20, right: 20, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              children: [
                // Name logo + greeting + avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('images/name_logo.png',
                            height: 40, width: 95, fit: BoxFit.contain),
                        const SizedBox(height: 2),
                        Text(
                          userName != null
                              ? 'Hey ${userName!.split(' ').first}! 👋'
                              : 'Order your favorites!',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                    // 🔹 Profile image — tap to go profile tab
                    GestureDetector(
                      onTap: () {
                        final nav = Get.find<NavController>();
                        nav.goToProfile();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppWidget.primary_red_color(), width: 2.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.red.shade100,
                                blurRadius: 8,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset('images/user.png',
                              height: 52, width: 52, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 🔹 Search bar — working
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: searchController,
                    autofocus: false,
                    onChanged: (val) {
                      setState(() => searchQuery = val.trim());
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for food...',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: Icon(Icons.search,
                          color: AppWidget.primary_red_color(), size: 22),
                      // 🔹 Clear button
                      suffixIcon: searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                searchController.clear();
                                setState(() => searchQuery = '');
                              },
                              child: Icon(Icons.close,
                                  color: Colors.grey.shade500, size: 20),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Category chips ──
          Container(
            height: 58,
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _CategoryTile(
                  categories[index].name!,
                  categories[index].image!,
                  index.toString(),
                );
              },
            ),
          ),

          const SizedBox(height: 4),

          // ── Food grid ──
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 70, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'No results for "$searchQuery"'
                              : 'Nothing here',
                          style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding:
                        const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 14,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return _FoodCard(
                        name: item['name']!,
                        image: item['image']!,
                        price: item['price']!,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _CategoryTile(String name, String image, String categoryindex) {
    final bool isSelected = trackindex == categoryindex;
    return GestureDetector(
      onTap: () {
        setState(() {
          trackindex = categoryindex;
          searchQuery = '';
          searchController.clear();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppWidget.primary_red_color()
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.red.shade200,
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ]
              : [],
        ),
        child: Row(
          children: [
            Image.asset(image, height: 28, width: 28, fit: BoxFit.cover),
            const SizedBox(width: 6),
            Text(
              name.trim(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Food Card Widget ──
class _FoodCard extends StatelessWidget {
  final String name, image, price;
  const _FoodCard(
      {required this.name, required this.image, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food image
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                height: 120,
                color: Colors.grey.shade100,
                child:
                    Icon(Icons.fastfood, color: Colors.grey.shade400, size: 40),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '₹$price',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppWidget.primary_red_color()),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Order button
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () => Get.to(() =>
                  DetailPage(image: image, name: name, price: price)),
              child: Container(
                height: 38,
                width: 70,
                decoration: BoxDecoration(
                  color: AppWidget.primary_red_color(),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: const Icon(Icons.arrow_forward,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}