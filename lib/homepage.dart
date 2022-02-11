import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // библиотека для ссылок

class HomePage extends StatelessWidget{
  const HomePage({Key? key, required this.title}) : super(key: key); // принимает значение title при обращении
  final String title;
  
  @override
  Widget build(BuildContext context) {

    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)); // форма закругления

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //padding: const EdgeInsets.all(7.0),
                    //padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    shape: shape,
                    minimumSize: const Size(240,40),
                    onPrimary: Colors.white,
                    primary: Colors.green,
                    //side: const BorderSide(width: 2,color: Colors.blue) // - рамка
                    textStyle: const TextStyle(fontSize: 25),
                  ),
                  child: const Text('New Game'), onPressed: (){}),
            ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: shape,
                    minimumSize: const Size(240,40),
                    onPrimary: Colors.white,
                    primary: Colors.green,
                    textStyle: const TextStyle(fontSize: 25),
                  ),child: const Text('Continue'), onPressed: (){}),
            ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: shape,
                    minimumSize: const Size(240,40),  
                    onPrimary: Colors.white,
                    primary: Colors.grey,
                    textStyle: const TextStyle(fontSize: 25),
                  ),
                  child: const Text('Our Contacts'), 
                    onPressed: () async {
                      const url = 'https://vk.com/goliksim';
                      if (!await launch(url)) throw 'Could not launch $url';})
            // кнопка с ссылкой
            ]
        )
      )
    );
  }
}