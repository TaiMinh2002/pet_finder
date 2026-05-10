import 'package:latlong2/latlong.dart';

import '../../models/map_marker_data.dart';
import '../../models/map_marker_type.dart';

enum MapFilterType { all, lost, found, urgent, seen }

sealed class MapState {
  const MapState();
}

final class MapInitial extends MapState {
  const MapInitial();
}

final class MapLocationLoading extends MapState {
  const MapLocationLoading();
}

final class MapLocationGranted extends MapState {
  const MapLocationGranted({
    required this.userPosition,
    required this.markers,
    this.selectedMarker,
    this.activeFilter = MapFilterType.all,
    this.hasUrgentAlert = false,
  });

  final LatLng userPosition;
  final List<MapMarkerData> markers;
  final MapMarkerData? selectedMarker;
  final MapFilterType activeFilter;
  final bool hasUrgentAlert;

  List<MapMarkerData> get filteredMarkers => switch (activeFilter) {
    MapFilterType.all => markers,
    MapFilterType.lost =>
      markers.where((m) => m.type == MapMarkerType.lost).toList(),
    MapFilterType.found =>
      markers.where((m) => m.type == MapMarkerType.found).toList(),
    MapFilterType.urgent =>
      markers.where((m) => m.type == MapMarkerType.urgent).toList(),
    MapFilterType.seen =>
      markers.where((m) => m.type == MapMarkerType.reunited).toList(),
  };

  MapLocationGranted copyWith({
    LatLng? userPosition,
    List<MapMarkerData>? markers,
    Object? selectedMarker = _sentinel,
    MapFilterType? activeFilter,
    bool? hasUrgentAlert,
  }) {
    return MapLocationGranted(
      userPosition: userPosition ?? this.userPosition,
      markers: markers ?? this.markers,
      selectedMarker: selectedMarker == _sentinel
          ? this.selectedMarker
          : selectedMarker as MapMarkerData?,
      activeFilter: activeFilter ?? this.activeFilter,
      hasUrgentAlert: hasUrgentAlert ?? this.hasUrgentAlert,
    );
  }
}

final class MapLocationDenied extends MapState {
  const MapLocationDenied();
}

final class MapLocationDeniedForever extends MapState {
  const MapLocationDeniedForever();
}

final class MapServiceDisabled extends MapState {
  const MapServiceDisabled();
}

const _sentinel = Object();
