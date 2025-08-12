import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/pages/home.dart';
import 'package:hot_bite/service/widget_support.dart';

class DetailPage extends StatefulWidget {
  String image, name, price;
  DetailPage({required this.image, required this.name, required this.price});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  int totalprice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalprice = int.parse(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 35, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppWidget.primary_red_color(),
                borderRadius: BorderRadius.circular(30),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),

            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30, left: 8, right: 15),
                width: Get.height * 0.8,
                height: Get.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.orange, width: 1),
                  image: DecorationImage(
                    image: AssetImage(widget.image),
                    fit: BoxFit.fill,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.name,
                style: AppWidget.onboarding_heading_textstyle(),
              ),
            ),
            Center(
              child: Text(
                '₹' + widget.price,
                style: AppWidget.price_textfield_style(),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(right: 13),
              child: Text(
                " Enjoy the perfect blend of taste and quality with every bite. Prepared fresh with premium ingredients to satisfy your cravings. Ideal for quick snacks or hearty meals, this delicious treat brings flavor and comfort together. A must-try for food lovers!",
                style: AppWidget.onboarding_simple_textstyle(),
              ),
            ),
            SizedBox(height: 25),
            Text('Quantity', style: AppWidget.onboarding_simple_textstyle()),
            SizedBox(height: 5),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      quantity = quantity + 1;
                      totalprice = totalprice + int.parse(widget.price);
                    });
                  },
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppWidget.primary_red_color(),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Icon(Icons.add, color: Colors.white, size: 30),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  '$quantity',
                  style: AppWidget.onboarding_heading_textstyle(),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity = quantity - 1;
                        totalprice = totalprice - int.parse(widget.price);
                      }
                    });
                  },
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppWidget.primary_red_color(),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Icon(Icons.remove, color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 60,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppWidget.primary_red_color(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "₹" + totalprice.toString(),
                        style: AppWidget.bold_white_textfield_style(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30),
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 60,
                    width: 175,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'ORDER NOW',
                        style: AppWidget.white_text_field_style(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
