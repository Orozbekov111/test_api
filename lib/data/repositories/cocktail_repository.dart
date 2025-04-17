import 'package:dio/dio.dart';
import '../models/cocktail_model.dart';

class CocktailRepository {
  final Dio dio;

  CocktailRepository(this.dio);

  Future<List<CocktailModel>> searchCocktails(String query) async {
    final response = await dio.get(
      'https://www.thecocktaildb.com/api/json/v1/1/search.php',
      queryParameters: {'s': query},
    );
    final drinks = response.data['drinks'] as List?;
    if (drinks == null) return [];
    return drinks.map((json) => CocktailModel.fromJson(json)).toList();
  }
}
