import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'detailscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List data = [];
  Future getData() async {
    var Myresponse = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100&offset=0'));

    if (Myresponse.statusCode == 200) {
      var dataResponse = jsonDecode(Myresponse.body)['results'] as List;
      setState(() {
        data = dataResponse;
      });
    } else {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pokemon Character"),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: FutureBuilder(
            future: getData(),
            builder: ((context, snapshot) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // jumlah kolom
                  mainAxisSpacing: 10.0, // jarak antar item secara vertikal
                  crossAxisSpacing: 10.0, // jarak antar item secara horizontal
                ),
                itemCount: data.length, // jumlah item data
                itemBuilder: (BuildContext context, int index) {
                  final DataPokemon = data[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.redAccent,
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => detailscreen(
                                  data: Data(
                                    name: DataPokemon['name'],
                                    url: DataPokemon['url'],
                                    angka: index,
                                  ),
                                ),
                              ));
                        },
                        child: Column(
                          children: [
                            Image.network(
                              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png',
                              scale: 0.7,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(DataPokemon['name']),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
