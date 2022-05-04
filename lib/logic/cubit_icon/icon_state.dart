part of 'icon_cubit.dart';

abstract class IconCubitState extends Equatable {
  const IconCubitState();

  @override
  List<Object> get props => [];
}

class IconCubitChange extends IconCubitState {
  final IconData iconData;
  const IconCubitChange({required this.iconData});

  @override
  List<Object> get props => [iconData];
}



