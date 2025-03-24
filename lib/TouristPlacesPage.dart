import 'package:flutter/material.dart';

class TouristPlacesPage extends StatelessWidget {
  final List<Map<String, dynamic>> places = [
    {
      "name": "Casbah of Algiers",
      "description":
          "A historic neighborhood with Ottoman-era palaces and narrow streets.",
      "image":
          "https://ulysse.com/news/wp-content/uploads/2024/01/Mosquee-Ketchaoua-Alger-Algerie-.jpg",
      "location": "Algiers, Algeria",
      "rating": 4.8,
      "openingHours": "8:00 AM - 7:00 PM",
      "website": "https://whc.unesco.org/en/list/565/"
    },
    {
      "name": "Timgad",
      "description":
          "An ancient Roman city, known as the 'Pompeii of North Africa'.",
      "image":
          "https://www.horizons.dz/wp-content/uploads/2024/01/timgad-780x470.jpeg",
      "location": "Batna, Algeria",
      "rating": 4.7,
      "openingHours": "9:00 AM - 6:00 PM",
      "website": "https://whc.unesco.org/en/list/194/"
    },
    {
      "name": "Notre-Dame d'Afrique",
      "description":
          "A famous basilica in Algiers offering a breathtaking view of the city.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/6/6f/Notre_Dame_d%27Afrique.jpg",
      "location": "Algiers, Algeria",
      "rating": 4.9,
      "openingHours": "10:00 AM - 5:00 PM",
      "website": "https://www.algeria.com/attractions/notre-dame-d-afrique/"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Touristic Places", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF578FCA),
      ),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return Card(
            color: Colors.lightBlue.shade100, // اللون الصحيح داخل Card

            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(place["image"]!,
                  width: 50, height: 50, fit: BoxFit.cover),
              title: Text(place["name"]!,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(place["description"]!,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceDetailsPage(place: place),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PlaceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> place;

  PlaceDetailsPage({required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(place["name"]!, style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Color(0xFF578FCA)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(place["image"]!,
                width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place["name"]!,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(place["description"]!, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFF578FCA)),
                      SizedBox(width: 5),
                      Text(place["location"]!, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 5),
                      Text("${place["rating"]} / 5.0",
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue),
                      SizedBox(width: 5),
                      Text("Opening Hours: ${place["openingHours"]}",
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 20),
                  place["website"] != null
                      ? ElevatedButton.icon(
                          onPressed: () {
                            // Open website (if available)
                          },
                          icon:
                              Icon(Icons.open_in_browser, color: Colors.white),
                          label: Text("Visit Official Website",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF578FCA)),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
