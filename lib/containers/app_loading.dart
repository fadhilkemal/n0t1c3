// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/models/models.dart';
import 'package:notice/selectors/selectors.dart';

class AppLoading2 extends StatelessWidget {
  final Function(BuildContext context, bool isLoading) builder;

  AppLoading2({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      distinct: true,
      converter: (Store<AppState> store) => isLoadingSelector(store.state),
      builder: builder,
    );
  }
}

class AppLoading extends StatelessWidget {
  final Function(BuildContext context, _ViewModel vm) builder;

  AppLoading({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      //   distinct: true,
      converter: _ViewModel.fromStore,
      builder: builder,
    );
  }
}

class _ViewModel {
  final bool isLoading;
  final bool isSearchLoading;

  _ViewModel({
    @required this.isLoading,
    @required this.isSearchLoading,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isLoading: store.state.isLoading,
      isSearchLoading: store.state.isSearchLoading,
    );
  }
}
