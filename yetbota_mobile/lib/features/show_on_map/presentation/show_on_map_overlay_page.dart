import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:yetbota_mobile/app/theme/app_theme.dart';
import 'package:yetbota_mobile/common/ui/widgets/bottom_nav.dart';
import 'package:yetbota_mobile/features/discovery_feed/presentation/widgets/discovery_comments_sheet.dart';

const _kShowOnMapDirectionsIcon =
    'https://www.figma.com/api/mcp/asset/73241813-0e5b-43c2-9b2b-597a778e9b05';

class ShowOnMapViewData {
  const ShowOnMapViewData({
    this.latitude = _defaultLat,
    this.longitude = _defaultLng,
  });

  /// Addis Ababa (approx.) — used when a post has no coordinates yet.
  static const double _defaultLat = 9.032;
  static const double _defaultLng = 38.748;

  final double latitude;
  final double longitude;
}

Future<void> showShowOnMapSheet(
  BuildContext context, {
  ShowOnMapViewData? data,
}) {
  final palette = DiscoveryCommentsSheetPalette.fromTheme(context);
  final resolved = data ?? const ShowOnMapViewData();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: palette.barrierColor,
    builder: (context) {
      return ShowOnMapSheet(
        latitude: resolved.latitude,
        longitude: resolved.longitude,
        palette: palette,
      );
    },
  );
}

class ShowOnMapSheet extends StatelessWidget {
  const ShowOnMapSheet({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.palette,
  });

  final double latitude;
  final double longitude;
  final DiscoveryCommentsSheetPalette palette;

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    final aboveNav = BottomNav.mainShellHeight(context) - BottomNav.fabSize/2;
    final sheetHeight = (screenH * 0.58).clamp(420.0, 620.0);
    final point = LatLng(latitude, longitude);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: aboveNav),
      child: Container(
        height: sheetHeight,
        decoration: BoxDecoration(
          color: palette.sheetBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          border: Border(top: BorderSide(color: palette.strongBorder)),
          boxShadow: [
            BoxShadow(
              color: palette.sheetShadow,
              blurRadius: 40,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: palette.handle,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
                child: _MapFrame(
                  point: point,
                  isDark: isDark,
                  palette: palette,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapFrame extends StatelessWidget {
  const _MapFrame({
    required this.point,
    required this.isDark,
    required this.palette,
  });

  final LatLng point;
  final bool isDark;
  final DiscoveryCommentsSheetPalette palette;

  @override
  Widget build(BuildContext context) {
    final borderColor = palette.weakBorder;
    final mapBg =
        isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F5F9);
    final liveChipBg = isDark
        ? const Color(0x99000000)
        : const Color(0xE6FFFFFF);
    final liveChipBorder = isDark
        ? const Color(0x33FFFFFF)
        : const Color(0x26000000);
    const tileUserAgent = 'com.yetbota.yetbota_mobile';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: point,
              initialZoom: 15,
              minZoom: 3,
              maxZoom: 19,
              backgroundColor: mapBg,
            ),
            children: [
              TileLayer(
                urlTemplate: isDark
                    ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: tileUserAgent,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: point,
                    width: 48,
                    height: 48,
                    alignment: Alignment.bottomCenter,
                    child: Icon(
                      Icons.location_on,
                      size: 48,
                      color: AppTheme.primary,
                      shadows: [
                        Shadow(
                          color: (isDark ? Colors.black : const Color(0xFF0F172A))
                              .withValues(alpha: 0.45),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 12,
            top: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: liveChipBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: liveChipBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        size: 12,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE MAP',
                        style: TextStyle(
                          color: palette.primaryText,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                customBorder: const CircleBorder(),
                child: Ink(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary500a4D,
                        offset: Offset(0, 6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.network(
                      _kShowOnMapDirectionsIcon,
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.turn_right,
                          size: 24,
                          color: Colors.black,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
