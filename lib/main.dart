import 'dart:convert';
import 'dart:io';

import 'package:api_cre/view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: api_cre(),
  ));
}

class api_cre extends StatefulWidget {
  final l;
  api_cre([this.l]);

  @override
  State<api_cre> createState() => _api_creState();
}

class _api_creState extends State<api_cre> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  ImagePicker picker = ImagePicker();
  XFile? photo;
  bool t = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.l != null) {
      t1.text = widget.l['name'];
      t2.text = widget.l['contact'];
      t3.text = widget.l['city'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: (widget.l != null) ? Text("update") : Text("add")),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: t1,
              decoration: InputDecoration(hintText: "enter name"),
            ),
            TextField(
              controller: t2,
              decoration: InputDecoration(hintText: "enter contact"),
            ),
            TextField(
              controller: t3,
              decoration: InputDecoration(hintText: "enter city"),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("any one chosoe"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    photo = await picker.pickImage(
                                        source: ImageSource.camera);
                                    t = true;
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: Text("camera")),
                              TextButton(
                                  onPressed: () async {
                                    photo = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    t = true;
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: Text("gallery")),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("upload photo")),
                (photo != null)
                    ? Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(File(photo!.path)))),
                      )
                    : Text("load image ")
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  String name = t1.text;
                  String contact = t2.text;
                  String city = t3.text;
                  String image;
                  image = base64Encode(await photo!.readAsBytes());
                  var url;
                  if (widget.l != null) {
                    url = Uri.parse(
                        'https://henistudent.000webhostapp.com/api_create.php?name=$name&contact=$contact&city=$city&id=${widget.l['id']}');
                  } else {
                    url = Uri.parse(
                        'https://henistudent.000webhostapp.com/api_create.php');
                  }
                  var response = await http.post(url, body: {
                    'name': '$name',
                    'contact': '$contact',
                    'city': '$city',
                    // 'image':'$image',
                    'image_name': '${photo!.name}'
                  });
                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');
                  // t1.text = '';
                  // t2.text = '';
                  // t3.text = '';

                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return view_page();
                    },
                  ));
                },
                child: Text("submit")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return view_page();
                      },
                    ),
                  );
                },
                child: Text("view page"))
          ],
        ),
      ),
    );
  }
}
