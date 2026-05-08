import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.mobile,
    required this.rating,
    required this.contributions,
    required this.followers,
    required this.following,
    required this.status,
    required this.role,
    required this.profileUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String mobile;
  final int rating;
  final int contributions;
  final int followers;
  final int following;
  final String status;
  final String role;
  final String profileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get displayName {
    final fn = firstName.trim();
    final ln = lastName.trim();
    if (fn.isEmpty && ln.isEmpty) return username;
    return '$fn $ln'.trim();
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        username,
        mobile,
        rating,
        contributions,
        followers,
        following,
        status,
        role,
        profileUrl,
        createdAt,
        updatedAt,
      ];
}
