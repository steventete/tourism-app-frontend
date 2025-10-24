class DocumentType {
  final String id;
  final String name;
  final String abbreviation;
  final String description;
  final String createdAt;
  final String updatedAt;

  DocumentType({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Client {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String birthDate;
  final String gender;
  final String document;
  final String createdAt;
  final String updatedAt;
  final DocumentType documentType;

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthDate,
    required this.gender,
    required this.document,
    required this.createdAt,
    required this.updatedAt,
    required this.documentType,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      birthDate: json['birthDate'] ?? '',
      gender: json['gender'] ?? '',
      document: json['document'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      documentType: DocumentType.fromJson(json['documentType'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'birthDate': birthDate,
      'gender': gender,
      'document': document,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'documentType': documentType.toJson(),
    };
  }

  String get fullName => '$firstName $lastName';
}

class UserProfile {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final bool isVerified;
  final String lastLoginAt;
  final bool mfaEnabled;
  final String? mfaCodesGeneratedAt;
  final String createdAt;
  final String updatedAt;
  final List<String> roles;
  final String? picture;
  final Client client;

  UserProfile({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    required this.isVerified,
    required this.lastLoginAt,
    required this.mfaEnabled,
    this.mfaCodesGeneratedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    this.picture,
    required this.client,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '',
      isVerified: json['isVerified'] ?? false,
      lastLoginAt: json['lastLoginAt'] ?? '',
      mfaEnabled: json['mfaEnabled'] ?? false,
      mfaCodesGeneratedAt: json['mfaCodesGeneratedAt'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      picture: json['picture'],
      client: Client.fromJson(json['client'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'email': email,
      'isVerified': isVerified,
      'lastLoginAt': lastLoginAt,
      'mfaEnabled': mfaEnabled,
      'mfaCodesGeneratedAt': mfaCodesGeneratedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'roles': roles,
      'picture': picture,
      'client': client.toJson(),
    };
  }

  bool get isAdmin => roles.contains('admin');
  bool get isUser => roles.contains('user');
  String get fullName => client.fullName;
}