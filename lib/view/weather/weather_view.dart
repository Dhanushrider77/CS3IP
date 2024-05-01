import 'dart:developer';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:fit/common/constants.dart';
import 'package:fit/view/model/weather_model.dart';
import 'package:fit/view/service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  var _currentCountry = "";
  var _currentLocation = "";
  var _currentPostalCode = "";
  Position? _currentPosition;
  Future<WeatherModel> getData(bool isCurrentCity, String cityName) async {
    return await CallToApi().callWeatherAPi(isCurrentCity, cityName);
  }

  TextEditingController textController = TextEditingController(text: "");
  Future<WeatherModel>? _myData;
  void _getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    var lastPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      _currentPosition = position;
      _getAddressFromLatLng();
    });
  }

  _getAddressFromLatLng() async {
    try {

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentLocation = "${place.locality}";
        _currentCountry = "${place.country}";
        _currentPostalCode = "${place.postalCode}";
      });
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {

    setState(() {
      _myData = getData(true, "");
    });
    _getCurrentLocation();
    super.initState();
  }


  String recomendation( condition) {

    if (condition == "Rainy" || condition == "Drizzle") {
      return 'Waterproof or water-resistant jacket with a hood.Waterproof pants or a skirt if needed.Waterproof pants or a skirt if needed. Waterproof boots or shoes to keep your feet dry. Compact umbrella to shield you from the rain';
    }
    if (condition == "Mist"|| condition == "Fog") {
      return 'Wear a waterproof jacket or coat to repel moisture.Scarf or neck gaiter to protect against wind chill. Water-resistant shoes or boots';
    }
    if (condition == "Clear") {
      return 'Light, breathable fabrics like cotton or linen to help stay cool. Loose-fitting clothing to allow airflow. Wide-brimmed hats or caps to protect your face from the sun';
    }
    if (condition == "Clouds") {
      return 'Start with a breathable base layer like a cotton T-shirt or a lightweight long-sleeve shirt. Layer with a sweater or cardigan that you can easily remove if it gets warmerConsider a light jacket or windbreaker for added protection against cool breezes';
    }
    if (condition == "Haze") {
      return 'Wear long-sleeved shirts and long pants to minimize skin exposure to pollutants.Choose lightweight, breathable fabrics like cotton or linen to stay comfortable in the heat';
    }
    return 'To be updated soon';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If error occured
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error.toString()} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if data has no errors
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final data = snapshot.data as WeatherModel;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color.fromARGB(255, 65, 89, 224),
                      Color.fromARGB(255, 83, 92, 215),
                      Color.fromARGB(255, 86, 88, 177),
                      Color(0xff405cee),
                      Color(0xff509ac9),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: [
                      AnimSearchBar(
                        rtl: true,
                        width: 400,
                        color: const Color(0xff69aff5),
                        textController: textController,
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 26,
                        ),
                        onSuffixTap: () async {
                          textController.text == ""
                              ? log("No city entered")
                              : setState(() {
                            _myData = getData(false, textController.text);
                          });

                          FocusScope.of(context).unfocus();
                          textController.clear();
                        },
                        style: f14RblackLetterSpacing2, onSubmitted: (String ) {  },
                      ),
                      const SizedBox(
                        height: 60,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              data.city,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  color: Colors.indigo, fontSize: 13, letterSpacing: .3),
                            ),
                            height25,
                            Text(
                              data.desc.toUpperCase(),
                              style: f16PW,
                            ),
                            height25,
                            Text(
                              "${data.temp}°C",
                              style: f42Rwhitebold,
                            ),
                            height25,
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 250,
                              child: Column(
                              children: [
                                const SizedBox(
                                height: 10,),
                                const Text("Clothing Recommendation",style:  TextStyle(color: Colors.brown,fontSize: 35)),
                                const SizedBox(
                                  height: 10,),
                                Text(
                                  recomendation(data.main),
                                  style: const TextStyle(color: Colors.black,fontSize: 20),
                                ),
                              ],
                        ),
                            ),
                          ),)

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("${snapshot.connectionState} occured"),
            );
          }
          return const Center(
            child: Text("Server timed out!"),
          );
        },
        future: _myData!,
      ),
    );
  }
}