import '../../data/models/cocktail_model.dart';
import '../../data/repositories/cocktail_repository.dart';

class SearchCocktailsUseCase {
  final CocktailRepository repository;

  SearchCocktailsUseCase(this.repository);

  Future<List<CocktailModel>> call(String query) {
    return repository.searchCocktails(query);
  }
}
