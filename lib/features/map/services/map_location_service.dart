import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

class MapLocationService {
  static const _hanoiCenter = LatLng(21.0285, 105.8542);

  static const _hanoiBounds = (
    north: 21.25,
    south: 20.85,
    west: 105.65,
    east: 106.05,
  );

  Future<LocationPermissionStatus> checkAndRequestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return switch (permission) {
      LocationPermission.always ||
      LocationPermission.whileInUse => LocationPermissionStatus.granted,
      LocationPermission.deniedForever =>
        LocationPermissionStatus.deniedForever,
      _ => LocationPermissionStatus.denied,
    };
  }

  Future<LatLng?> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      final latLng = LatLng(position.latitude, position.longitude);
      return _clampToHanoi(latLng);
    } catch (_) {
      return null;
    }
  }

  LatLng get hanoiCenter => _hanoiCenter;

  LatLng _clampToHanoi(LatLng position) {
    final clampedLat = position.latitude.clamp(
      _hanoiBounds.south,
      _hanoiBounds.north,
    );
    final clampedLng = position.longitude.clamp(
      _hanoiBounds.west,
      _hanoiBounds.east,
    );
    if (clampedLat == position.latitude && clampedLng == position.longitude) {
      return position;
    }
    return LatLng(clampedLat, clampedLng);
  }

  Future<void> openAppSettings() => Geolocator.openAppSettings();

  Future<void> openLocationSettings() => Geolocator.openLocationSettings();
}
