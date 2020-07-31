import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learn_hive/club.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocDirectory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocDirectory.path);
  Hive.registerAdapter(ClubAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Learn Hive"),
      ),
      body: FutureBuilder(
        future: Hive.openBox("clubs"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error),
              );
            } else {
              var clubBox = Hive.box("clubs");
              if (clubBox.length == 0) {
                clubBox.add(Club("GSW", 5));
                clubBox.add(Club("LAL", 2));
              }
              return WatchBoxBuilder(
                box: clubBox,
                builder: (context, clubs) => Container(
                  margin: EdgeInsets.all(20),
                  child: ListView.builder(
                      itemCount: clubs.length,
                      itemBuilder: (context, index) {
                        Club club = clubs.getAt(index);
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.5))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(club.name +
                                  " with " +
                                  club.championship.toString() +
                                  " title"),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.trending_up,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      clubs.putAt(
                                          index,
                                          Club(club.name,
                                              club.championship + 1));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.content_copy,
                                      color: Colors.amber,
                                    ),
                                    onPressed: () {
                                      clubs.add(
                                          Club(club.name, club.championship));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      clubs.deleteAt(index);
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
