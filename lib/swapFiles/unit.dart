// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';

/// Information about a [Unit].
class Unit implements Comparable<Unit>{
  final String name;
  final double conversion;

  /// A [Unit] stores its name and conversion factor.
  ///
  /// An example would be 'Meter' and '1.0'.
  const Unit({
    @required this.name,
    @required this.conversion,
  })  : assert(name != null),
        assert(conversion != null);

  @override
  int compareTo(Unit other) {
    return this.name.compareTo(other.name);
  }

  /// Creates a [Unit] from a JSON object.
  Unit.fromJson(Map jsonMap)
      : name = jsonMap['name'],
        conversion = jsonMap['conversion'].toDouble(),
        assert(name != null),
        assert(conversion != null);
}