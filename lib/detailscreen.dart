import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

class detailscreen extends StatefulWidget {
  final Data data;

  detailscreen({required this.data});

  @override
  State<detailscreen> createState() => _detailscreenState();
}

class _detailscreenState extends State<detailscreen> {
  @override
  String _pokemonHeight = "";
  String _imgUrl = "";
  String _pokemonWeight = "";
  List stats = [];

  Future getData() async {
    var Myresponse = await http.get(Uri.parse('${widget.data.url}'));

    if (Myresponse.statusCode == 200) {
      var dataResponse = jsonDecode(Myresponse.body);
      var dataStats = jsonDecode(Myresponse.body)['stats'] as List;
      var dataImg = jsonDecode(Myresponse.body)['sprites']['other']
              ['dream_world']['front_default']
          .toString();
      setState(() {
        _pokemonHeight = dataResponse['height'].toString();
        _pokemonWeight = dataResponse['weight'].toString();
        stats = dataStats;
        _imgUrl = dataImg.toString() as String;
      });
    } else {
      print('Error');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.data.name}'),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, Snapshoot) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Center(
                      child: Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.data.angka + 1}.png',
                        scale: 0.7,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      '${widget.data.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Height: ${_pokemonHeight}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            child: Text('|'),
                            width: 3,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Weight: ${_pokemonWeight}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Stats Pokemon',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: stats.map((DataStats) {
                          double value = DataStats['base_stat'] / 100;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${DataStats['stat']['name']}'),
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 250,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Stack(
                                      children: [
                                        LinearProgressIndicator(
                                          minHeight: 15,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.red),
                                          backgroundColor: Colors.grey,
                                          value: value,
                                        ),
                                        Positioned.fill(
                                          child: Center(
                                            child: Text(
                                              '${DataStats['base_stat']}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
