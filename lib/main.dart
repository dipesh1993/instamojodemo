import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: InstaMojoDemo(),
    );
  }
}
class InstaMojoDemo extends StatefulWidget {

  @override
  _InstaMojoDemoState createState() => _InstaMojoDemoState();
}

bool isLoading = true; //this can be declared outside the class

class _InstaMojoDemoState extends State<InstaMojoDemo> {
  String selectedUrl;
  double progress = 0;

  @override
  void initState() {

    super.initState();
    createRequest(); //creating the HTTP request
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Pay"),
      ),
      body: Container(
        child: Center(
          child: isLoading ? //check loadind status
          CircularProgressIndicator() //if true
              :InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.tryParse(selectedUrl),

            ),

            onWebViewCreated: (InAppWebViewController controller) {


            },
            onProgressChanged: (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            onUpdateVisitedHistory: (_, Uri uri, __) {
              String url=uri.toString();
              print(uri);
              // uri containts newly loaded url
              if (mounted) {
                if (url.contains('https://www.google.com/')) {
//Take the payment_id parameter of the url.
                  String paymentRequestId = uri.queryParameters['payment_id'];
                  print("value is: " +paymentRequestId);
//calling this method to check payment status
                  _checkPaymentStatus(paymentRequestId);
                }
              }
            },

          ),
        ),
      ),
    );
  }

  _checkPaymentStatus(String id) async {
    var response = await http.get(Uri.parse("https://test.instamojo.com/api/1.1/payments/$id/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "test_b678a7048c8a9e5f69663c2e4fa",
          "X-Auth-Token": "test_41af76995b230611b2c3b72b8cc"
        });
    var realResponse = json.decode(response.body);
    print(realResponse);
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        print('sucesssssssssssful');
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(
        //         builder: (context) => ()));
//payment is successful.
      } else {
        print('failed');
//payment failed or pending.
      }
    } else {
      print("PAYMENT STATUS FAILED");
    }
  }
  Future createRequest() async {
    Map<String, String> body = {
      "amount": "9", //amount to be paid
      "purpose": "Advertising",
      "buyer_name": 'mahesh',
      "email": 'abc@gmail.com',
      "phone": '7276544474',
      "allow_repeated_payments": "true",
      "send_email": "true",
      "send_sms": "true",
      "redirect_url": "https://www.google.com/",
      //Where to redirect after a successful payment.
      "webhook": "https://www.google.com/",
    };
//First we have to create a Payment_Request.
//then we'll take the response of our request.
    var resp = await http.post(Uri.parse("https://test.instamojo.com/api/1.1/payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "test_b678a7048c8a9e5f69663c2e4fa",
          "X-Auth-Token": "test_41af76995b230611b2c3b72b8cc"
        },
        body: body);
    if (json.decode(resp.body)['success'] == true) {
//If request is successful take the longurl.
      setState(() {
        isLoading = false;//setting state to false after data loaded

        selectedUrl =
            json.decode(resp.body)["payment_request"]['longurl'].toString() +
                "?embed=form";
      });
      print(json.decode(resp.body)['message'].toString());
//If something is wrong with the data we provided to
//create the Payment_Request. For Example, the email is in incorrect format, the payment_Request creation will fail.
    }
  }
}


