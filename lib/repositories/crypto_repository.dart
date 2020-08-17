import 'dart:convert';

import 'package:flutter_bloc_crypto_app_with_api/models/coin_model.dart';
import 'package:flutter_bloc_crypto_app_with_api/repositories/base_crypto_repository.dart';
import 'package:http/http.dart' as http;

class CryptoRepository extends BaseCryptoRepository {
  static const String _baseUrl = 'https://min-api.cryptocompare.com';
  static const int perPage = 20;

  final http.Client _httpClient;

  CryptoRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<Coin>> getTopCoins({int page}) async {
    List<Coin> coins = [];
    String requestUrl =
        '$_baseUrl/data/top/totalvolfull?limit=$perPage&tsym=USD&page=$page';

    try {
      http.Response response = await _httpClient.get(requestUrl);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> coinList = data['Data'];

        coinList.forEach((json) => coins.add(Coin.fromJson(json)));
      }
      return coins;
    } catch (err) {
      throw (err);
    }
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}
