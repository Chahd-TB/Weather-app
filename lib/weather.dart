import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Map<String, dynamic>? weatherData;
  String city ="Blida";
  String country ="DZ";
  // Fetch weather data for the city
  Future<Map<String, dynamic>> fetchWeatherData() async {
    const apiKey = 'f48cd10bb7386dbf850fd56c1daad064';
    String url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city,$country&lang=en&units=metric&appid=$apiKey';

    try {
      final response = await get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return the decoded JSON data
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      throw Exception("Error fetching weather data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[500]!,
                Colors.blue[500]!,
              ],
            ),
          ),
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchWeatherData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final weatherData = snapshot.data!;
                Map<String, Map<String, dynamic>> details = {
                    "Wind": {
                      "value": weatherData["wind"]["speed"],
                      "icon": const Icon(Icons.wind_power, color: Colors.blue),
                    },
                    "Pressure": {
                      "value": weatherData["main"]["pressure"],
                      "icon": const Icon(Icons.wifi_protected_setup_sharp, color: Colors.blue),
                    },
                    "Humidity": {
                      "value": weatherData["main"]["humidity"],
                      "icon": const Icon(Icons.water_drop_rounded, color: Colors.blue),
                    },
                    "Sea level": {
                      "value": weatherData["main"]["sea_level"],
                      "icon": const Icon(Icons.water, color: Colors.blue),
                    },
                  };


                return Column(
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      "$city",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(223, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Chance of rain is: ${weatherData["clouds"]["all"]}%",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(226, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${weatherData["weather"][0]["description"]}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(226, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20,left: 30),
                          child: Text(
                            "${weatherData["main"]["temp"]}",
                            style: const TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(209, 255, 255, 255),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Image.network(
                            'http://openweathermap.org/img/wn/${weatherData["weather"][0]["icon"]}.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                           
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 230,
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            childAspectRatio: 2,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          itemCount: details.length, // Dynamically set item count based on the length of the details map
                          itemBuilder: (context, index) {
                            // Convert the map entries into a list and access each key-value pair
                            final detail = details.entries.elementAt(index);
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Displaying the key (like "Wind", "Pressure")
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          detail.key, // Key
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      // Displaying the value (like wind speed, pressure)
                                      Text(
                                        "${detail.value["value"]}", // Value
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  detail.value["icon"]
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        children: [
                          Container(
                            width: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const WeatherCard(
                              day: "Sunday",
                              temperature: "25°",
                              imagePath: "images/11d.png",
                            ),
                          ),
                          Container(
                            width: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const WeatherCard(
                              day: "Monday",
                              temperature: "28°",
                              imagePath: "images/13d.png",
                            ),
                          ),
                          Container(
                            width: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const WeatherCard(
                              day: "Tuesday",
                              temperature: "22°",
                              imagePath: "images/50d.png",
                            ),
                          ),
                          Container(
                            width: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const WeatherCard(
                              day: "Wednesday",
                              temperature: "22°",
                              imagePath: "images/50d.png",
                            ),
                          ),
                          Container(
                            width: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const WeatherCard(
                              day: "Thursday",
                              temperature: "22°",
                              imagePath: "images/50d.png",
                            ),
                          ),
                          Container(
                            width: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const WeatherCard(
                              day: "Friday",
                              temperature: "22°",
                              imagePath: "images/50d.png",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ),
      ),
    );
  }
}

// Reusable WeatherCard widget
class WeatherCard extends StatelessWidget {
  final String day;
  final String temperature;
  final String imagePath;

  const WeatherCard({
    super.key,
    required this.day,
    required this.temperature,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            imagePath,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
          Text(
            temperature,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
