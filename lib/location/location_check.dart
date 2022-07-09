import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/location/google_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';


final stream = StreamProvider((ref) => Geolocator.getPositionStream());

class LocationCheck extends ConsumerWidget {

  LocationPermission? locationPermission;

  @override
  Widget build(BuildContext context, ref) {
    final locationStream = ref.watch(stream);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            locationStream.when(
                data: (data) {
                  return Text('${data.latitude} ${data.longitude}');
                },
                error: (err, stack) => Text('$err'),
                loading: () => Container(child: Center(child: CircularProgressIndicator(color: Colors.purple,)),)
            ),
            ElevatedButton(onPressed: () async{
              locationPermission = await Geolocator.requestPermission();

              if(locationPermission == LocationPermission.denied) {
                locationPermission = await Geolocator.requestPermission();
              } else if(locationPermission == LocationPermission.deniedForever) {
                await Geolocator.openAppSettings();
              }

              if(locationPermission == LocationPermission.always || locationPermission == LocationPermission.whileInUse) {
                final response = await Geolocator.getCurrentPosition();
                // List<Placemark> placemarks = await placemarkFromCoordinates(response.latitude, response.longitude);
                // print(placemarks);

                Get.to(() => MapSample(response.latitude, response.longitude), transition: Transition.leftToRight);
              }


            }, child: Text('Get Location'))
          ],
        ),
      ),
    );
  }
}
