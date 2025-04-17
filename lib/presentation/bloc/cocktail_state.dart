part of 'cocktail_bloc.dart';

abstract class CocktailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CocktailInitial extends CocktailState {}

class CocktailLoading extends CocktailState {}

class CocktailLoaded extends CocktailState {
  final List<CocktailModel> cocktails;
  CocktailLoaded(this.cocktails);

  @override
  List<Object?> get props => [cocktails];
}

class CocktailError extends CocktailState {}
