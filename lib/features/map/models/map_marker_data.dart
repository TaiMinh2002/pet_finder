import 'package:latlong2/latlong.dart';

import 'map_marker_type.dart';

class MapMarkerData {
  const MapMarkerData({
    required this.id,
    required this.petName,
    required this.type,
    required this.position,
    required this.distanceLabel,
    required this.lastSeenLabel,
    required this.locationLabel,
    this.petDescription,
    this.reporterName,
    this.timeAgoLabel,
  });

  final String id;
  final String petName;
  final MapMarkerType type;
  final LatLng position;
  final String distanceLabel;
  final String lastSeenLabel;
  final String locationLabel;
  final String? petDescription;
  final String? reporterName;
  final String? timeAgoLabel;

  static final mockMarkers = <MapMarkerData>[
    MapMarkerData(
      id: 'marker_1',
      petName: 'Milo',
      type: MapMarkerType.lost,
      position: const LatLng(21.0285, 105.8542),
      distanceLabel: '0.8 km',
      lastSeenLabel: '2h ago near Hoàn Kiếm Lake',
      locationLabel: 'Hoàn Kiếm, Hà Nội',
      petDescription:
          'Cream tabby, teal collar. Last update around P. Lý Thái Tổ.',
      reporterName: 'Nguyen Chi Thanh',
      timeAgoLabel: '21 ago',
    ),
    MapMarkerData(
      id: 'marker_2',
      petName: 'Bella',
      type: MapMarkerType.lost,
      position: const LatLng(21.0420, 105.8380),
      distanceLabel: '1.2 km',
      lastSeenLabel: '4h ago near Ba Đình',
      locationLabel: 'Ba Đình, Hà Nội',
      petDescription: 'Golden Retriever, wearing red bandana.',
      reporterName: 'Tran Minh Duc',
      timeAgoLabel: '4h ago',
    ),
    MapMarkerData(
      id: 'marker_3',
      petName: 'Luna',
      type: MapMarkerType.reunited,
      position: const LatLng(21.0180, 105.8450),
      distanceLabel: '2.1 km',
      lastSeenLabel: 'Reunited yesterday',
      locationLabel: 'Đống Đa, Hà Nội',
      petDescription: 'White Persian cat, found by neighbors.',
      reporterName: 'Le Thu Hoa',
      timeAgoLabel: '1d ago',
    ),
    MapMarkerData(
      id: 'marker_4',
      petName: 'Biscuit',
      type: MapMarkerType.found,
      position: const LatLng(21.0330, 105.7990),
      distanceLabel: '3.4 km',
      lastSeenLabel: 'Found this morning near Cầu Giấy',
      locationLabel: 'Cầu Giấy, Hà Nội',
      petDescription: 'Brown Shiba Inu, friendly, no collar.',
      reporterName: 'Pham Viet Hung',
      timeAgoLabel: '6h ago',
    ),
    MapMarkerData(
      id: 'marker_5',
      petName: 'Coco',
      type: MapMarkerType.urgent,
      position: const LatLng(21.0120, 105.8610),
      distanceLabel: '2.8 km',
      lastSeenLabel: '300m from you in Đống Đa',
      locationLabel: 'Hai Bà Trưng, Hà Nội',
      petDescription: 'New sighting 300m from you in Đống Đa.',
      reporterName: 'Nguyen Van An',
      timeAgoLabel: '8 min ago',
    ),
    MapMarkerData(
      id: 'marker_6',
      petName: 'Kiwi',
      type: MapMarkerType.found,
      position: const LatLng(21.0600, 105.8210),
      distanceLabel: '4.0 km',
      lastSeenLabel: 'Found near Tây Hồ',
      locationLabel: 'Tây Hồ, Hà Nội',
      petDescription: 'Green parakeet, very friendly.',
      reporterName: 'Hoang Thi Lan',
      timeAgoLabel: '1h ago',
    ),
  ];
}
