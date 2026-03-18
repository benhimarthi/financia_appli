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
    super.currentCurrency,
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
          currentCurrency: '',
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
      currentCurrency: json['currentCurrency'] as String?,
    );
  }

  /// Creates a [UserModel] from a domain [User] entity.
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      accountType: user.accountType,
      phoneNumber: user.phoneNumber,
      location: user.location,
      imageUrl: user.imageUrl,
      currentCurrency: user.currentCurrency,
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
    String? currentCurrency,
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
      currentCurrency: currentCurrency ?? this.currentCurrency,
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
      'currentCurrency': currentCurrency,
    };
  }
}
