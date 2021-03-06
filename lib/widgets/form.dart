import 'package:flutter/material.dart';
import '../model/weather_report.dart';
import '../api/weather_data_service.dart';
import 'weather_info_list.dart';

final GlobalKey<WeatherInfoListState> weatherInfoList =
    GlobalKey<WeatherInfoListState>();

class WeatherRequestForm extends StatefulWidget {
  const WeatherRequestForm({Key? key}) : super(key: key);

  @override
  State<WeatherRequestForm> createState() => _WeatherRequestFormState();
}

class _WeatherRequestFormState extends State<WeatherRequestForm> {
  late Future<WeatherReport> _weatherReport;

  final _formKey = GlobalKey<FormState>();
  final _weatherFormController = TextEditingController();
  String get formTextValue => _formTextValue;
  String _formTextValue = '';

  set formTextValue(String value) {
    setState(() {
      _formTextValue = value;
    });
  }

  String get cityId => _cityId;
  String _cityId = '';

  set cityId(String value) {
    setState(() {
      _cityId = value;
    });
  }

  void _handleSetCityId(String id) {
    cityId = id;
    weatherInfoList.currentState!.cityId = cityId;
  }

  @override
  void initState() {
    super.initState();
    _weatherReport = WeatherDataService().getCityID('London');
    _weatherFormController.addListener(_setFormTextValue);
  }

  @override
  void dispose() {
    super.dispose();
    _weatherFormController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          appTextField(
            'City ID or Name',
            TextInputType.text,
            const Icon(Icons.search),
          ),
          const SizedBox(height: 20.0),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _weatherReport =
                            WeatherDataService().getCityID(formTextValue);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(formTextValue),
                        ),
                      );
                      _weatherFormController.clear();
                    }
                  },
                  child: const Text('Get City ID'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        formTextValue = _weatherFormController.text;
                        print(formTextValue);
                        _handleSetCityId(formTextValue);
                        // print(weatherInfoList.currentState!.cityId);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Requesting Weather Infomoration for $formTextValue'),
                      ));
                      _weatherFormController.clear();
                    }
                  },
                  child: const Text('Weather By ID'),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     if (_formKey.currentState!.validate()) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(
                //           content: Text(
                //               'Requesting Weather Infomoration for $formTextValue'),
                //         ),
                //       );

                //       _weatherFormController.clear();
                //     }
                //   },
                //   child: const Text('Weather By Name'),
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: FutureBuilder<WeatherReport>(
              future: _weatherReport,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.id.toString());
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _setFormTextValue() {
    formTextValue = _weatherFormController.text;
  }

  Widget appTextField(String label, TextInputType keyboardType, Icon icon) {
    return TextFormField(
        controller: _weatherFormController,
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        }),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2)),
          prefixIcon: icon,
          labelText: label,
          hintText: 'Enter $label',
          helperText: '$label is required',
        ));
  }
}
