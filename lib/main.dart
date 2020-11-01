import 'dart:async';

import 'package:english_words/english_words.dart';
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<RowItem> row;
  StreamController<List<RowItem>> streamController =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    row = [RowItem(_counter)];
    streamController.add(row);
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      row.add(RowItem(_counter));
      streamController.add(row);
    });
  }

  @override
  Widget build(BuildContext context) {
    /// STREAM*PROVIDER* HERE
    /// - wrapped Scaffold in Builder to make consuming widgets "children" of StreamProvider
    /// instead of siblings. InheritedWidgets like StreamProvider are only useful
    /// to children widgets who inherit its context from below in the widget tree hierarchy.
    /// Often you'd wrap your entire MyApp with a Provider, but this keeps this example
    /// more concise.
    /// https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple#changenotifierprovider
    return StreamProvider<List<RowItem>>.value(
      initialData: row,
      value: streamController.stream,
      child: Builder( // <-- Added to make everything below
        builder: (context) { //<-- this context, children of/inherit from StreamProvider
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
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
                      color: Colors.lightBlueAccent,

/// CONSUMER / CONTEXT.WATCH of STREAM*PROVIDER* HERE
                      child: ListView.builder(
                        itemCount: context.watch<List<RowItem>>().length,
                        itemBuilder: (context, index) {
                          List<RowItem> _row = context.watch<List<RowItem>>();
                          return ListTile(
                            title: Text(
                                '[${_row[index].num} | ${_row[index].name}]'),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.lightGreenAccent,

/// STREAM_BUILDER_ for contrast HERE
                      child: StreamBuilder(
                        initialData: row,
                        stream: streamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<RowItem> _row = snapshot.data;
                            return ListView.builder(
                              itemCount: _row.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      '[${_row[index].num} | ${_row[index].name}]'),
                                );
                              },
                            );
                          }
                          return Text('Waiting on data...');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

class RowItem {
  int num;
  String name;

  RowItem(this.num) {
    name = WordPair.random().asPascalCase;
  }
}