// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/models/models.dart';
import 'package:notice/presentation/category_picker.dart';
import 'package:notice/actions/actions.dart';

class Category extends StatelessWidget {
  Category({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        // return CategoryPicker(
        //   onCategorySelected: vm.onCategorySelected,
        //   //   categoryPicker: vm.categoryPicker,
        // );
        return MyTabbedPage(
          onCategorySelected: vm.onCategorySelected,
          //   categoryPicker: vm.categoryPicker,
        );
      },
    );
  }
}

class _ViewModel {
//   final double numCompleted;
//   final int numActive;
  final Function onCategorySelected;
//   final String categoryPicker;

  _ViewModel({
    @required this.onCategorySelected,
    // @required this.categoryPicker,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onCategorySelected: (categoryName) {
        store.dispatch(UpdateCategoryAction(categoryName));
      },
      //   categoryPicker: store.state.categoryPicker,
      //   numActive: numActiveSelector(todosSelector(store.state)),
      //   numCompleted: numCompletedSelector(todosSelector(store.state)),
    );
  }
}
