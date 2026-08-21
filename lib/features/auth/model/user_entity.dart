import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String uid;
  final String email;
  final bool emailVerified;
  final String? displayName;
  final String? photoUrl;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.emailVerified,
    this.displayName,
    this.photoUrl,
  });


  @override 
  List<Object> get props => [
    uid,
    email,
    emailVerified,
    displayName ?? "",
    photoUrl ?? "",
  ];
}