import 'package:flutter/material.dart';
import 'package:insulog/states/home_screen_state.dart';

class HomeHeaderWidget extends StatelessWidget {
  final Size size;
  final HomeScreenState state;

  const HomeHeaderWidget({super.key, required this.size, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Olá, ${state.returnNameLogin()}!',
                    style: TextStyle(
                      fontSize: size.width * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 170, 247, 194),
                    radius: 24,
                    child: Text(
                      state.returnFirstNameCaractere(),
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3EA75F),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                height: size.height * 0.16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3EA75F),
                      Color.fromARGB(255, 128, 209, 154),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(size.width * 0.1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Média diária",
                                style: TextStyle(
                                  fontSize: size.width * 0.06,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                state.mediaGlicose,
                                style: TextStyle(
                                  height: 0,
                                  fontSize: size.width * 0.12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "mg/dL",
                                style: TextStyle(
                                  height: 2,
                                  fontSize: size.width * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: size.width * 0.32,
                            padding: EdgeInsets.all(size.width * 0.01),
                            decoration: BoxDecoration(
                              color:  state.statusMedia == 0
                                        ?  Color.fromARGB(255, 255, 183, 0)
                                        : state.statusMedia == 1
                                        ? const Color.fromARGB(163, 255, 255, 255)
                                        : state.statusMedia == 2
                                        ? Color(state.colorStatusMedia)
                                        :  Colors.white54,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(size.width * 0.1),
                                topRight: Radius.circular(size.width * 0.02),
                                bottomLeft: Radius.circular(size.width * 0.02),
                                bottomRight: Radius.circular(size.width * 0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                   state.statusMedia != 1
                                        ? Icons.warning
                                        : Icons.check_circle_rounded,
                                  color: state.statusMedia == 0
                                        ? Color.fromARGB(255, 255, 255, 255)
                                        : state.statusMedia == 1
                                        ? Color(0xFF3EA75F)
                                        : state.statusMedia == 2
                                        ? Color.fromARGB(255, 255, 255, 255)
                                        : Color.fromARGB(255, 0, 0, 0),
                                  size: size.width * 0.065,
                                ),
                                Text(
                                  state.statusMediaDiariaDescricao,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: state.statusMedia == 0
                                        ? Color.fromARGB(255, 255, 255, 255)
                                        : state.statusMedia == 1
                                        ?   Color(0xFF3EA75F)
                                        : state.statusMedia == 2
                                        ? Color.fromARGB(255, 255, 255, 255)
                                        : Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
