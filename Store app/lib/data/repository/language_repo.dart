import 'package:sixam_mart_store/data/model/response/language_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
