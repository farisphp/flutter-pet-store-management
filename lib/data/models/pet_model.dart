import 'package:petstore/domain/entities/pet.dart';

class PetModel {
  final int? id;
  final String name;
  final String status;
  final List<String> photoUrls;
  final CategoryModel? category;
  final List<TagModel> tags;

  PetModel({
    this.id,
    required this.name,
    required this.status,
    this.photoUrls = const [],
    this.category,
    this.tags = const [],
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      name: json['name'] ?? '',
      status: json['status'] ?? 'available',
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      tags: json['tags'] != null
          ? List<TagModel>.from(json['tags'].map((x) => TagModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'status': status,
      'photoUrls': photoUrls,
      if (category != null) 'category': category!.toJson(),
      'tags': tags.map((x) => x.toJson()).toList(),
    };
  }

  Pet toDomain() {
    return Pet(
      id: id,
      name: name,
      status: PetStatusExtension.fromString(status),
      photoUrls: photoUrls,
      category: category?.toDomain(),
      tags: tags.map((tag) => tag.toDomain()).toList(),
    );
  }

  static PetModel fromDomain(Pet pet) {
    return PetModel(
      id: pet.id,
      name: pet.name,
      status: pet.status.value,
      photoUrls: pet.photoUrls,
      category:
          pet.category != null ? CategoryModel.fromDomain(pet.category!) : null,
      tags: pet.tags.map((tag) => TagModel.fromDomain(tag)).toList(),
    );
  }
}

class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  Category toDomain() {
    return Category(id: id, name: name);
  }

  static CategoryModel fromDomain(Category category) {
    return CategoryModel(id: category.id, name: category.name);
  }
}

class TagModel {
  final int id;
  final String name;

  TagModel({required this.id, required this.name});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  Tag toDomain() {
    return Tag(id: id, name: name);
  }

  static TagModel fromDomain(Tag tag) {
    return TagModel(id: tag.id, name: tag.name);
  }
}
