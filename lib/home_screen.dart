import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _apiKey =
      'your_api_key_here'; // Replace with OpenWeatherMap API key
  String city = 'Colombo';
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      setState(() {
        weatherData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sri Lanka Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchWeather,
          ),
        ],
      ),
      body: weatherData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${weatherData!['main']['temp']}°C',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weatherData!['weather'][0]['description'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.water_drop, color: Colors.blue),
                          Text(
                              'Humidity: ${weatherData!['main']['humidity']}%'),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.air, color: Colors.blue),
                          Text('Wind: ${weatherData!['wind']['speed']} m/s'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
