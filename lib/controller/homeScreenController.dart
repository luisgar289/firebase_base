import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_base/model/base_model.dart';

class HomeScreenController extends GetxController{
  var isLoading = false.obs;
  var wordList = <WordModel>[].obs;
  var isEditing = false.obs;
  var cardHeight = 100.0.obs;
  //Control entrada de texto
  var titleController = TextEditingController();
  var meaningController = TextEditingController();
  var isNewRegister = false.obs;

  Future<void> getData() async{
    try{
      QuerySnapshot words = await FirebaseFirestore.instance.collection('word_bank').orderBy("title").get();
      wordList.clear();
      words.docs.forEach((element) {
        wordList.add(WordModel(element['title'], element['meaning'], element.id));
        print(element.id);
      });
      // for(var word in words.docs){
      //   wordList.add(WordModel(word['title'], word['meaning'], word['id']));
      // }
      isLoading.value = false;
    }catch(e){
      Get.snackbar("Error", e.toString());
    }
  }
  //TODO 1: Add a function to send data from firebase
  Future<void>SendData(String title, String meaning) async{
    var collection = FirebaseFirestore.instance.collection('word_bank');
    WordModel someData = WordModel(title, meaning, "");
    collection.add(someData.toJson());
  }
  //TODO 2: Add a function to update data from firebase
  Future<void>UpdateData(String docId, String titleController, String meaningController) async{
    var collection = FirebaseFirestore.instance.collection('word_bank');
    if (titleController == ""){
      collection.doc(docId).update({
        'meaning': meaningController
      });
    }
    else if (meaningController == ""){
      collection.doc(docId).update({
        'title': titleController
      });
    }
  }
  //TODO 3: Add a function to delete data from firebase
  Future<void>DeleteData(String docId) async{
    var collection = FirebaseFirestore.instance.collection('word_bank');
    collection.doc(docId).delete();
  }
}