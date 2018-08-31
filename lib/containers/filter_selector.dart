// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/actions/actions.dart';
import 'package:notice/models/models.dart';
import 'package:notice/presentation/filter_button.dart';

class FilterSelector extends StatelessWidget {
  final bool visible;
  final Function allFilter;

  FilterSelector({
    Key key,
    @required this.visible,
    this.allFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
      onInitialBuild: (_ViewModel vm) {
        //Callback , ketika pindah dari antar menu
        //kita pengen Category Filter nya pindah lagi sesuai filter terakhir
        allFilter(vm.activeFilter.index);
      },
      onDidChange: (_ViewModel vm) {
        //Callback , ketika dari payment Summary Screen
        //kita pengen Category Filter nya pindah lagi ke All Product
        //bukan yang pesanan
        allFilter(vm.activeFilter.index);
      },
      builder: (context, vm) {
        return FilterButton(
          visible: visible,
          activeFilter: vm.activeFilter,
          onSelected: vm.onFilterSelected,
          allFilter: allFilter,
        );
      },
    );
  }
}

class _ViewModel {
  final Function(VisibilityFilter) onFilterSelected;
  final VisibilityFilter activeFilter;

  _ViewModel({
    @required this.onFilterSelected,
    @required this.activeFilter,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onFilterSelected: (filter) {
        store.dispatch(UpdateFilterAction(filter));
      },
      activeFilter: store.state.activeFilter,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          activeFilter == other.activeFilter;

  @override
  int get hashCode => activeFilter.hashCode;
}
