import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
class ProductProviders with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  ProductProviders({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite,
  });

  Future<void> toggleFavouritesStatus(String token,String userId) async {
    print('toggleFavouritesStatus called with userID:$userId');
    var oldStatus = isFavourite;
    final url = 'https://flutter-update-29928.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    if (isFavourite != null)
      isFavourite = !isFavourite;
    else
      isFavourite = true;
    notifyListeners();
    final response = await http.put(url,
        body: json.encode({
          'isFavourite':isFavourite,
        }));
        var r = json.decode(response.body);
        print("\nresponse:$r");
    if (response.statusCode >= 400) {
      isFavourite = oldStatus;
      notifyListeners();
      throw HttpException('Could not toggle Favourites Status.');
    }
  }
}
