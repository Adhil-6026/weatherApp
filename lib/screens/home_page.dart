import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/utils/image_path.dart';
import 'package:weatherapp/services/weather_service.dart';
import 'package:weatherapp/services/location_provider.dart';
import 'package:weatherapp/utils/apptext.dart';

const apiKey = '1227ff650a5c4dd6b518b86dcdf3503b';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool _clicked = false;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var position = locationProvider.currentPosition;
        if (position != null) {
          Provider.of<WeatherService>(context, listen: false)
              .fetchWeatherData(position);
        }
      }
    });
    super.initState();
  }

  TextEditingController _cityController = TextEditingController();
  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final locationProvider = Provider.of<LocationProvider>(context);
    final weatherService = Provider.of<WeatherService>(context);

    int sunriseTimestamp = weatherService.weather?.sys?.sunrise ?? 0;
    int sunsetTimestamp = weatherService.weather?.sys?.sunset ?? 0;

//Convert the timestamp to a DateTime object
    DateTime sunriseDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp);
    DateTime sunsetDateTime =
        DateTime.fromMicrosecondsSinceEpoch(sunsetTimestamp);

//Format the time as a string
    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);

    var position = locationProvider.currentPosition;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 20.0),
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
              background[weatherService.weather?.weather![0].main ?? "N/A"] ??
                  "assets/images/clear.png"),
        )),
        child: Stack(
          children: [
            ///top location search
            Container(
              height: 50,
              child: Consumer<LocationProvider>(
                  builder: (context, LocationProvider, child) {
                var locationCall;
                if (locationProvider.currentLocationName != null) {
                  locationCall = LocationProvider.currentLocationName!.locality;
                } else {
                  locationCall = "Unknown Location";
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Provider.of<WeatherService>(context,
                                      listen: false)
                                  .fetchWeatherData(position!);
                            },
                            icon: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: locationCall,
                                fw: FontWeight.w600,
                              ),
                              AppText(data: 'Good Morning'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          print("click");
                          _clicked = !_clicked;
                        });
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 40,
                      ),
                    ),
                  ],
                );
              }),
            ),

            ///cloud images and time

            Align(
                alignment: const Alignment(-.05, -0.7),
                child: Image.asset(imagePath[
                        weatherService.weather?.weather![0].main ?? "N/A"] ??
                    "assets/images/icons/clr.png")),

            Align(
              alignment: const Alignment(0, 0),
              child: Container(
                height: 180,
                child: Column(
                  children: [
                    AppText(
                      data:
                          "${weatherService.weather?.main?.temp?.toStringAsFixed(0)}\u00b0" ??
                              "",
                      size: 35.0,
                      fw: FontWeight.bold,
                    ),
                    AppText(
                      data: weatherService.weather?.name ?? "N/A",
                      size: 20.0,
                      fw: FontWeight.w600,
                    ),
                    AppText(
                      data: weatherService.weather?.weather![0].main ?? "N/A",
                      size: 18.0,
                      fw: FontWeight.w600,
                    ),
                    AppText(data: DateFormat("hh:mm a").format(DateTime.now())),
                  ],
                ),
              ),
            ),

            ///last box tem,sunrise,sunset

            Align(
              alignment: Alignment(0.0, 0.75),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.4)),
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icons/temp-high.png',
                              height: 60,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Temp Max",
                                  size: 14,
                                  fw: FontWeight.w400,
                                ),
                                AppText(
                                  data:
                                      "${weatherService.weather?.main!.tempMax!.toStringAsFixed(0)}\u00b0 C",
                                  size: 15,
                                  fw: FontWeight.w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icons/temp-low.png',
                              height: 60,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Temp Min",
                                  size: 14,
                                  fw: FontWeight.w400,
                                ),
                                AppText(
                                  data:
                                      "${weatherService.weather?.main!.tempMin!.toStringAsFixed(0)}\u00b0 C",
                                  size: 15,
                                  fw: FontWeight.w400,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2.0,
                      indent: 40,
                      endIndent: 40,
                      color: Colors.white70,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icons/sun.png',
                              height: 50,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: 'Sunrise',
                                  size: 14,
                                  fw: FontWeight.w400,
                                ),
                                AppText(
                                  data: formattedSunrise,
                                  size: 15,
                                  fw: FontWeight.w400,
                                ),
                              ],
                            ),
                            Container(
                              child: Row(),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icons/moon.png',
                              height: 50,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: 'Sunset',
                                  size: 14,
                                  fw: FontWeight.w400,
                                ),
                                AppText(
                                  data: formattedSunset,
                                  size: 15,
                                  fw: FontWeight.w400,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _clicked == true
                ? Positioned(
                    top: 60,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 45,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                  hintText: "Search by City",
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70),
                                  )),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                weatherService.fetchWeatherDataByCity(
                                    _cityController.text);
                              },
                              icon: Icon(Icons.search)),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
