import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'BottomNav.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CafeteriasPage extends StatefulWidget {
  final int userId;

  CafeteriasPage({required this.userId});

  @override
  _CafeteriasPageState createState() => _CafeteriasPageState();
}

class _CafeteriasPageState extends State<CafeteriasPage> {
  int _currentIndex = 2;
  List<Cafeteria> cafeterias = [];
  late int _userId;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _fetchCafeterias();
  }

  Future<void> _fetchCafeterias() async {
    try {
      final response = await http.get(Uri.parse('https://campusconnect.site/api/restaurantowners'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          cafeterias = data.map((item) => Cafeteria.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load cafeterias - ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors here
    }
  }

  Future<void> _openWebView(String url) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Images/background_white.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'Cafeterias',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.5,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cafeterias.length,
                    itemBuilder: (context, index) {
                      Cafeteria cafeteria = cafeterias[index];
                      return Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            // Handle card tap
                            String visitUsUrl =
                                'https://campusconnect.site/myAccount?id=$_userId&panel=0&restaurant_slug=${cafeteria.slug}';
                            print('WebView URL: $visitUsUrl');
                            _openWebView(visitUsUrl);
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    cafeteria.thumbnailUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cafeteria.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        cafeteria.foodType,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        'Rating: ${cafeteria.rating}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF9C71E1), // Purple color
                                    textStyle: TextStyle(fontSize: 16),
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  onPressed: () {
                                    // Handle order button tap
                                    String visitUsUrl =
                                        'https://campusconnect.site/myAccount?id=$_userId&panel=0&restaurant_slug=${cafeteria.slug}';
                                    print('WebView URL: $visitUsUrl');
                                    _openWebView(visitUsUrl);
                                  },
                                  child: Text('Order'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        isBottomNavVisible: true,
        userId: _userId,
      ),
    );
  }
}

class Cafeteria {
  final String name;
  final String thumbnailUrl;
  final String foodType;
  final double rating;
  final String slug;
  final int id;

  Cafeteria({
    required this.name,
    required this.thumbnailUrl,
    required this.foodType,
    required this.rating,
    required this.slug,
    required this.id,
  });

  factory Cafeteria.fromJson(Map<String, dynamic> json) {
    return Cafeteria(
      name: json['restaurant_name'],
      thumbnailUrl: json['restaurant_image'],
      foodType: json['food_type'] ?? 'Not specified',
      rating: json['is_approved'] ?? false ? 4.5 : 0.0,
      slug: json['restaurant_slug'],
      id: json['id'],
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
