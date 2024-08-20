import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PolylineAnimationExample extends StatefulWidget {
  @override
  _PolylineAnimationExampleState createState() => _PolylineAnimationExampleState();
}

class _PolylineAnimationExampleState extends State<PolylineAnimationExample> {
  Completer<GoogleMapController> _controller = Completer();
  List<LatLng> _polylineCoordinates = [];
  
    late LatLng _userLocation = LatLng(10.248695981717644, 123.85233531982266);
   late LatLng _driverLocation = LatLng(10.281942320779438, 123.8806389817219); // Example driver location

 bool _isMapLoading = true;
 Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final apiKey = 'AIzaSyDNQDYD_Gf_z1nyammhkEPwOBeP_fP6VYc'; // Replace with your API key
    final url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${_userLocation.latitude},${_userLocation.longitude}'
        '&destination=${_driverLocation.latitude},${_driverLocation.longitude}'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {

     
      final data = json.decode(response.body);
       print('RESPONSE ${data}');
      final encodedPolyline = data['routes'][0]['overview_polyline']['points'];
      final polylinePoints = _decodePolyline(encodedPolyline);
        _animateRoute(polylinePoints);
        _addMarkers();
    } else {
      // Handle the error
      print('Failed to fetch route');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int lat = 0;
    int lng = 0;
    while (index < encoded.length) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;
      polyline.add(LatLng(
        (lat / 1E5).toDouble(),
        (lng / 1E5).toDouble(),
      ));
    }
    return polyline;
  }

  void _addMarkers() {
    _markers.add(
      Marker(
        markerId: MarkerId('user'),
        position: _userLocation,
        infoWindow: InfoWindow(title: 'User Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('driver'),
        position: _driverLocation,
        infoWindow: InfoWindow(title: 'Driver Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  Future<void> _animateRoute(List<LatLng> polylinePoints) async {
    
    
    const int animationDuration = 10000; // Duration of animation in milliseconds
    const int updateInterval = 100; // Interval between position updates in milliseconds

    final int numUpdates = (animationDuration / updateInterval).round();
    final List<LatLng> points = polylinePoints;
    final GoogleMapController controller = await _controller.future;

    Timer.periodic(Duration(milliseconds: updateInterval), (Timer timer) {
      if (points.isEmpty) {
        timer.cancel();
        return;
      }

      LatLng currentPosition = points.removeAt(0);
      setState(() {
        
        _polylineCoordinates.add(currentPosition);

                    controller.animateCamera(
        CameraUpdate.newLatLng(currentPosition),
      );
      });

     

      if (_polylineCoordinates.length == numUpdates) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Google Maps Curved Polyline Animation')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                 setState(() => _isMapLoading = false);
                _controller.complete(controller);
            
                print('Map Loaded');
               
              },
              initialCameraPosition: CameraPosition(
                target: _userLocation,
                zoom: 12.5,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId('animated_polyline'),
                  points: _polylineCoordinates,
                  color: Colors.red,
                  width: 5,
                ),
              },
              markers: _markers,
            ),
          //     (_isMapLoading)
          // ? Container(
          //     height: double.infinity,
          //     width: double.infinity,
          //     color: Colors.grey[100],
          //     child: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   )
          // : Container(),
          ],
        ),
      ),
    );
  }
}


// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';


// class PolylineAnimationExample extends StatefulWidget {
//   @override
//   _PolylineAnimationExampleState createState() => _PolylineAnimationExampleState();
// }

// class _PolylineAnimationExampleState extends State<PolylineAnimationExample> {
//   Completer<GoogleMapController> _controller = Completer();
//   List<LatLng> _polylineCoordinates = [];
  
//     late LatLng _userLocation = LatLng(10.248695981717644, 123.85233531982266);
//    late LatLng _driverLocation = LatLng(10.281942320779438, 123.8806389817219); // Example driver location


//   @override
//   void initState() {
//     super.initState();
//     _fetchRoute();
//   }

//   Future<void> _fetchRoute() async {
//     final apiKey = 'AIzaSyDNQDYD_Gf_z1nyammhkEPwOBeP_fP6VYc'; // Replace with your API key
//     final url = 'https://maps.googleapis.com/maps/api/directions/json'
//         '?origin=${_userLocation.latitude},${_userLocation.longitude}'
//         '&destination=${_driverLocation.latitude},${_driverLocation.longitude}'
//         '&key=$apiKey';

//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {

     
//       final data = json.decode(response.body);
//        print('RESPONSE ${data}');
//       final encodedPolyline = data['routes'][0]['overview_polyline']['points'];
//       final polylinePoints = _decodePolyline(encodedPolyline);
//         _animateRoute(polylinePoints);
//     } else {
//       // Handle the error
//       print('Failed to fetch route');
//     }
//   }

