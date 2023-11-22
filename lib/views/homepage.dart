import 'package:firebase_base/controller/homeScreenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'SearchPage.dart';

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
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Get.to(() => SearchPage());
                  },
                  mini: true,
                  child: const Icon(Icons.search),
                ),
                SizedBox(
                    height:
                        16), // Ajusta el espacio entre los botones si es necesario
                FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Agregar nuevo elemento"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                      hintText: "Enter a title"),
                                  controller:
                                      homeScreenController.titleController,
                                ),
                                TextField(
                                  decoration: const InputDecoration(
                                      hintText: "Enter a meaning"),
                                  controller:
                                      homeScreenController.meaningController,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Verificar si los campos de texto están vacíos
                                  if (homeScreenController
                                          .titleController.text.isEmpty ||
                                      homeScreenController
                                          .meaningController.text.isEmpty) {
                                    // Mostrar un mensaje de error
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text(
                                              "Por favor, rellene todos los campos"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    // Si los campos no están vacíos, proceder con el envío de datos
                                    homeScreenController.SendData(
                                      homeScreenController.titleController.text,
                                      homeScreenController
                                          .meaningController.text,
                                    );
                                    homeScreenController.refresh();
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text("Add"),
                              )
                            ],
                          );
                        });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.yellow,
              title: const Text("Firebase TEST"),
            ),
            body: Center(
              child: homeScreenController.isLoading.value == true
                  ? const CircularProgressIndicator(
                      color: Colors.black,
                    )
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
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: Text(
                                                    homeScreenController
                                                        .wordList[index].title!,
                                                    style: const TextStyle(
                                                        fontSize: 24),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  homeScreenController
                                                      .wordList[index].meaning!,
                                                  style: const TextStyle(
                                                      fontSize: 24),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Visibility(
                                          visible: homeScreenController
                                              .isEditing.value,
                                          child: Expanded(
                                            child: Expandir().build(
                                              context,
                                              index,
                                              homeScreenController,
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
                                                homeScreenController
                                                        .selectedIndex =
                                                    homeScreenController
                                                        .wordList[index].id!;
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
                                              },
                                              icon: const Icon(Icons
                                                  .expand_circle_down_outlined),
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

class Expandir {
  @override
  Widget build(BuildContext context, int index,
      HomeScreenController homeScreenController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(hintText: "Update Title"),
            controller: homeScreenController.titleController,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(hintText: "Update Meaning"),
            controller: homeScreenController.meaningController,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        IconButton(
            onPressed: () {
              homeScreenController.UpdateData(
                  homeScreenController.wordList[index].id!,
                  homeScreenController.titleController.text,
                  homeScreenController.meaningController.text);
              homeScreenController.refresh();
            },
            icon: const Icon(Icons.update))
      ],
    );
  }
}
