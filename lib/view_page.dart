import 'dart:convert';

import 'package:api_cre/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class view_page extends StatefulWidget {
  const view_page({super.key});

  @override
  State<view_page> createState() => _view_pageState();
}

class _view_pageState extends State<view_page> {
  Future data() async {
    var url = Uri.parse('https://henistudent.000webhostapp.com/api_view.php');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    Map m = jsonDecode(response.body);
    List l = m['res'];
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("data view")),
      body: FutureBuilder(
        future: data(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List l = snapshot.data;
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text("${l[index]['name']}"),
                  children: [
                    ListTile(
                      title: Text("${l[index]['contact']}"),
                      subtitle: Text("${l[index]['city']}"),
                      trailing: Wrap(children: [
                        IconButton(
                            onPressed: () async {
                              var url = Uri.parse(
                                  'https://henistudent.000webhostapp.com/api_delete.php?id=${l[index]['id']}');
                              var response = await http.get(url);
                              print('Response status: ${response.statusCode}');
                              setState(() {});
                            },
                            icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: () async {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return api_cre(l[index]);
                                },
                              ));
                              setState(() {});
                            },
                            icon: Icon(Icons.edit)),
                      ]),
                    ),
                  ],
                );
              },
            );
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
