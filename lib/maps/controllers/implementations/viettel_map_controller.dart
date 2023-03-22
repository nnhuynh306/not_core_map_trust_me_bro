import 'package:maps_core/maps/extensions/convert.dart';
import 'package:maps_core/maps/extensions/extensions.dart';
import 'package:maps_core/maps/controllers/base_core_map_controller.dart';
import 'package:maps_core/maps/controllers/core_map_controller.dart';
import 'package:maps_core/maps/models/core_map_data.dart';
import 'package:maps_core/maps/models/core_map_type.dart';
import 'package:maps_core/maps/models/polygon.dart';
import 'package:maps_core/maps/models/polyline.dart';
import 'package:maps_core/maps/models/viettel/viettel_polygon.dart';

import 'package:vtmap_gl/vtmap_gl.dart' as vt;

import '../../models/core_map_callbacks.dart';
import '../../models/lat_lng.dart';

class ViettelMapController extends BaseCoreMapController {

  final vt.MapboxMapController _controller;

  CoreMapData _data;

  final Map<String, ViettelPolygon> _viettelPolygonMap = {};

  final Map<String, vt.Line> _viettelPolylineMap = {};

  ViettelMapController(this._controller, {
    required CoreMapData data,
    CoreMapCallbacks? callback,
  }): _data = data, super(callback);

  @override
  CoreMapType get coreMapType => CoreMapType.viettel;

  @override
  Future<void> addPolygon(Polygon polygon) async {
    if (data.polygons.any((e) => e.id == polygon.id)) {
      return;
    }

    final fill = await _controller.addFill(polygon.toFillOptions());

    final outlineOptions = polygon.getOutlineLineOptions();
    List<Future<vt.Line>> outlineFutures = [];
    for (final outlineOption in outlineOptions) {
      outlineFutures.add(_controller.addLine(outlineOption));
    }
    final outlines = await Future.wait(outlineFutures);

    _viettelPolygonMap.putIfAbsent(polygon.id, () => ViettelPolygon(polygon.id, fill, outlines));
    data.polygons.add(polygon);
  }


  @override
  Future<void> removePolygon(String polygonId) async {
    if (_viettelPolygonMap.containsKey(polygonId)) {
      final polygon = _viettelPolygonMap[polygonId];

      if (polygon != null) {
        _controller.removeFill(polygon.fill);

        for (final outline in polygon.outlines) {
          _controller.removeLine(outline);
        }

        data.polygons.removeWhere((polygon) => polygon.id == polygonId);
        _viettelPolygonMap.removeWhere((key, value) => key == polygonId);
      }
    }
  }

  @override
  Future<void> reloadWithData(CoreMapData data) async {
    _data = data;
    _controller.moveCamera(vt.CameraUpdate.newCameraPosition(
        data.initialCameraPosition.toViettel()));

    _clearShapes();
    _addShapes(data);
  }

  @override
  CoreMapData get data => _data;

  @override
  void onDispose() {
    _controller.dispose();
  }

  Future<void> _addShapes(CoreMapData data) async {
    for (var polygon in data.polygons) {
      addPolygon(polygon);
    }
  }

  Future<void> _clearShapes() async {
    _controller.clearCircles();
    _controller.clearLines();
    _controller.clearSymbols();
    _controller.clearRoute();

    _viettelPolygonMap.clear();
  }

  void onMapLoaded() {
    _addShapes(_data);
  }

  @override
  Future<void> addPolyline(Polyline polyline) async {
    if (data.polylines.any((e) => e.id == polyline.id)) {
      return;
    }

    data.polylines.add(polyline);
    final line = await _controller.addLine(polyline.toLineOptions());
    _viettelPolylineMap.putIfAbsent(polyline.id, () => line);
  }

  @override
  Future<void> removePolyline(String polylineId) async {
    if (_viettelPolylineMap.containsKey(polylineId)) {
      final line = _viettelPolylineMap[polylineId];

      if (line != null) {
        _controller.removeLine(line);

        data.polylines.removeWhere((e) => e.id == polylineId);
        _viettelPolylineMap.removeWhere((key, value) => key == polylineId);
      }
    }
  }
}