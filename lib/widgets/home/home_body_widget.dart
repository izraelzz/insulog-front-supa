import 'package:flutter/material.dart';
import 'package:insulog/states/home_screen_state.dart';
import 'package:insulog/widgets/custom_container_widget.dart';
import 'package:insulog/widgets/home/glucose_record_list_widget.dart';

class HomeBodyWidget extends StatelessWidget {
  final Size size;
  final HomeScreenState state;

  const HomeBodyWidget({super.key, required this.size, required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomContainerWidget(
      width: size.width,
      innerShadow: const InnerShadow(
        color: Color.fromARGB(80, 0, 0, 0),
        blurRadius: 2,
        offset: Offset(0, 2),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size.width * 0.1),
          topRight: Radius.circular(size.width * 0.1),
        ),
      ),
      child: RefreshIndicator(
        onRefresh: state.refreshRecords,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: size.height * 0.02,
                  left: size.width * 0.05,
                  right: size.width * 0.05,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.returnCurrentDateLabel(),
                          style: TextStyle(
                            fontSize: size.width * 0.04,
                            color: const Color.fromARGB(255, 100, 100, 100),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'REGISTROS RECENTES',
                          style: TextStyle(
                            fontSize: size.width * 0.045,
                            color: const Color.fromARGB(255, 78, 78, 78),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  size.width * 0.04,
                  0.0,
                  size.width * 0.04,
                  size.height * 0.035,
                ),
                child: GlucoseRecordListWidget(
                  size: size,
                  state: state,
                  records: state.visibleRecords,
                  onShowMore: state.canShowMoreRecords
                      ? state.showMoreRecords
                      : null,
                  onShowLess: state.canShowLessRecords
                      ? state.showLessRecords
                      : null,
                ),
              ),
              SizedBox(height: size.height * 0.08),
            ],
          ),
        ),
      ),
    );
  }
}
