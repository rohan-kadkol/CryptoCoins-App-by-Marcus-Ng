import 'package:flutter_bloc_crypto_app_with_api/models/coin_model.dart';

abstract class BaseCryptoRepository {
  Future<List<Coin>> getTopCoins({int page});
  void dispose();
}
