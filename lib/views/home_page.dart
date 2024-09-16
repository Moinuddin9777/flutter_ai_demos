import 'package:demo_playground/views/about_me_page.dart';
import 'package:demo_playground/views/chatbot_page.dart';
import 'package:demo_playground/views/object_box_page.dart';
import 'package:demo_playground/views/payment_gateway_page.dart';
import 'package:demo_playground/views/spam_detection_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Row(
        children: [
          Icon(Icons.android),
          Text("Flutter Demos"),
        ],
      ),),
      body: Column(
        children: [
          // AI on client side TF Lite
          const Text("data"),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SpamDetectorScreen()));
          } , child: const Text("Go to")),
          // AI on server side Gemini API
          const Text("data"),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChatScreen(title: "Gemini unleashed") ));
          } , child: const Text("Go to")),
          // Payment Gateway Demo
          const Text("data"),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const PaymentGatewayPage()));
          } , child: const Text("Go to")),
          // Object Box demo
          const Text("data"),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ObjectBoxPage()));
          } , child: const Text("Go to")),
          // About page
          const Text("data"),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const AboutMePage()));
          } , child: const Text("Go to")),
        ],
      ) ,
    );
  }
}