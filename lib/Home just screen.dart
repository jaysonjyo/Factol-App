import 'package:flutter/material.dart';

import 'Material Page/Material home screen.dart';

import 'Product/Prdouct create.dart';

import 'Route Pages/Route.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}
class _MainHomeState extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RoutesScreen()));
              },
              child: Text('RoutesScreen'),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateProductPage()));
              },
              child: Text('CreateProductPage'),
            ), ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MaterialsScreen()));
              },
              child: Text('MaterialsScreen'),
            ),
          ],
        ),
      ),
    );
  }
}
