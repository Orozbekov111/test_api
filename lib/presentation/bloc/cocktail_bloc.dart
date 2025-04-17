import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/cocktail_model.dart';
import '../../domain/usecases/search_cocktails_usecase.dart';

part 'cocktail_event.dart';
part 'cocktail_state.dart';

class CocktailBloc extends Bloc<CocktailEvent, CocktailState> {
  final SearchCocktailsUseCase searchCocktails;

  CocktailBloc(this.searchCocktails) : super(CocktailInitial()) {
    on<SearchCocktailsEvent>((event, emit) async {
      emit(CocktailLoading());
      try {
        final cocktails = await searchCocktails(event.query);
        emit(CocktailLoaded(cocktails));
      } catch (_) {
        emit(CocktailError());
      }
    });

    on<RefreshCocktailsEvent>((event, emit) async {
      try {
        final cocktails = await searchCocktails(event.query);
        emit(CocktailLoaded(cocktails));
      } catch (_) {
        emit(CocktailError());
      }
    });
  }
}
