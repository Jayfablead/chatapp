import 'package:chat1/allConstants/color_constants.dart';
import 'package:flutter/material.dart';


const kTextInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    color: AppColors.indyBlue,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.indyBlue, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.indyBlue, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.5),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.5),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
);

const Widget vertical5 = SizedBox(height: 5.0);
const Widget vertical10 = SizedBox(height: 10.0);
const Widget vertical15 = SizedBox(height: 15.0);
const Widget vertical20 = SizedBox(height: 20.0);

const Widget vertical25 = SizedBox(height: 25.0);
const Widget vertical30 = SizedBox(height: 30.0);

const Widget vertical50 = SizedBox(height: 50.0);
const Widget vertical120 = SizedBox(height: 120.0);
