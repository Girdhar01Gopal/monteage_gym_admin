import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AdminDetailsController extends GetxController {
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  RxString selectedGender = RxString('');

  void selectGender(String gender) {
    selectedGender.value = gender;
  }
}
