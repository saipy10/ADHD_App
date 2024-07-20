import 'package:adhd_app/pages/main_page/main_page.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            // Radial gradient at specific position
            gradient: RadialGradient(
              center: Alignment(0.0, 0.4),
              radius: 0.95,
              colors: [
                // Colors.green,
                Color.fromARGB(235, 230, 255, 255),
                Color.fromARGB(235, 238, 255, 255),
                Color.fromARGB(235, 242, 255, 255),
                Color.fromARGB(235, 248, 255, 255),
                Color.fromARGB(236, 255, 255, 255),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Quote
              // “Yesterday is history, tomorrow is a mystery, and TODAY IS A GIFT... that's why they call it PRESENT”\n ― Master Oogway
              const SizedBox(
                width: 287,
                height: 238,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "“Yesterday is history, ",
                      style: TextStyle(fontSize: 25.25),
                    ),
                    Text(
                      "tomorrow is a mystery, ",
                      style: TextStyle(fontSize: 25.25),
                    ),
                    Row(
                      children: [
                        Text(
                          "and  ",
                          style: TextStyle(fontSize: 25.25),
                        ),
                        Text(
                          "TODAY IS A GIFT...",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 25.25,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "that's why they call it ",
                      style: TextStyle(fontSize: 25.25),
                    ),
                    Text(
                      "PRESENT”",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 25.25,
                      ),
                    ),
                    Text(
                      "- Master Oogway",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 21.25,
                      ),
                    ),
                  ],
                ),
              ),

              // Page divider
              Divider(
                height: 28,
                // thickness: width * 0.8,
                indent: width * 0.1,
                endIndent: width * 0.1,
              ),

              // About technique
              // Mindfulness Box Breathing Technique used by Navy Seals
              const SizedBox(
                height: 68,
                width: 308,
                child: Column(
                  children: [
                    Text(
                      "Mindfulness Box Breathing Technique",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.25,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "used by ",
                          style: TextStyle(fontSize: 16.25),
                        ),
                        Text(
                          "Navy Seals",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.25,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Image
              SizedBox(
                height: 196,
                width: 238,
                child: Image.asset(
                  "assets/images/onboarding_page_img.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 16,
              ),

              // Let's Heal Together... button
              SizedBox(
                height: 46,
                width: 295,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(64, 169, 109, 1),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const MainPage()));
                  },
                  child: const Text(
                    "Let's Heal Together",
                    style: TextStyle(
                      fontSize: 21.25,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
