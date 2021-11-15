import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PersonEntity extends Equatable {
  final int? id;
  final String? name;
  final String? status;
  final String? speceis;
  final String? type;
  final String? gender;
  final LocationEntity? origin;
  final LocationEntity? location;
  final String? image;
  final List<String>? episodes;
  final DateTime? created;

  PersonEntity(
      {@required this.id,
      @required this.name,
      @required this.status,
      @required this.speceis,
      @required this.type,
      @required this.gender,
      @required this.origin,
      @required this.location,
      @required this.image,
      @required this.episodes,
      @required this.created});

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        speceis,
        type,
        gender,
        origin,
        location,
        image,
        episodes,
        created
      ];
}

class LocationEntity {
  final String? name;
  final String? url;

  const LocationEntity({this.name, this.url});
}
