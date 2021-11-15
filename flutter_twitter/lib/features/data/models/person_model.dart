import 'package:flutter_twitter/features/domain/entities/person_entity.dart';
import 'package:meta/meta.dart';

class PersonModel extends PersonEntity {
  PersonModel(
      {@required id,
      @required name,
      @required status,
      @required speceis,
      @required type,
      @required gender,
      @required origin,
      @required location,
      @required image,
      @required episodes,
      @required created})
      : super(
            id: id,
            name: name,
            status: status,
            speceis: speceis,
            type: type,
            gender: gender,
            origin: origin,
            location: location,
            image: image,
            episodes: episodes,
            created: created);

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
        id: json['id'],
        name: json['name'],
        status: json['status'],
        speceis: json['speceis'],
        type: json['type'],
        gender: json['gender'],
        origin: json['origin']['name'],
        location: json['location']['name'],
        image: json['image'],
        episodes: (json['episodes'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        created: DateTime.parse(json['created'] as String));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'speceis': speceis,
      'type': type,
      'gender': gender,
      'origin': origin,
      'location': location,
      'image': image,
      'episodes': episodes,
      'created': created!.toIso8601String()
    };
  }
}
