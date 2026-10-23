import 'package:equatable/equatable.dart';

class SceneEntity extends Equatable {
  final String name;

  const SceneEntity({required this.name});

  @override
  List<Object> get props => [name];
}
