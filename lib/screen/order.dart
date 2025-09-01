import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hot_bite/service/daatabase.dart';
import 'package:hot_bite/service/share_pref.dart';
import 'package:hot_bite/service/widget_support.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? id;
  Stream? orderstream;

  getthesharedpref() async {
    id = await SharedPrefHelper().getUserId();
    setState(() {});
  }

  getontheload() async {
    await getthesharedpref();
    orderstream = await Database().getUserOrders(id!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allorder() {
    return StreamBuilder(
      stream: orderstream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(1),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: EdgeInsets.only(left: 6, right: 6, bottom: 15),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppWidget.primary_red_color(),
                          ),
                          SizedBox(width: 10),
                          Text(
                            ds['address'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              ds['image'],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds["foodName"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.list_outlined,
                                    color: AppWidget.primary_red_color(),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    ds['quantity'].toString(),
                                    style: AppWidget.bold_textfield_style(),
                                  ),
                                  SizedBox(width: 30),
                                  Icon(
                                    Icons.monetization_on_sharp,
                                    color: AppWidget.primary_red_color(),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '₹${ds['total_price']}',
                                    style: AppWidget.bold_textfield_style(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                ds['status'] + '!',
                                style: TextStyle(
                                  color: AppWidget.primary_red_color(),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Text('Orders', style: AppWidget.onboarding_heading_textstyle()),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    //  height: MediaQuery.of(context).size.height / 1.7,
                    child: allorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
