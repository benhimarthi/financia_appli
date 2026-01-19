import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/auth/domain/entities/account_type.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
    required super.accountType,
    super.phoneNumber,
    super.location,
    super.imageUrl,
  });

  const UserModel.empty()
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

  factory UserModel.fromJson(DataMap json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      accountType: (json['accountType'] as String? ?? 'regular').toAccountType(),
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  factory UserModel.fromSnap(DocumentSnapshot snap) {
    final data = snap.data() as DataMap? ?? {};
    data['id'] = snap.id;
    return UserModel.fromJson(data);
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? createdAt,
    String? updatedAt,
    AccountType? accountType,
    String? phoneNumber,
    String? location,
    String? imageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accountType: accountType ?? this.accountType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  DataMap toJson() {
    return {
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'accountType': accountType.name,
      'phoneNumber': phoneNumber,
      'location': location,
      'imageUrl': imageUrl,
    };
  }
}
