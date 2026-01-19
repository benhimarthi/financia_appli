import 'package:equatable/equatable.dart';
import 'package:myapp/features/auth/domain/entities/account_type.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String createdAt;
  final String updatedAt;
  final AccountType accountType;
  final String? phoneNumber;
  final String? location;
  final String? imageUrl;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.accountType,
    this.phoneNumber,
    this.location,
    this.imageUrl,
  });

  const User.empty()
      : this(
          id: ' ',
          email: ' ',
          name: ' ',
          createdAt: ' ',
          updatedAt: ' ',
          accountType: AccountType.personal,
          phoneNumber: ' ',
          location: ' ',
          imageUrl: ' ',
        );

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        createdAt,
        updatedAt,
        accountType,
        phoneNumber,
        location,
        imageUrl,
      ];
}
