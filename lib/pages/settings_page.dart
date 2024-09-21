import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {

 
   const SettingsPage({  super.key});


  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final GlobalKey<_CounterWidgetState> _counterKey = GlobalKey<_CounterWidgetState>();


 


  @override
  Widget build(BuildContext context) {
    print('Settings');
    return Scaffold(
        appBar: AppBar(
          title: Text('GlobalKey Custom Widget Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The custom CounterWidget
            CounterWidget(key: _counterKey),
            SizedBox(height: 20),
            // A button to increment the counter from outside the CounterWidget
            ElevatedButton(
              onPressed: () {
                // Use the GlobalKey to access the custom widget's method
                _counterKey.currentState!.incrementCounter();
              },
              child: Text('Increment Counter'),
            ),

            ElevatedButton(
              onPressed: () {
                // Use the GlobalKey to access the custom widget's method
                _counterKey.currentState!.decrementCounter();
              },
              child: Text('Decrement Counter'),
            ),
          ],
        ),
      
    );
  }
}


class CounterWidget extends StatefulWidget {
  CounterWidget({Key? key}) : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Counter: $_counter',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}