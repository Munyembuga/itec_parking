import 'package:flutter/material.dart';
import 'package:itec_parking/scr/ibmScreen.dart';
import 'package:itec_parking/scr/parkingSite.dart';
import 'package:itec_parking/scr/parkingSlot.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFFA77D55),
        title: const Text('', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 16),
              // child: CircleAvatar(

              // backgroundColor: Colors.white,
              // radius: 16,
              child: Icon(
                Icons.location_on,
                color: Colors.white,
                size: 40,
              )),
          // ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Welcome to ITEC Cone',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.9,
                children: [
                  ParkingFeatureCard(
                    title: 'Parking Slots',
                    color: const Color(0xFFE6F2FF),
                    icon: 'location_icon',
                    iconColor: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParkingSlotsScreen(),
                        ),
                      );
                    },
                  ),
                  ParkingFeatureCard(
                    title: 'Parking Fees',
                    color: const Color(0xFFE5B8B8),
                    icon: 'parking_fee_icon',
                    // icon: 'access_time',
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParkingsiteScreen(),
                        ),
                      );
                    },
                  ),
                  ParkingFeatureCard(
                    title: 'Traffic Fines',
                    color: const Color(0xFFDDDDDD),
                    icon: 'traffic_fine_icon',
                    iconColor: Colors.black,
                    onTap: () async {
                      final ussdCode = '*131#';
                      final telUrl =
                          Uri.parse('tel:${Uri.encodeComponent(ussdCode)}');

                      if (await canLaunchUrl(telUrl)) {
                        await launchUrl(telUrl,
                            mode: LaunchMode.externalApplication);
                      } else {
                        // Handle the case where the USSD code cannot be launched
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Cannot open dialer. Please try manually dialing *131#'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  ParkingFeatureCard(
                    title: 'IBM',
                    color: const Color(0xFFD0E0C0),
                    icon: 'IBM',
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IBMScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ParkingFeatureCard extends StatelessWidget {
  final String title;
  final Color color;
  final String icon;
  final Color iconColor;
  final Function()? onTap; // Added onTap callback

  const ParkingFeatureCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.iconColor,
    this.onTap, // Made optional but we'll use it for navigation
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Wrap with InkWell to handle taps
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        color: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: getFeatureIcon(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getFeatureIcon() {
    switch (icon) {
      case 'location_icon':
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.red, size: 60),
            Icon(Icons.directions_car, color: Colors.yellow, size: 24),
          ],
        );
      case 'parking_fee_icon':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20,
              child: Text('P',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Icon(Icons.directions_car, color: Colors.blue, size: 40)
          ],
        );
      case 'traffic_fine_icon':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.car_rental, color: Colors.black, size: 40),
            Icon(Icons.person, color: Colors.black, size: 40)
          ],
        );
      case 'IBM':
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.business, color: Colors.green, size: 80),
            Text(
              "IBM",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        );
      default:
        return Icon(Icons.error, color: iconColor, size: 48);
    }
  }
}
