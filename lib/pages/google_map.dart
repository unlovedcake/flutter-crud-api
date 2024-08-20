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

// import 'package:geolocator/geolocator.dart';

// class PolylineAnimationExample extends StatefulWidget {
//   @override
//   _PolylineAnimationExampleState createState() => _PolylineAnimationExampleState();
// }

// class _PolylineAnimationExampleState extends State<PolylineAnimationExample> {
//   Completer<GoogleMapController> _controller = Completer();
//   List<LatLng> _polylineCoordinates = [];
//   LatLng? _userLocation = LatLng(10.2524, 123.8392);
//   LatLng _driverLocation = LatLng(10.3114, 123.9180); // Example driver location

//   Timer? _timer;
//   double _fraction = 0.0;
//   double _animationSpeed = 0.0005; // Adjust for smoother or faster animation

//   @override
//   void initState() {
//     super.initState();
//        if (_userLocation != null) {
//       _animatePolyline();
//     }
//     //_getUserLocation();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   // Future<void> _getUserLocation() async {
//   //   Position position = await Geolocator.getCurrentPosition(
//   //       desiredAccuracy: LocationAccuracy.high);
//   //   setState(() {
//   //     _userLocation = LatLng(position.latitude, position.longitude);
//   //   });

//   //   // Once user location is obtained, start the animation
//   //   if (_userLocation != null) {
//   //     _animatePolyline();
//   //   }
//   // }

//   void _animatePolyline() {
//     _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
//       if (_fraction <= 1.0 && _userLocation != null) {
//         double lat = _lerp(_userLocation!.latitude, _driverLocation.latitude, _fraction);
//         double lng = _lerp(_userLocation!.longitude, _driverLocation.longitude, _fraction);
//         LatLng nextPoint = LatLng(lat, lng);

//         setState(() {
//           _polylineCoordinates.add(nextPoint);
//         });

//         _fraction += _animationSpeed;
        
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   double _lerp(double a, double b, double t) {
//     return a + (b - a) * t;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User to Driver Polyline Animation'),
//       ),
//       body: _userLocation == null
//           ? Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: _userLocation!,
//                 zoom: 14.5,
//               ),
//               polylines: {
//                 Polyline(
//                   polylineId: PolylineId('user_driver_polyline'),
//                   visible: true,
//                   points: _polylineCoordinates,
//                   color: Colors.blue,
//                   width: 5,
//                 ),
//               },
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//             ),
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
//   List<LatLng> _route = [
//     LatLng(37.42796133580664, -122.085749655962),
//     LatLng(37.42805742261661, -122.084855355486),
//     LatLng(37.42906860174835, -122.084351382216),
//     LatLng(37.4297845435635, -122.083722600875),
//     LatLng(37.43069698740417, -122.083091482289),
//     LatLng(37.43167542963693, -122.082541465759),
//     LatLng(37.43262396734253, -122.081989303588),
//     LatLng(37.43348839978854, -122.081460356712),
//     LatLng(37.43441803116136, -122.080934643745),
//     LatLng(37.43525950082496, -122.080402255058),
//     LatLng(37.43609307425055, -122.079876542091),
//     LatLng(37.43695150511073, -122.079348325729),
//     LatLng(37.43777922836724, -122.078820109367),
//     LatLng(37.43862125019927, -122.078292012215),
//     LatLng(37.43944425698253, -122.07776594162),
//     LatLng(37.44027676527533, -122.077236294746),
//     LatLng(37.44109624490734, -122.076710581779),
//     LatLng(37.44193335893052, -122.076180934906),
//     LatLng(37.44275282712424, -122.075655221939),
//     LatLng(37.44359094510337, -122.075128793716),
//     LatLng(37.44440341735225, -122.074602365494),
//   ];

//   Timer? _timer;
//   int _currentIndex = 0;
//   double _fraction = 0.0;
//   double _animationSpeed = 0.021; // Adjust for smoother or faster animation

//   @override
//   void initState() {
//     super.initState();
//     _animatePolyline();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _animatePolyline() {
//     _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
//       if (_currentIndex < _route.length - 1) {
//         LatLng startPoint = _route[_currentIndex];
//         LatLng endPoint = _route[_currentIndex + 1];

//         double lat = _lerp(startPoint.latitude, endPoint.latitude, _fraction);
//         double lng = _lerp(startPoint.longitude, endPoint.longitude, _fraction);
//         LatLng nextPoint = LatLng(lat, lng);

//         setState(() {
//           _polylineCoordinates.add(nextPoint);
//         });

//         _fraction += _animationSpeed;

//         if (_fraction >= 1.0) {
//           _fraction = 0.0;
//           _currentIndex++;
//         }
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   double _lerp(double a, double b, double t) {
//     return a + (b - a) * t;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Smooth Animated Polyline'),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _route[0],
//           zoom: 14.5,
//         ),
//         polylines: {
//           Polyline(
//             polylineId: PolylineId('animated_polyline'),
//             visible: true,
//             points: _polylineCoordinates,
//             color: Colors.blue,
//             width: 5,
//           ),
//         },
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }