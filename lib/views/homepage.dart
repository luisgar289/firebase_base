import 'package:firebase_base/controller/homeScreenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
        init: HomeScreenController(),
        initState: (_) {},
        builder: (homeScreenController) {
          homeScreenController.getData();
          //Recargar el controlador
          homeScreenController.refresh();
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                //mostrar un dialogo
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Add new bank word"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                  hintText: "Enter a title"),
                              controller: homeScreenController.titleController,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  hintText: "Enter a meaning"),
                              controller: homeScreenController.meaningController,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                homeScreenController.SendData(
                                    homeScreenController.titleController.text,
                                    homeScreenController.meaningController.text);
                                homeScreenController.refresh();
                                Navigator.pop(context);
                              },
                              child: const Text("Add"))
                        ],
                      );
                    });
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              backgroundColor: Colors.yellow,
              title: Text("Firebase TEST"),
            ),
            body: Center(
              child: homeScreenController.isLoading.value == true
                  ? const CircularProgressIndicator(color: Colors.black,)
                  : Obx(
                      () => ListView.separated(
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(
                                () => SizedBox(
                                  height: homeScreenController.cardHeight.value,
                                  width: double.infinity,
                                  child: Card(
                                    color: Colors.deepOrangeAccent.shade100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Obx(() => Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Text(
                                                homeScreenController
                                                    .wordList[index].title!,
                                                style: TextStyle(fontSize: 24),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                                homeScreenController
                                                    .wordList[index].meaning!,
                                                style: TextStyle(fontSize: 24),
                                            overflow: TextOverflow.ellipsis,),
                                          ],
                                        )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Visibility(
                                          visible: homeScreenController
                                              .isEditing.value,
                                          child: Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                 Expanded(
                                                  child: TextField(
                                                    decoration: const InputDecoration(
                                                        hintText:
                                                            "Update Title"),
                                                    controller: homeScreenController.titleController,

                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                 Expanded(
                                                  child: TextField(
                                                    decoration: const InputDecoration(
                                                        hintText:
                                                            "Update Meaning"),
                                                    controller: homeScreenController.meaningController,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                IconButton(onPressed: (){
                                                  homeScreenController.UpdateData(
                                                      homeScreenController
                                                          .wordList[index].id!,
                                                      homeScreenController.titleController.text,
                                                      homeScreenController.meaningController.text);
                                                  homeScreenController.refresh();
                                                }, icon: Icon(Icons.update))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                homeScreenController.DeleteData(
                                                    homeScreenController
                                                        .wordList[index].id!);
                                                homeScreenController.refresh();
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                homeScreenController.isEditing
                                                    .toggle();
                                                homeScreenController
                                                        .cardHeight.value =
                                                    homeScreenController
                                                            .isEditing.value
                                                        ? 150
                                                        : 100;
                                                print(homeScreenController
                                                    .isEditing.value);
                                                // homeScreenController.updateData(
                                                //     homeScreenController
                                                //         .wordList[index].id);
                                              },
                                              icon: const Icon(Icons.expand_circle_down_outlined),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return const Divider(
                              thickness: 2, color: Colors.black);
                        },
                        itemCount: homeScreenController.wordList.length,
                      ),
                    ),
            ),
          );
        });
  }
}
