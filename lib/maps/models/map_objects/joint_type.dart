// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show immutable;
import 'package:google_maps_flutter/google_maps_flutter.dart' as ggmap;
import 'package:vtmap_gl/vtmap_gl.dart' as vtmap;

/// Joint types for [Polyline].
@immutable
class JointType {
  const JointType._(this.value);

  /// The value representing the [JointType] on the sdk.
  final int value;

  /// Mitered joint, with fixed pointed extrusion equal to half the stroke width on the outside of the joint.
  ///
  /// Constant Value: 0
  static const JointType mitered = JointType._(0);

  /// Flat bevel on the outside of the joint.
  ///
  /// Constant Value: 1
  static const JointType bevel = JointType._(1);

  /// Rounded on the outside of the joint by an arc of radius equal to half the stroke width, centered at the vertex.
  ///
  /// Constant Value: 2
  static const JointType round = JointType._(2);

  ggmap.JointType toGoogle() {
    switch (this) {
      case JointType.bevel:
        return ggmap.JointType.bevel;
      case JointType.mitered:
        return ggmap.JointType.mitered;
      case JointType.round:
        return ggmap.JointType.round;
      default:
        return ggmap.JointType.bevel;
    }
  }

  String toViettel() {
    switch (this) {
      case JointType.bevel:
        return "bevel";
      case JointType.mitered:
        return "mitered";
      case JointType.round:
        return "round";
      default:
        return "bevel";
    }
  }
}
