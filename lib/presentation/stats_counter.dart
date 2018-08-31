// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notice/containers/app_loading.dart';
import 'package:notice/presentation/loading_indicator.dart';
import 'package:intl/intl.dart';

class StatsCounter extends StatelessWidget {
  final int numActive;
  final double numCompleted;

  StatsCounter({
    @required this.numActive,
    @required this.numCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return AppLoading(builder: (context, vm) {
      return vm.isLoading
          ? LoadingIndicator(key: Key('__statsLoading__'))
          : _buildStats(context);
    });
  }

  Widget _buildStats(BuildContext context) {
    final formatter = NumberFormat("###,###.###", "pt-br");
    String numCompletedFormatted = formatter.format(numCompleted);

    return Center(
      child: Text('Rp $numCompletedFormatted',
          style: TextStyle(
            fontSize: 35.0,
            color: Color(0xFF1F94E5), //!GANTI
          )),
    );
  }
}
