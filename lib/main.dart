import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<NumberHolder> numberHolders;
  StreamController<List<NumberHolder>> streamController = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    numberHolders = [NumberHolder(_counter)];
    streamController.add(numberHolders);
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      numberHolders.add(NumberHolder(_counter));
      streamController.add(numberHolders);
    });
  }

  @override
  Widget build(BuildContext context) {
//STREAMPROVIDER HERE
    return StreamProvider<List<NumberHolder>>.value(
      initialData: numberHolders,
      value: streamController.stream,
      child: Builder(
        builder: (context) =>  Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
          ),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You have pushed the button this many times:',
                      ),
                      Text(
                        '$_counter',
                        style: Theme.of(context).textTheme.headline4,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.lightGreenAccent,
// STREAMBUILDER HERE
                    child: StreamBuilder(
                      initialData: numberHolders,
                      stream: streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<NumberHolder> _numHolders = snapshot.data;
                          return ListView.builder(
                            itemCount: _numHolders.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('[${_numHolders[index].num}]'),
                                );
                              },
                          );
                        }
                        return Text('Waiting on data...');
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.lightBlueAccent,
//STREAMPROVIDER WATCH HERE
                    child: ListView.builder(
                      itemCount: context.watch<List<NumberHolder>>().length,
                        itemBuilder: (context, index) {
                        List<NumberHolder> _holders = context.watch<List<NumberHolder>>();
                          return ListTile(
                            title: Text('[${_holders[index].num}]'),
                          );
                        },
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class NumberHolder {
  int num;

  NumberHolder(this.num);
}