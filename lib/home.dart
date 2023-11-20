import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State {
  bool _isLoading = true;
  String noImage =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png";

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Welcome? dataFromAPI;
  _getData() async {
    try {
      String url =
          "https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=d3068624f781480ca33c1b046560d49b";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        dataFromAPI = Welcome.fromJson(json.decode(res.body));
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 123, 123),
      appBar: AppBar(
        title: const Text("REST API News"),
        backgroundColor: Colors.brown,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                        (dataFromAPI!.articles[index].urlToImage ?? noImage),
                        width: 100,
                      ),
                      const Text(
                        "Title:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(dataFromAPI!.articles[index].title.toString()),
                      const Text(
                        "Description:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "${dataFromAPI!.articles[index].description.toString()}"),
                      const Text(
                        "Author:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(dataFromAPI!.articles[index].author.toString()),
                      const Text(
                        "Url:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(dataFromAPI!.articles[index].url.toString()),
                      const Divider(
                        color: Colors.black,
                        thickness: 3,
                        height: 20,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ],
                  ),
                );
              },
              itemCount: dataFromAPI!.articles.length,
            ),
    );
  }
}
