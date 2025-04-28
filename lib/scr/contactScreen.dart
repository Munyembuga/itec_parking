import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  Future<void> _launchCommunication(String type) async {
    Uri? uri;

    try {
      switch (type) {
        case 'email':
          uri = Uri.parse('mailto:munyembugajd@gmail.com');
          break;
        case 'phone':
          uri = Uri.parse('tel:+250784857700');
          break;
        case 'whatsapp':
          // Fix the WhatsApp URL format
          uri = Uri.parse('whatsapp://send?phone=250784857700');
          break;
        case 'messagephone':
          // Fix the WhatsApp URL format
          uri = Uri.parse('sms:0784857700');
          break;
        default:
          return;
      }

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // Show a snackbar or alert to inform the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA77D55),
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.business,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "We'd love to hear from you! Contact us by phone, email or whatsapp",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildContactButton(
                            'email',
                            Icons.email,
                            Colors.grey,
                          ),
                          _buildContactButton(
                            'phone',
                            Icons.phone,
                            Colors.red,
                          ),
                          _buildContactButton(
                            'messagephone',
                            Icons.chat,
                            Colors.green,
                          ),
                          _buildContactWhatsappButton(
                            'whatsapp',
                            Colors.green,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildContactButton(
      String type, IconData icon, Color backgroundColor) {
    return InkWell(
      onTap: () => _launchCommunication(type),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            icon,
            size: 32,
            color: type == 'email' ? Colors.white : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildContactWhatsappButton(String type, Color backgroundColor) {
    return InkWell(
      onTap: () => _launchCommunication(type),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FaIcon(
              FontAwesomeIcons.whatsapp,
              size: 35,
              color: Colors.white,
            )),
      ),
    );
  }
}
