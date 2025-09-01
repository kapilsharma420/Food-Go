import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/service/daatabase.dart';
import 'package:hot_bite/service/share_pref.dart';
import 'package:hot_bite/service/widget_support.dart';
import 'package:random_string/random_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DetailPage extends StatefulWidget {
  String image, name, price;
  DetailPage({required this.image, required this.name, required this.price});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  int totalprice = 0;
  Razorpay _razorpay = Razorpay();

 
  TextEditingController addresscontroller = TextEditingController();

 String? name, id,email;
  getthesharedprefrence() async {

    //local saved data ko get kerne k liye 
    name = await SharedPrefHelper().getUserEmail();
    id = await SharedPrefHelper().getUserId();
    email = await SharedPrefHelper().getUserEmail();
    addresscontroller.text = await SharedPrefHelper().getUserAddress() ?? '';
    setState(() {
      
    });
  }

  var options = {
    'key':
        'rzp_test_RB3FEePW83UaOV', // Enter the Key ID generated from the Dashboard
    'amount': 0,
    'currency': 'INR',
    'name': "kapil's FoodGo",
    'description': 'Delicious food delivered to your doorstep',
    'prefill': {'contact': '0000000000', 'email': 'test@razorpay.com'},
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getthesharedprefrence();
    totalprice = int.parse(widget.price);
    options['amount'] = totalprice * 100; // paise me set

      // Yeh listeners sirf ek hi baar lagane hain
  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                        options['amount'] =
                            totalprice * 100; // Razorpay me paise me dalna
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
                          options['amount'] =
                              totalprice * 100; // Razorpay me paise me dalna
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
                  GestureDetector(
                    // handle order now here
                    onTap: () {
                      if (addresscontroller.text == null || addresscontroller.text.isEmpty) {
                        openBox();
                      } else{
                        //direct payment page pe chala jayega
                        _razorpay.open(options);
                      }
                    },
        
                    child: Material(
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    String orderid = randomAlphaNumeric(10);
    // Do something when payment succeeds
   
    Map<String, dynamic> userOrderMap = {

      "name": name,
      "id": id,
      "quantity": quantity.toString(),
      "email": email,
      "total_price": totalprice.toString(),
      "foodName":widget.name,
      "image":widget.image,
      "status":"pending",
      "order_id": orderid, 
      "address": addresscontroller.text,
    };

    await Database().addUserOrderDetails(userOrderMap, id!, orderid);
    await Database().addAdminOrderDetails(userOrderMap, orderid);

     Get.snackbar(
      "Success",
      "Order Successful!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Get.snackbar(
      "Error",
      "Payment Failed!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    Get.snackbar(
      "Info",
      "External Wallet Selected!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(12),
    );
  }

  //address dialoge

  Future openBox()=> showDialog(context: context, builder: (context)=>
  AlertDialog(
  
   
    content: SingleChildScrollView(
      child: Container(
        child: Column(
         
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.cancel),
                ),
                SizedBox(width: 30),
                Text('Add the Address',style: TextStyle(
                  color: Color(0xff008080),fontWeight: FontWeight.bold,fontSize: 18
                ),),
           


                
              ],
            ),
            SizedBox(height: 20,),
            Text('Add Address'),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38,width: 1),
                borderRadius: BorderRadius.circular(10)
              ),
              child: TextField(
                controller: addresscontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Address'
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () async{
                await SharedPrefHelper().saveUserAddress(addresscontroller.text);
                Get.snackbar(
                  "Success",
                  "Address Added Successfully",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(12),
                );
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  width: 100,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xff008080),
                    borderRadius: BorderRadius.circular(10),
                    
                  ),
                  child: Center(
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ),
              ),
            )
          ],
        ),
      ),
    )
  ));

  @override
  void dispose() {
    // TODO: implement dispose
    
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }
}
