import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/Home.dart';


part 'home_model.g.dart';

@JsonSerializable()
class HomeModel extends Home {

  String? name;
HomeModel(this.name,);





  factory HomeModel.fromJson(Map<String, dynamic> json) => _$HomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}