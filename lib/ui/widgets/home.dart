import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_weather_app/domain/entities/weather.dart';
import 'package:riverpod_weather_app/provider/weather_provider.dart';
import 'package:riverpod_weather_app/provider/weather_state.dart';
import 'package:riverpod_weather_app/ui/city_search.dart';
import 'package:riverpod_weather_app/ui/settings.dart';


class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xCity = useState('');
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Weather'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const SettingsScreen())),
                  child: const Icon(Icons.settings)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: InkWell(
                  onTap: () async {
                    final city = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const CitySearchScreen()));
                    xCity.value = city;
                    ref
                        .read(weatherNotifierProvider.notifier)
                        .fetchWeather(city);
                  },
                  child: const Icon(Icons.search)),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed: () async {
            final city = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CitySearchScreen()));
            xCity.value = city;
            ref.read(weatherNotifierProvider.notifier).fetchWeather(city);
          },
        ),
        body: Center(
          child:
              Consumer(builder: (BuildContext context, watch, Widget? child) {
            final state = ref.watch(weatherNotifierProvider);
            switch (state.status) {
              case WeatherStatus.initial:
                return const WeatherEmpty();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.success:
                return WeatherAvailable(
                  onRefresh: () {
                    return ref
                        .read(weatherNotifierProvider.notifier)
                        .refreshWeather();
                  },
                  weather: state.weathers,
                  units: state.temperatureUnits,
                  weatherDetails: state.weatherDetails,
                );
              case WeatherStatus.failure:
              default:
                return WeatherError(
                  onPressed: () {
                    ref
                        .read(weatherNotifierProvider.notifier)
                        .fetchWeather(xCity.value);
                  },
                );
            }
          }),
        ));
  }
}


class WeatherAvailable extends HookConsumerWidget {
  const WeatherAvailable(
      {Key? key,
      required this.onRefresh,
      required this.weather,
      required this.weatherDetails,
      required this.units})
      : super(key: key);

  final List<Weather> weather;
  final Weather weatherDetails;
  final ValueGetter<Future<void>> onRefresh;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        _WeatherBackground(),
        RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: OrientationBuilder(
                builder: (context, orientation) =>
                    orientation == Orientation.portrait
                        ? PortraitView(
                            units: units,
                            weather: weather,
                            weatherDetails: weatherDetails,
                          )
                        : LandScapeView(
                            units: units,
                            weather: weather,
                            weatherDetails: weatherDetails,
                          ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LandScapeView extends HookConsumerWidget {
  const LandScapeView(
      {Key? key,
      required this.weather,
      required this.weatherDetails,
      required this.units})
      : super(key: key);

  final List<Weather> weather;
  final Weather weatherDetails;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            DateFormat(DateFormat.WEEKDAY)
                .format(weatherDetails.date)
                .toUpperCase(),
            style: theme.textTheme.headline2?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          weatherDetails.condition.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: SvgPicture.network(
            'https://www.metaweather.com/static/img/weather/${weatherDetails.weatherStateAbr}.svg',
            height: 100,
            width: 100,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            weatherDetails.formattedTemperature(units),
            style: theme.textTheme.headline2?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 80,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Humidity: ${weatherDetails.humidity}%',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Pressure: ${weatherDetails.airPressure} hPa',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Wind: ${weatherDetails.windSpeed.toStringAsPrecision(2)} km/h',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return WeatherItem(
                weather: weather[index],
                onTap: () async {
                  ref
                      .read(weatherNotifierProvider.notifier)
                      .setWeatherDetails(weather[index]);
                },
                units: units,
              );
            },
            itemCount: weather.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 10,
              );
            },
          ),
        )
      ],
    );
  }
}

class PortraitView extends HookConsumerWidget {
  const PortraitView(
      {Key? key,
      required this.weather,
      required this.weatherDetails,
      required this.units})
      : super(key: key);

  final List<Weather> weather;
  final Weather weatherDetails;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            DateFormat(DateFormat.WEEKDAY)
                .format(weatherDetails.date)
                .toUpperCase(),
            style: theme.textTheme.headline2?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          weatherDetails.condition.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: SvgPicture.network(
            'https://www.metaweather.com/static/img/weather/${weatherDetails.weatherStateAbr}.svg',
            height: 100,
            width: 100,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            weatherDetails.formattedTemperature(units),
            style: theme.textTheme.headline2?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 80,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Humidity: ${weatherDetails.humidity}%',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Pressure: ${weatherDetails.airPressure} hPa',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Wind: ${weatherDetails.windSpeed.toStringAsPrecision(2)} km/h',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return WeatherItem(
                weather: weather[index],
                onTap: () async {
                  ref
                      .read(weatherNotifierProvider.notifier)
                      .setWeatherDetails(weather[index]);
                },
                units: units,
              );
            },
            itemCount: weather.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 10,
              );
            },
          ),
        )
      ],
    );
  }
}

class _WeatherBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.25, 0.75, 0.90, 1.0],
          colors: [
            color,
            color.brighten(10),
            color.brighten(33),
            color.brighten(50),
          ],
        ),
      ),
    );
  }
}

extension on Color {
  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final p = percent / 100;
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}

extension on Weather {
  String formattedTemperature(TemperatureUnits units) {
    return '''${temperature.value.toStringAsPrecision(2)}°${units.isCelsius ? 'C' : 'F'}''';
  }
}

extension on Temperature {
  String formattedTemperatureItem(TemperatureUnits units) {
    return '''${value.toStringAsPrecision(2)}°${units.isCelsius ? 'C' : 'F'}''';
  }
}

class WeatherItem extends StatelessWidget {
  const WeatherItem(
      {Key? key,
      required this.weather,
      required this.onTap,
      required this.units})
      : super(key: key);

  final Weather weather;
  final ValueGetter<Future<void>> onTap;
  final TemperatureUnits units;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: 100,
        width: 120,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5)),

        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                DateFormat(DateFormat.ABBR_WEEKDAY)
                    .format(weather.date)
                    .toUpperCase(),
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: SvgPicture.network(
                  'https://www.metaweather.com/static/img/weather/${weather.weatherStateAbr}.svg',
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${weather.minTemp.formattedTemperatureItem(units)}/${weather.maxTemp.formattedTemperatureItem(units)}',
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class WeatherEmpty extends StatelessWidget {
  const WeatherEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('🏙️', style: TextStyle(fontSize: 64)),
        Text(
          'Please Select a City!',
          style: theme.textTheme.headline5,
        ),
      ],
    );
  }
}



class WeatherError extends StatelessWidget {
  const WeatherError({Key? key, required this.onPressed}) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('🙈', style: TextStyle(fontSize: 64)),
        Text(
          'Something went wrong!',
          style: theme.textTheme.headline5,
        ),
        ElevatedButton(onPressed: onPressed, child: const Text('Retry'))
      ],
    );
  }
}


class WeatherLoading extends StatelessWidget {
  const WeatherLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('⛅', style: TextStyle(fontSize: 64)),
        Text(
          'Loading Weather',
          style: theme.textTheme.headline5,
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}