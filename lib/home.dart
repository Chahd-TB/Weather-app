import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      body:Container(
        decoration: const  BoxDecoration(
         color: Colors.white,
        ),
        child:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 30,bottom: 40,left: 30,right: 30),
            child: Text(textAlign: TextAlign.center,"Welcome To Our Weather App",style: TextStyle(fontSize: 28,fontWeight:FontWeight.bold),),),
             Image.asset("images/3411087.jpg"),
           MaterialButton(
                  color: Colors.blue[300],
                  height: 50,
                  minWidth: 150,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Weather()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0), 
                  ),
                  child: const Text(
                    "continue",
                    style: TextStyle(fontSize: 18, color: Colors.white), 
                  ),
                ),
           

          ],
        ),
      ),
      )
       
    );
  }
}
