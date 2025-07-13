import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapPage> {
  final Completer<GoogleMapController> _ctrl = Completer();
  Marker? _pickedMarker;
  String? _pickedAddress;
  String? _currentAddress;
  LatLng? _pickedLatLng;
  CameraPosition? _initialCamera;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _setupLocation();
  }

  Future<void> _setupLocation() async {
    try {
      final pos = await getPermissions();
      _currentPosition = pos;
      _initialCamera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 10.0,
      );

      final placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      final p = placemarks.first;
      _currentAddress = '${p.name},${p.locality},${p.country}';

      setState(() {});
    } catch (e) {
      _initialCamera = const CameraPosition(target: LatLng(0, 0), zoom: 20);
      setState(() {});
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<Position> getPermissions() async {
    //1. cek service Gps
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'Location service belum aktif';
    }
    //2. Cek dan minta permission
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw 'izin lokasi ditolak';
      }
    }
    if (perm == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak permanen';
    }

    //3.Semua oke, amnbil posisi
    return Geolocator.getCurrentPosition();
  }

  Future<void> _onTap(LatLng Latlng) async {
    final placemarks = await placemarkFromCoordinates(
      Latlng.latitude,
      Latlng.longitude,
    );

    final p = placemarks.first;
    setState(() {
      _pickedMarker = Marker(
        markerId: const MarkerId('picked'),
        position: Latlng,
        infoWindow: InfoWindow(
          title: p.name?.isNotEmpty == true ? p.name : 'Lokasi Dipilih',
          snippet: '${p.street},${p.locality}',
        ),
      );
      _pickedLatLng = Latlng;
    });
    final ctrl = await _ctrl.future;
    await ctrl.animateCamera(CameraUpdate.newLatLngZoom(Latlng, 16));

    setState(() {
      _pickedAddress =
          '${p.name},${p.street},${p.locality},${p.country},${p.postalCode}';
    });
  }

  void _confirmSelection() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Konfirmasi Alamat'),
            content: Text(_pickedAddress ?? ''),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, {
                    'address': _pickedAddress,
                    'latitude':
                        _pickedLatLng?.latitude.toString(), // Convert to String
                    'longitude':
                        _pickedLatLng?.longitude
                            .toString(), // Convert to String
                  });
                },
                child: const Text('Pilih'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initialCamera == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Alamat')),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCamera!,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.satellite,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              scrollGesturesEnabled: true,
              zoomControlsEnabled: true,
              rotateGesturesEnabled: true,
              trafficEnabled: true,
              buildingsEnabled: true,
              indoorViewEnabled: true,
              onMapCreated: (GoogleMapController ctrl) {
                _ctrl.complete(ctrl);
              },

              markers: _pickedMarker != null ? {_pickedMarker!} : {},
              onTap: _onTap,
            ),
            Positioned(
              top: 25,
              left: 50,

              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(_currentAddress ?? 'Kosong'),
              ),
            ),
            if (_pickedAddress != null)
              Positioned(
                bottom: 120,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      _pickedAddress!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          if (_pickedAddress != null)
            FloatingActionButton.extended(
              onPressed: _confirmSelection,
              heroTag: 'confirm',
              label: Text('Pilih Alamat'),
            ),
          SizedBox(height: 8),
          if (_pickedAddress != null)
            FloatingActionButton.extended(
              heroTag: 'Clear',
              label: Text('Hapus Alamat'),
              onPressed: () {
                setState(() {
                  _pickedAddress = null;
                  _pickedMarker = null;
                });
              },
            ),
        ],
      ),
    );
  }
}
