import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../models/map_marker_data.dart';
import '../../services/map_location_service.dart';
import '../bloc/map_cubit.dart';
import '../bloc/map_state.dart';
import '../widgets/map_control_buttons.dart';
import '../widgets/map_custom_marker.dart';
import '../widgets/map_filter_chips.dart';
import '../widgets/map_legend.dart';
import '../widgets/map_permission_view.dart';
import '../widgets/map_search_bar.dart';
import '../widgets/map_selected_sheet.dart';
import '../widgets/map_urgent_banner.dart';

final _hanoiBounds = LatLngBounds(
  const LatLng(20.85, 105.65),
  const LatLng(21.25, 106.05),
);

class NearbyAlertsMapScreen extends StatelessWidget {
  const NearbyAlertsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapCubit(MapLocationService())..initialize(),
      child: const _NearbyAlertsMapView(),
    );
  }
}

class _NearbyAlertsMapView extends StatefulWidget {
  const _NearbyAlertsMapView();

  @override
  State<_NearbyAlertsMapView> createState() => _NearbyAlertsMapViewState();
}

class _NearbyAlertsMapViewState extends State<_NearbyAlertsMapView>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _sheetAnimController;
  late Animation<Offset> _sheetSlideAnimation;

  @override
  void initState() {
    super.initState();
    _sheetAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _sheetSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _sheetAnimController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _sheetAnimController.dispose();
    super.dispose();
  }

  static const _defaultZoom = 14.5;

  void _animateTo(LatLng target) {
    final animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final animation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOutCubic,
    );

    final from = _mapController.camera.center;
    final fromZoom = _mapController.camera.zoom;

    animation.addListener(() {
      final lat =
          from.latitude + (target.latitude - from.latitude) * animation.value;
      final lng =
          from.longitude +
          (target.longitude - from.longitude) * animation.value;
      final z = fromZoom + (_defaultZoom - fromZoom) * animation.value;
      _mapController.move(LatLng(lat, lng), z);
    });

    animController.addStatusListener((s) {
      if (s == AnimationStatus.completed) animController.dispose();
    });

    animController.forward();
  }

  void _onMarkerTapped(MapMarkerData marker) {
    context.read<MapCubit>().selectMarker(marker);
    _sheetAnimController.forward();
    _animateTo(marker.position);
  }

  void _onDismissSheet() {
    _sheetAnimController.reverse().then((_) {
      if (mounted) context.read<MapCubit>().dismissMarker();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MapCubit, MapState>(
        listener: (context, state) {
          if (state is MapLocationGranted && state.selectedMarker == null) {
            _sheetAnimController.reverse();
          }
        },
        child: BlocBuilder<MapCubit, MapState>(
          builder: (context, state) {
            return switch (state) {
              MapInitial() || MapLocationLoading() => _buildLoading(),
              MapLocationGranted() => _buildMap(context, state),
              MapLocationDenied() => _buildPermissionView(state),
              MapLocationDeniedForever() => _buildPermissionView(state),
              MapServiceDisabled() => _buildPermissionView(state),
            };
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF4E6), Color(0xFFDDF7F6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: MapSearchBar(
                  onNotificationTap: () =>
                      context.goNamed(AppRoute.notifications.name),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 44,
                        height: 44,
                        child: CircularProgressIndicator(
                          color: AppColors.teal,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.mapLoadingLocation,
                        style: AppTextStyles.body.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionView(MapState state) {
    final cubit = context.read<MapCubit>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF4E6), Color(0xFFDDF7F6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: MapSearchBar(
                  onNotificationTap: () =>
                      context.goNamed(AppRoute.notifications.name),
                ),
              ),
              Expanded(
                child: MapPermissionView(
                  stateType: state.runtimeType,
                  onRetry: cubit.retryPermission,
                  onOpenSettings: state is MapServiceDisabled
                      ? cubit.openLocationSettings
                      : cubit.openSettings,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                child: _MapBottomNavigation(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context, MapLocationGranted state) {
    final cubit = context.read<MapCubit>();
    final hasSelected = state.selectedMarker != null;
    final urgentMarker = state.markers
        .where((m) => m.type.name == 'urgent')
        .firstOrNull;

    return Scaffold(
      body: Stack(
        children: [
          _MapTiles(
            mapController: _mapController,
            markers: state.filteredMarkers,
            userPosition: state.userPosition,
            selectedMarker: state.selectedMarker,
            onMarkerTapped: _onMarkerTapped,
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MapSearchBar(
                    onNotificationTap: () =>
                        context.goNamed(AppRoute.notifications.name),
                  ),
                  const SizedBox(height: 10),
                  MapFilterChips(
                    activeFilter: state.activeFilter,
                    onFilterChanged: cubit.setFilter,
                  ),
                  if (!hasSelected &&
                      state.hasUrgentAlert &&
                      urgentMarker != null) ...[
                    const SizedBox(height: 10),
                    MapUrgentBanner(marker: urgentMarker),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 200,
            child: Column(
              children: [
                MapFilterButton(onTap: () {}),
                const SizedBox(height: 10),
                MapLocationButton(
                  onTap: () {
                    _animateTo(state.userPosition);
                    cubit.refreshLocation();
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            bottom: 160,
            child: MapLegend(count: state.filteredMarkers.length),
          ),
          if (!hasSelected && state.filteredMarkers.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 100,
              child: _MapBottomPreviewStrip(
                marker: state.filteredMarkers.first,
                onTap: () => _onMarkerTapped(state.filteredMarkers.first),
              ),
            ),
          if (hasSelected)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: _sheetSlideAnimation,
                child: MapSelectedSheet(
                  marker: state.selectedMarker!,
                  onDismiss: _onDismissSheet,
                  onViewDetails: () {
                    _onDismissSheet();
                    context.goNamed(
                      AppRoute.reportDetail.name,
                      pathParameters: {'reportId': state.selectedMarker!.id},
                    );
                  },
                  onContact: _onDismissSheet,
                  onNavigate: _onDismissSheet,
                ),
              ),
            ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 22,
            child: _MapBottomNavigation(),
          ),
        ],
      ),
    );
  }
}

class _MapTiles extends StatelessWidget {
  const _MapTiles({
    required this.mapController,
    required this.markers,
    required this.userPosition,
    required this.selectedMarker,
    required this.onMarkerTapped,
  });

  final MapController mapController;
  final List<MapMarkerData> markers;
  final LatLng userPosition;
  final MapMarkerData? selectedMarker;
  final ValueChanged<MapMarkerData> onMarkerTapped;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: userPosition,
        initialZoom: 13.5,
        minZoom: 11.0,
        maxZoom: 17.0,
        cameraConstraint: CameraConstraint.containCenter(bounds: _hanoiBounds),
        backgroundColor: const Color(0xFFF8E8D8),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.petfinder.app',
          tileBuilder: _warmTileBuilder,
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: userPosition,
              width: 36,
              height: 36,
              child: const MapCurrentLocationMarker(),
            ),
            for (final marker in markers)
              Marker(
                point: marker.position,
                width: selectedMarker?.id == marker.id ? 52 : 44,
                height: selectedMarker?.id == marker.id ? 52 : 44,
                child: GestureDetector(
                  onTap: () => onMarkerTapped(marker),
                  child: MapCustomMarker(
                    type: marker.type,
                    isSelected: selectedMarker?.id == marker.id,
                    size: selectedMarker?.id == marker.id ? 44 : 38,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _warmTileBuilder(
    BuildContext context,
    Widget tile,
    TileImage tileImage,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        1.05,
        0,
        0,
        0,
        8,
        0,
        0.98,
        0,
        0,
        4,
        0,
        0,
        0.92,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: tile,
    );
  }
}

class _MapBottomPreviewStrip extends StatelessWidget {
  const _MapBottomPreviewStrip({required this.marker, required this.onTap});

  final MapMarkerData marker;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E6),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x24A6482A),
              blurRadius: 28,
              offset: Offset(0, -8),
            ),
          ],
          border: Border.all(
            color: AppColors.peach.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.peach,
                    marker.type.color.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.pets_rounded,
                color: marker.type.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: marker.type.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _badgeLabel(context, marker),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${marker.petName} · ${marker.distanceLabel} ${context.l10n.mapAway}',
                          style: AppTextStyles.bodyStrong.copyWith(
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    marker.petDescription ?? marker.lastSeenLabel,
                    style: AppTextStyles.caption.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_rounded,
                        size: 11,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        marker.locationLabel,
                        style: AppTextStyles.caption.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                context.l10n.mapView,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _badgeLabel(BuildContext context, MapMarkerData m) =>
      switch (m.type.name) {
        'lost' => context.l10n.mapBadgeLost,
        'found' => context.l10n.mapBadgeFound,
        'urgent' => context.l10n.mapBadgeUrgent,
        _ => context.l10n.mapBadgeReunited,
      };
}

class _MapBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        AppBottomNav(
          currentIndex: 1,
          onChanged: (index) {
            if (index == 0) context.goNamed(AppRoute.home.name);
            if (index == 1) context.goNamed(AppRoute.mapNearby.name);
            if (index == 2) context.goNamed(AppRoute.petsList.name);
            if (index == 3) context.goNamed(AppRoute.profileOverview.name);
          },
          items: [
            AppBottomNavItem(
              icon: Icons.home_rounded,
              label: context.l10n.mapNavHome,
            ),
            AppBottomNavItem(
              icon: Icons.map_outlined,
              label: context.l10n.mapNavMap,
            ),
            AppBottomNavItem(icon: Icons.pets, label: context.l10n.mapNavPets),
            AppBottomNavItem(
              icon: Icons.person_outline,
              label: context.l10n.mapNavProfile,
            ),
          ],
        ),
        Positioned(
          top: -18,
          child: GestureDetector(
            onTap: () => context.goNamed(AppRoute.reportCreate.name),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.coral,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x42D83B2D),
                    blurRadius: 28,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: AppColors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}
