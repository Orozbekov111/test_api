part of 'cocktail_bloc.dart';

abstract class CocktailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchCocktailsEvent extends CocktailEvent {
  final String query;
  SearchCocktailsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshCocktailsEvent extends CocktailEvent {
  final String query;
  RefreshCocktailsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
