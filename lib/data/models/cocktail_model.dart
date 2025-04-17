class CocktailModel {
  final String id;
  final String name;
  final String category;
  final String type;
  final String imageUrl;

  CocktailModel({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.imageUrl,
  });

  factory CocktailModel.fromJson(Map<String, dynamic> json) {
    return CocktailModel(
      id: json['idDrink'] ?? '',
      name: json['strDrink'] ?? '',
      category: json['strCategory'] ?? '',
      type: json['strAlcoholic'] ?? '',
      imageUrl: json['strDrinkThumb'] ?? '',
    );
  }
}
