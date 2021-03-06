import 'package:flutter/material.dart';
import '../model/weather_report.dart';
import '../api/weather_data_service.dart';

class WeatherInfoList extends StatefulWidget {
  const WeatherInfoList({Key? key}) : super(key: key);

  @override
  State<WeatherInfoList> createState() => WeatherInfoListState();
}

class WeatherInfoListState extends State<WeatherInfoList> {
  late Future<WeatherReportList> _weatherReportList;

  String get cityId => _cityId;
  String _cityId = '44418';

  set cityId(String value) {
    setState(() {
      _weatherReportList = WeatherDataService().getCityForecastById(value);
    });
  }

  @override
  void initState() {
    super.initState();
    _weatherReportList = WeatherDataService().getCityForecastById(cityId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherReportList>(
      future: _weatherReportList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data?.weatherReportList['consolidated_weather'];
          // print(data);
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Image.network(
                          "https://www.metaweather.com/static/img/weather/ico/" +
                              data[index]['weather_state_abbr'] +
                              ".ico"),
                      title: Text(
                          snapshot.data!.weatherReportList['title'].toString()),
                      subtitle: Text(data[index]['weather_state_name']),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Max: " +
                                  data[index]['max_temp'].round().toString() +
                                  ' ${String.fromCharCode(0x00B0)}C',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                              "Min: " +
                                  data[index]['min_temp'].round().toString() +
                                  ' ${String.fromCharCode(0x00B0)}C',
                              style: const TextStyle(
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                  ],
                ));
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
