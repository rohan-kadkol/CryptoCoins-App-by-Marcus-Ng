import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_crypto_app_with_api/blocs/crypto/crypto_bloc.dart';
import 'package:flutter_bloc_crypto_app_with_api/models/coin_model.dart';
import 'package:flutter_bloc_crypto_app_with_api/repositories/crypto_repository.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Coins'),
      ),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.grey[900],
                  // Colors.black12
                ],
              ),
            ),
            child: _buildBody(state),
          );
        },
      ),
    );
  }

  _buildBody(CryptoState state) {
    if (state is CryptoLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
        ),
      );
    } else if (state is CryptoLoaded) {
      return RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: () async {
          context.bloc<CryptoBloc>().add(RefreshCoins());
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _onScrollNotification(notification, state),
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                title: Text(
                  state.coins[index].fullName,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  state.coins[index].name,
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  '\$${state.coins[index].price.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600),
                ),
              );
            },
            itemCount: state.coins.length,
          ),
        ),
      );
    } else if (state is CryptoError) {
      return Center(
        child: Text(
          'Error loading coins!\nPlease check your connection',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 18.0,
          ),
        ),
      );
    }
  }

  bool _onScrollNotification(Notification notif, CryptoLoaded state) {
    if (notif is ScrollEndNotification &&
        _scrollController.position.extentAfter <= 300) {
      context.bloc<CryptoBloc>().add(LoadMoreCoins(coins: state.coins));
    }
  }
}

// FutureBuilder(
//   future: _cryptoRepository.getTopCoins(page: _page),
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) {
//       return Center(
//         child: CircularProgressIndicator(
//           valueColor:
//               AlwaysStoppedAnimation(Theme.of(context).accentColor),
//         ),
//       );
//     }

//     final List<Coin> coins = snapshot.data;
//     return RefreshIndicator(
//       color: Theme.of(context).accentColor,
//       onRefresh: () async {
//         setState(() => _page = 0);
//       },
//       child: ListView.builder(
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   '${index + 1}',
//                   style: TextStyle(
//                       color: Theme.of(context).accentColor,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//             title: Text(
//               coins[index].fullName,
//               style: TextStyle(color: Colors.white),
//             ),
//             subtitle: Text(
//               coins[index].name,
//               style: TextStyle(color: Colors.white70),
//             ),
//             trailing: Text(
//               '\$${coins[index].price.toStringAsFixed(2)}',
//               style: TextStyle(
//                   color: Theme.of(context).accentColor,
//                   fontWeight: FontWeight.w600),
//             ),
//           );
//         },
//         itemCount: coins.length,
//       ),
//     );
//   },
// )
