import 'package:covid_tracker/Modal/worldstate_model.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesscreen extends StatefulWidget {
  const WorldStatesscreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesscreen> createState() => _WorldStatesscreenState();
}

class _WorldStatesscreenState extends State<WorldStatesscreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this);
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorlist = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];
  @override
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          FutureBuilder(
            future: stateServices.getWorldStates(),
            builder: (context, AsyncSnapshot<WorldstateModel> snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                    flex: 1,
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50,
                      controller: _controller,
                    ));
              } else {
                return Column(
                  children: [
                    PieChart(
                      chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true),
                      dataMap: {
                        "Total": double.parse(snapshot.data!.cases!.toString()),
                        "Recover":
                            double.parse(snapshot.data!.recovered.toString()),
                        "Death": double.parse(snapshot.data!.deaths.toString())
                      },
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.left),
                      animationDuration: const Duration(milliseconds: 1200),
                      chartType: ChartType.ring,
                      colorList: colorlist,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * .06),
                      child: Card(
                        child: Column(
                          children: [
                            Reusableraw(
                                title: "Today cases",
                                value: snapshot.data!.todayCases!.toString()),
                            Reusableraw(
                                title: "Today Recoverd",
                                value:
                                    snapshot.data!.todayRecovered!.toString()),
                            Reusableraw(
                                title: "Today Deaths",
                                value: snapshot.data!.todayDeaths!.toString()),
                            Reusableraw(
                                title: "Total cases",
                                value: snapshot.data!.cases!.toString()),
                            Reusableraw(
                                title: "Total Recoverd",
                                value: snapshot.data!.recovered!.toString()),
                            Reusableraw(
                                title: "Total Deaths",
                                value: snapshot.data!.deaths!.toString()),
                            Reusableraw(
                                title: "Affected Countries",
                                value: snapshot.data!.affectedCountries!
                                    .toString()),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CountriesListScreen(),
                            ));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color:const  Color(0xff1aa260),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(child: Text('Track Countries')),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ],
      )),
    );
  }
}

// ignore: must_be_immutable
class Reusableraw extends StatelessWidget {
  String title, value;
  Reusableraw({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(),
        ],
      ),
    );
  }
}
