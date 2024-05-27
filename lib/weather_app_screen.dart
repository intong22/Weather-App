import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/key.dart';
import 'package:weather_app/weather_forecast_card.dart';
import 'package:http/http.dart' as http;

class WeatherAppScreen extends StatefulWidget {
  const WeatherAppScreen({super.key});

  @override
  State<WeatherAppScreen> createState() => _WeatherAppScreenState();
}

class _WeatherAppScreenState extends State<WeatherAppScreen> {
  late Future<Map<String, dynamic>> currentWeather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String city = 'Philippines';

      final result = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$weatherAPIKey',
        ),
      );

      final data = jsonDecode(result.body);

      if (data['cod'] != '200') {
        throw 'An error occured.';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    currentWeather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Weather App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: (){
                setState(() {
                  currentWeather = getCurrentWeather();
                });
              }, 
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: FutureBuilder(
          future: currentWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final data = snapshot.data!;
            final temp = data['list'][0]['main']['temp'] - 273.15;
            final tempDescr = data['list'][0]['weather'][0]['main'];
            final pressure = data['list'][0]['main']['pressure'];
            final windSpeed = data['list'][0]['wind']['speed'];
            final humidity = data['list'][0]['main']['humidity'];

            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //main card
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text(
                                    '${temp.toStringAsFixed(2)} °C',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Icon(
                                    tempDescr == 'Rain' ? Icons.water_drop : 
                                    tempDescr == 'Clouds' ? Icons.cloud : 
                                    Icons.sunny,
                                    size: 64,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    tempDescr,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //hourly forecast cards
                    const Text(
                      'Hourly Forecast',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final hourlyForecast = data['list'][index + 1];
                          final skyForecast = hourlyForecast['weather'][0]['main'];
                          final time = DateTime.parse(hourlyForecast['dt_txt']);
                      
                          return HourlyForecastCard(
                            time: DateFormat.j().format(time),
                            icon: skyForecast == 'Rain' ? Icons.water_drop : 
                                  skyForecast == 'Clouds' ? Icons.cloud : 
                                  Icons.sunny, 
                            degree: (hourlyForecast['main']['temp'] - 273.15).toStringAsFixed(2),
                          );
                        },
                      ),
                    ),
                    //additional info
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfo(
                          icon: Icons.water_drop,
                          description: 'Humidity',
                          measure: humidity.toString(),
                        ),
                        AdditionalInfo(
                          icon: Icons.air,
                          description: 'Wind Speed',
                          measure: windSpeed.toString(),
                        ),
                        AdditionalInfo(
                          icon: Icons.beach_access,
                          description: 'Pressure',
                          measure: pressure.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
      );
  }
}