//   List<LatLng> _decodePolyline(String encoded) {
//     List<LatLng> polyline = [];
//     int index = 0;
//     int lat = 0;
//     int lng = 0;
//     while (index < encoded.length) {
//       int b;
//       int shift = 0;
//       int result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//       lat += deltaLat;
//       shift = 0;
//       result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//       lng += deltaLng;
//       polyline.add(LatLng(
//         (lat / 1E5).toDouble(),
//         (lng / 1E5).toDouble(),
//       ));
//     }
//     return polyline;
//   }

//   Future<void> _animateRoute(List<LatLng> polylinePoints) async {
    
    
//     const int animationDuration = 10000; // Duration of animation in milliseconds
//     const int updateInterval = 100; // Interval between position updates in milliseconds

//     final int numUpdates = (animationDuration / updateInterval).round();
//     final List<LatLng> points = polylinePoints;
//     final GoogleMapController controller = await _controller.future;

//     Timer.periodic(Duration(milliseconds: updateInterval), (Timer timer) {
//       if (points.isEmpty) {
//         timer.cancel();
//         return;
//       }

//       LatLng currentPosition = points.removeAt(0);
//       setState(() {
        
//         _polylineCoordinates.add(currentPosition);

//                     controller.animateCamera(
//         CameraUpdate.newLatLng(currentPosition),
//       );
//       });

//       controller.animateCamera(
//         CameraUpdate.newLatLng(currentPosition),
//       );

//       if (_polylineCoordinates.length == numUpdates) {
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(title: Text('Google Maps Curved Polyline Animation')),
//       body: GoogleMap(
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);

//           print('Map Loaded');
         
//         },
//         initialCameraPosition: CameraPosition(
//           target: _userLocation,
//           zoom: 12.4,
//         ),
//         polylines: {
//           Polyline(
//             polylineId: PolylineId('animated_polyline'),
//             points: _polylineCoordinates,
//             color: Colors.red,
//             width: 5,
//           ),
//         },
//           markers: {
//           Marker(
//             markerId: MarkerId('user_location'),
//             position: _userLocation,
//             infoWindow: InfoWindow(title: 'User Location'),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           ),
//           Marker(
//             markerId: MarkerId('driver_location'),
//             position: _driverLocation,
//             infoWindow: InfoWindow(title: 'Driver Location'),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           ),
//         },
//       ),
//     );
//   }
// }

// class PolylineAnimationExample extends StatefulWidget {
//   @override
//   _PolylineAnimationExampleState createState() => _PolylineAnimationExampleState();
// }

// class _PolylineAnimationExampleState extends State<PolylineAnimationExample> {
//   Completer<GoogleMapController> _controller = Completer();
//   List<LatLng> _polylineCoordinates = [];

//      late LatLng _userLocation = LatLng(10.2524, 123.8392);
//    late LatLng _driverLocation = LatLng(10.3114, 123.9180); // Example driver location


//   @override
//   void initState() {
//     super.initState();
//     _animatePolyline();
//   }

//   Future<void> _animatePolyline() async {
//     final GoogleMapController controller = await _controller.future;
//     const int animationDuration = 8000; // Duration of animation in milliseconds
//     const int updateInterval = 200; // Interval between position updates in milliseconds

//     final int numUpdates = (animationDuration / updateInterval).round();
//     final List<LatLng> interpolatedPoints = _getInterpolatedPoints(
//       _userLocation,
//       _driverLocation,
//       numUpdates,
//     );
    
//     Timer.periodic(Duration(milliseconds: updateInterval), (Timer timer) {
//       if (interpolatedPoints.isEmpty) {
//         timer.cancel();
//         return;
//       }
//       setState(() {
//             controller.animateCamera(
//         CameraUpdate.newLatLng(interpolatedPoints[0]),
//       );

//         _polylineCoordinates.add(interpolatedPoints.removeAt(0));
//       });
//       if (_polylineCoordinates.length == numUpdates) {
//         timer.cancel();
//       }
//     });
//   }

//   List<LatLng> _getInterpolatedPoints(LatLng start, LatLng end, int numPoints) {
//     final List<LatLng> points = [];
//     for (int i = 0; i <= numPoints; i++) {
//       final double t = i / numPoints;
//       final double lat = start.latitude + t * (end.latitude - start.latitude);
//       final double lng = start.longitude + t * (end.longitude - start.longitude);
//       points.add(LatLng(lat, lng));
//     }
//     return points;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Google Maps Polyline Animation')),
//       body: GoogleMap(
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         initialCameraPosition: CameraPosition(
//           target: _userLocation,
//            zoom: 12.5,
//         ),
//         polylines: {
//           Polyline(
//             polylineId: PolylineId('animated_polyline'),
//             points: _polylineCoordinates,
//             color: Colors.blue,
//             width: 5,
//           ),
//         },
//          markers: {
//           Marker(
//             markerId: MarkerId('user_location'),
//             position: _userLocation,
//             infoWindow: InfoWindow(title: 'User Location'),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           ),
//           Marker(
//             markerId: MarkerId('driver_location'),
//             position: _driverLocation,
//             infoWindow: InfoWindow(title: 'Driver Location'),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           ),
//         },
//       ),
//     );
//   }
// }

