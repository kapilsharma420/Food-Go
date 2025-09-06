import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:hot_bite/admin/allorder.dart';
import 'package:hot_bite/admin/manage_users.dart';
import 'package:hot_bite/service/widget_support.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  Text(
                    'Home Admin',
                    style: AppWidget.onboarding_heading_textstyle(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                child:Column(
                  children: [
                    SizedBox(height: 20),
                   GestureDetector(
                    onTap: () {
                      Get.to(() =>AllOrders());
                    },
                     child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                       child: Material(
                         borderRadius: BorderRadius.circular(20),
                        elevation: 3,
                         child: Container(
                          
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                         
                            Image.asset('images/delivery-man.png',height: 120,width: 120,fit: BoxFit.cover,),
                            Text('Manage \nOrders',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppWidget.primary_red_color(),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(Icons.arrow_forward_ios,color: Colors.white,))
                          ],),
                         ),
                       ),
                     ),
                   ),

                     SizedBox(height: 50),
                   GestureDetector(
                    onTap: () {
                      Get.to(() =>ManageUsers());
                    },
                     child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                       child: Material(
                         borderRadius: BorderRadius.circular(20),
                        elevation: 3,
                         child: Container(
                          
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                         
                            Image.asset('images/team.png',height: 120,width: 120,fit: BoxFit.cover,),
                            Text('Manage \nUsers',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppWidget.primary_red_color(),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(Icons.arrow_forward_ios,color: Colors.white,))
                          ],),
                         ),
                       ),
                     ),
                   )
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
