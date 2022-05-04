import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'icon_state.dart';

class IconCubit extends Cubit<IconCubitState> {
  IconCubit() : super( const IconCubitChange(iconData: Icons.search));
  void changeIcon(IconData iconData){
    if(iconData == Icons.search){
      emit(const IconCubitChange(iconData: Icons.clear));
    }else{
      emit( const IconCubitChange(iconData: Icons.search));
    }
  }
}
