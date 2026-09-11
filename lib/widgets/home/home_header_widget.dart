import 'package:flutter/material.dart';
import 'package:insulog/states/home_screen_state.dart';

class HomeHeaderWidget extends StatelessWidget {
  final Size size;
  final HomeScreenState state;

  const HomeHeaderWidget({super.key, required this.size, required this.state});

  @override
  Widget build(BuildContext context) {
    final width = size.width > 600 ? 600.0 : size.width;
    final cardHeight = size.height * 0.16 < 145 ? 145.0 : size.height * 0.16;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: size.height * 0.02,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Olá, ${state.returnNameLogin()}!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 170, 247, 194),
                    radius: 24,
                    child: Text(
                      state.returnFirstNameCaractere(),
                      style: TextStyle(
                        fontSize: width * 0.08,
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
                height: cardHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3EA75F),
                      Color.fromARGB(255, 128, 209, 154),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(width * 0.1)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: width * 0.02),
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
                                  fontSize: width * 0.06,
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
                                  fontSize: width * 0.12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              Text(
                                "mg/dL",
                                style: TextStyle(
                                  height: 2,
                                  fontSize: width * 0.05,
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
                            width: width * 0.32,
                            padding: EdgeInsets.all(width * 0.01),
                            decoration: BoxDecoration(
                              color: state.statusMedia == 0
                                  ? Color.fromARGB(255, 255, 183, 0)
                                  : state.statusMedia == 1
                                  ? const Color.fromARGB(163, 255, 255, 255)
                                  : state.statusMedia == 2
                                  ? Color(state.colorStatusMedia)
                                  : Colors.white54,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(width * 0.1),
                                topRight: Radius.circular(width * 0.02),
                                bottomLeft: Radius.circular(width * 0.02),
                                bottomRight: Radius.circular(width * 0.1),
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
                                  size: width * 0.065,
                                ),
                                Flexible(
                                  child: Text(
                                    state.statusMediaDiariaDescricao,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: state.statusMedia == 0
                                          ? Color.fromARGB(255, 255, 255, 255)
                                          : state.statusMedia == 1
                                          ? Color(0xFF3EA75F)
                                          : state.statusMedia == 2
                                          ? Color.fromARGB(255, 255, 255, 255)
                                          : Color.fromARGB(255, 0, 0, 0),
                                    ),
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
