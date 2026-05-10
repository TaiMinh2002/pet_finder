import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/map_marker_data.dart';
import '../../services/map_location_service.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit(this._locationService) : super(const MapInitial());

  final MapLocationService _locationService;

  Future<void> initialize() async {
    emit(const MapLocationLoading());

    final permissionStatus = await _locationService.checkAndRequestPermission();

    switch (permissionStatus) {
      case LocationPermissionStatus.granted:
        final position = await _locationService.getCurrentLocation();
        final userPos = position ?? _locationService.hanoiCenter;
        emit(
          MapLocationGranted(
            userPosition: userPos,
            markers: MapMarkerData.mockMarkers,
            hasUrgentAlert: MapMarkerData.mockMarkers.any(
              (m) => m.type.name == 'urgent',
            ),
          ),
        );
      case LocationPermissionStatus.denied:
        emit(const MapLocationDenied());
      case LocationPermissionStatus.deniedForever:
        emit(const MapLocationDeniedForever());
      case LocationPermissionStatus.serviceDisabled:
        emit(const MapServiceDisabled());
    }
  }

  Future<void> retryPermission() => initialize();

  Future<void> openSettings() => _locationService.openAppSettings();

  Future<void> openLocationSettings() =>
      _locationService.openLocationSettings();

  void selectMarker(MapMarkerData? marker) {
    final current = state;
    if (current is MapLocationGranted) {
      emit(current.copyWith(selectedMarker: marker));
    }
  }

  void dismissMarker() {
    final current = state;
    if (current is MapLocationGranted) {
      emit(current.copyWith(selectedMarker: null));
    }
  }

  void setFilter(MapFilterType filter) {
    final current = state;
    if (current is MapLocationGranted) {
      emit(current.copyWith(activeFilter: filter, selectedMarker: null));
    }
  }

  void centerOnUser() {
    // triggers map controller centering in the UI layer
  }

  Future<void> refreshLocation() async {
    final current = state;
    if (current is! MapLocationGranted) return;
    final position = await _locationService.getCurrentLocation();
    if (position != null && !isClosed) {
      emit(current.copyWith(userPosition: position));
    }
  }

  void useHanoiCenter() {
    emit(
      MapLocationGranted(
        userPosition: _locationService.hanoiCenter,
        markers: MapMarkerData.mockMarkers,
        hasUrgentAlert: true,
      ),
    );
  }
}
