import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petstore/core/error/exception.dart';
import 'package:petstore/data/models/pet_model.dart';

abstract class PetRemoteDataSource {
  Future<List<PetModel>> getPetsByStatus(String status);
  Future<PetModel> getPetById(int id);
  Future<PetModel> createPet(PetModel pet);
  Future<PetModel> updatePet(PetModel pet);
  Future<void> deletePet(int id);
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://petstore3.swagger.io/api/v3';

  PetRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PetModel>> getPetsByStatus(String status) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/pet/findByStatus?status=$status'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => PetModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load pets: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error occurred: $e');
    }
  }

  @override
  Future<PetModel> getPetById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/pet/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return PetModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException('Failed to load pet: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error occurred: $e');
    }
  }

  @override
  Future<PetModel> createPet(PetModel pet) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/pet'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pet.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PetModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException('Failed to create pet: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error occurred: $e');
    }
  }

  @override
  Future<PetModel> updatePet(PetModel pet) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/pet'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pet.toJson()),
      );

      if (response.statusCode == 200) {
        return PetModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException('Failed to update pet: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error occurred: $e');
    }
  }

  @override
  Future<void> deletePet(int id) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/pet/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to delete pet: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error occurred: $e');
    }
  }
}
