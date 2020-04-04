import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product_providers.dart';
import '../providers/cart_providers.dart';
import '../providers/auth_providers.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final product = Provider.of<ProductProviders>(context, listen: false);
    final cart = Provider.of<CartProviders>(context, listen: false);
    final authData = Provider.of<AuthProviders>(context, listen: false);

    return GridTile(
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (ctx) => ProductDetailScreen(title),
          // ));
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: Hero(
          tag: product.id,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      footer: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTileBar(
          leading: Consumer<ProductProviders>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavourite == true
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                try {
                  await product.toggleFavouritesStatus(
                      authData.token, authData.userId);
                } catch (error) {
                  print(error);
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Unable to perform action!',
                          textAlign: TextAlign.center),
                    ),
                  );
                }
              },
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Added item to cart!',
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    }),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
