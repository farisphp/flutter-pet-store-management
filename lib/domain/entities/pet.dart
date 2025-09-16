enum PetStatus { available, pending, sold }

extension PetStatusExtension on PetStatus {
  String get value {
    switch (this) {
      case PetStatus.available:
        return 'available';
      case PetStatus.pending:
        return 'pending';
      case PetStatus.sold:
        return 'sold';
    }
  }

  static PetStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return PetStatus.available;
      case 'pending':
        return PetStatus.pending;
      case 'sold':
        return PetStatus.sold;
      default:
        return PetStatus.available;
    }
  }
}

class Pet {
  final int? id;
  final String name;
  final PetStatus status;
  final List<String> photoUrls;
  final Category? category;
  final List<Tag> tags;

  Pet({
    this.id,
    required this.name,
    required this.status,
    this.photoUrls = const [],
    this.category,
    this.tags = const [],
  });

  Pet copyWith({
    int? id,
    String? name,
    PetStatus? status,
    List<String>? photoUrls,
    Category? category,
    List<Tag>? tags,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      photoUrls: photoUrls ?? this.photoUrls,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pet &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          status == other.status;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ status.hashCode;
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class Tag {
  final int id;
  final String name;

  Tag({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
