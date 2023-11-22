import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_base/model/base_model.dart';

class SearchScreenController extends GetxController{
  var isLoading = false.obs;
  var wordList = <WordModel>[].obs;
  var isEditing = false.obs;
  var cardHeight = 100.0.obs;
  //Control entrada de texto
  var titleController = TextEditingController();
  var meaningController = TextEditingController();
  var isNewRegister = false.obs;


  Future<void>SearchData(String title) async{
    try{
      QuerySnapshot words = await FirebaseFirestore.instance.collection('word_bank').where('title', isEqualTo: title).get();
      wordList.clear();
      for (var element in words.docs) {
        wordList.add(WordModel(element['title'], element['meaning'], element.id));
        print(element.id);
      }
      isLoading.value = false;
    }catch(e){
      Get.snackbar("Error", e.toString());
    }
  }
}