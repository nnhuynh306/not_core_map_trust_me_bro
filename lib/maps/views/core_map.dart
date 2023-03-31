import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:maps_core/maps.dart';
import 'package:maps_core/maps/constants.dart';
import 'package:maps_core/maps/models/core_map_callbacks.dart';
import 'package:maps_core/maps/models/core_map_shapes.dart';
import 'package:maps_core/maps/views/core_google_map.dart';
import 'package:maps_core/maps/views/core_viettel_map.dart';

import '../models/core_map_data.dart';
import '../models/core_map_type.dart';

class CoreMap extends StatefulWidget {

  final CoreMapType type;

  final CoreMapData data;

  final CoreMapShapes? shapes;

  final CoreMapCallbacks? callbacks;

  const CoreMap({super.key,
    this.type = CoreMapType.viettel,
    this.callbacks,
    required this.data,
    this.shapes,
  });

  @override
  State<CoreMap> createState() => _CoreMapState();
}

class _CoreMapState extends State<CoreMap> {

  CoreMapController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CoreMapCallbacks callbacks = widget.callbacks ?? CoreMapCallbacks();
    return _buildMap(widget.type,
      widget.data.copyWith(
          initialCameraPosition: _controller?.getCurrentPosition() ?? widget.data.initialCameraPosition
      ),
      callbacks: callbacks.copyWith(
        onMapCreated: (controller) {
          _controller = controller;
          widget.callbacks?.onMapCreated?.call(controller);
        },
      ),
    );
  }

  Widget _buildMap(CoreMapType type, CoreMapData data, {
    CoreMapCallbacks? callbacks,
  }) {
    switch (type) {
      case CoreMapType.google:
        return CoreGoogleMap(
          data: data,
          callbacks: callbacks,
        );
      case CoreMapType.viettel:
        return CoreViettelMap(
          data: data,
          callbacks: callbacks,
        );
    }
  }
}