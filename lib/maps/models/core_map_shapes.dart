import 'map_objects/map_objects.dart';

///Data object for map shapes. Just for convenient
class CoreMapShapes {

  ///CoreMap Polygon
  final Set<Polygon> polygons;

  ///CoreMap Polyline
  final Set<Polyline> polylines;

  ///CoreMap Circle
  final Set<Circle> circles;

  ///CoreMap Markers
  final Set<Marker> markers;

  CoreMapShapes({
    Set<Polygon>? polygons,
    Set<Polyline>? polylines,
    Set<Circle>? circles,
    Set<Marker>? markers,
  }): polygons = polygons ?? {},
        polylines = polylines ?? {},
        circles = circles ?? {},
        markers = markers ?? {};
}