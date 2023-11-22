import 'package:firebase_base/controller/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_base/controller/SearchPage.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  SearchScreenController homeScreenController = Get.put(SearchScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Search Page"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: homeScreenController.titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Buscar',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
                onPrimary: Colors.black,
              ),
              onPressed: () {
                homeScreenController.SearchData(homeScreenController.titleController.text);
              },
              child: Text('Search'),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: homeScreenController.wordList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(homeScreenController.wordList[index].title!),
                        subtitle: Text(homeScreenController.wordList[index].meaning!),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
