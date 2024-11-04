# Journey Maps Client Flutter

This package allows you to easily incorporate SBB maps into your Flutter application.

![Main Flutter Example](example/gallery/main.png){width=66%}

#### Table Of Contents

- [Journey Maps Client Flutter](#journey-maps-client-flutter)
      - [Table Of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Getting Started](#getting-started)
    - [Supported platforms](#supported-platforms)
    - [Precondition](#precondition)
  - [Documentation](#documentation)
  - [License](#license)
  - [Contributing](#contributing)
  - [Coding Standards](#coding-standards)
  - [Code of Conduct](#code-of-conduct)

<a id="Introduction"></a>

## Introduction

The package is meant as a client for the [Journey Maps API] and is based on the [Flutter Maplibre GL plugin] - solely for Android and iOS.

<a id="Getting-Started"></a>

## Getting Started

#### Supported platforms

<div id="supported_platforms">
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android"/>
  <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white" alt="iOS">
</div>

#### Precondition

In order to access styles and tile data, you need to register your application to the [Journey Maps Tile API] to receive an API Key.
Create an account (e.g. using SwissPass Login) to be able to setup an application and then register this application to the API.

#### Installation

Since this package is not on pubdev yet, you need to add it to your pubspec.yaml file like this:
```
dependencies:
    ...
    sbb_maps_flutter:
      git:
        url: git@github.com:SchweizerischeBundesbahnen/journey-maps-client-flutter.git
        ref: main \\ might be prone for breaking changes - use a TAG REF
```

#### In code usage

###### API key

Make the API Key accessible to your application. Either

1. add it as env var (not recommended):
```sh
JOURNEY_MAPS_API_KEY='YOUR_API_KEY_HERE'
```
2. Or use a package such as [envied](https://pub.dev/packages/envied) for clean env var handling and
   *obfuscating* your API key, making it harder to reverse engineer (in public apps!). Pass the env key to the
   `SBBRokasMapStyler` as constructor parameter. Use this styler to the `SBBMap` as `mapStyler` parameter.
```dart
SBBRokasMapStyler.full(apiKey: Env.MY_API_KEY_NAME);
```

###### Adding the map

```dart
SBBMap(
  initialCameraPosition: const SBBCameraPosition(
    target: LatLng(46.947456, 7.451123), // Bern
    zoom: 15.0,
  ),
  mapStyler: _customStylerWithApiKey // as from above
)
```

###### Accessing user location

This package uses the [geolocator](https://pub.dev/packages/geolocator) flutter plugin for accessing the device location and
asking the user for permissions. See the package for detailed instructions on accessing the device location. In short:
<table style='width:100%'>
  <tr>
    <th>iOS</th>
    <th>Android</th>
  </tr>
  <tr>
    <td>Add this to your `ios/Runner/Info.plist` file.</td>
    <td>Add these to your `android/app/src/main/AndroidManifest.xml`<br>If both are specified, the geolocator plugin uses the `ACCESS_FINE_LOCATION` setting.</td>
  </tr>
  <tr>
    <td>
    <div>
      <pre>
        <code>
&lt;key&gt;NSLocationWhenInUseUsageDescription&lt;/key&gt;
&lt;string&gt;YOUR DESCRIPTION WHY YOU NEED ACCESS TO THE MAP&lt;/string&gt;
        </code>
      </pre>
    </div>
    </td>
    <td>
    <div>
      <pre>
        <code>
&lt;uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" /&gt;
&lt;uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" /&gt;
        </code>
      </pre>
    </div>
    </td>
  </tr>
</table>

###### Focusing on user location when building map

To directly focus the map camera onto the device location when the `SBBMap` is built, use the `OnMapLocatorAvailable` callback and the `SBBMapLocator.trackDeviceLocation()` method. This has the nice side effect, that the user will be prompted for permissions if not granted already.

This can be seen in the *Track Device* route in the example app here: [track_device_location_route.dart](example/lib/routes/track_device_location_route.dart).


#### Tested deployment platforms

|                                         | iOS                | Android SDK        |
| --------------------------------------- | ------------------ | ------------------ |
| Oldest Tested                           | 15.5               | 28                 |
| Latest Tested                           | 17.6               | 34                 |

Tested with the latest (stable channel) and oldest supported (3.19.6) Flutter SDK.

<a id="Documentation"></a>

#### Example App

![Example App Icon](example/gallery/app_icon/icon.png){width=5%}

The **SBB Karten** demo application is available both in the SBB Enterprise Playstore (Android) and in the managed iOS SBB Store (Ivanti MobileIron).

## Documentation

#### Features

| Feature                                 | iOS                | Android            |
|-----------------------------------------| ------------------ | ------------------ |
| Gesture                                 | :white_check_mark: | :white_check_mark: |
| Camera                                  | :white_check_mark: | :white_check_mark: |
| Map Styles (including ROKAS Styles)     | :white_check_mark: | :white_check_mark: |
| Location (including device tracking)    | :white_check_mark: | :white_check_mark: |
| Customizable UI                         | :white_check_mark: | :white_check_mark: |
| Floor Switcher (switch levels)          | :white_check_mark: | :white_check_mark: |
| ROKAS POIs: Display                     | :white_check_mark: | :white_check_mark: |
| ROKAS POIs: Event Triggering and Select | :white_check_mark: | :white_check_mark: |
| **Annotations**                         | :white_check_mark: | :white_check_mark: |
| - Circles (Display & OnClick)           | :white_check_mark: | :white_check_mark: |
| - ROKAS Markers (Display & OnClick)     | :white_check_mark: | :white_check_mark: |
| - Custom Markers  (Display & OnClick)   | :white_check_mark: | :white_check_mark: |
| - Fill Annotations  (Display & OnClick) | :white_check_mark: | :white_check_mark: |
| - Line Annotations  (Display & OnClick) | :white_check_mark: | :white_check_mark: |
| Routing (Beta)                          | :white_check_mark: | :white_check_mark: |


#### Custom Map Properties

Custom properties of the map (e.g. compass position, disabling certain gestures) can be set using
the `SBBMapProperties` class, given as `properties` parameter in the `SBBMap` constructor.

```dart
// the defaults
const SBBMapProperties({
    this.compassEnabled = true,
    this.compassViewPosition = CompassViewPosition.topLeft,
    this.compassViewMargins,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.doubleClickZoomEnabled = true,
    this.dragEnabled = true,
  });
```

### Gallery and Examples

<table style='width:100%'>
  <tr>
    <th>Standard Map</th>
    <th></th>
  </tr>
  <tr>
    <td>The default SBB map with ROKAS styling.</td>
    <td></td>
  </tr>
  <tr>
    <td>
    <div>
      <pre>
        <code>
@override
Widget build(BuildContext context) {
  // api key must be in JOURNEY_MAPS_API_KEY ENV_VAR
  return Scaffold(
    appBar: const SBBHeader(title: 'Standard'),
    body: SBBMap(
      isMyLocationEnabled: true,
    ),
  );
}
        </code>
      </pre>
      </div>
    </td>
    <td style='text-align: center;'><img src="example/gallery/standard_map_example.png" width='33%'></td>
  </tr>
  <tr>
    <th>Plain Map</th>
    <th></th>
  </tr>
  <tr>
    <td>How to disable all UI components while using ROKAS Map styling.</td>
    <td></td>
  </tr>
  <tr>
    <td>
    <div>
      <pre>
        <code>
@override
Widget build(BuildContext context) {
  final mapStyler = SBBRokasMapStyler.noAerial(apiKey: YOUR_API_KEY);
  return Scaffold(
    appBar: const SBBHeader(title: 'Plain'),
    body: SBBMap(
      mapStyler: mapStyler,
      isMyLocationEnabled: false,
      isFloorSwitchingEnabled: false,
    ),
  );
}
        </code>
      </pre>
      </div>
    </td>
    <td style='text-align: center;'><img src="example/gallery/plain_map_example.png" width='33%'></td>
  </tr>
    <tr>
    <th>Camera Movement</th>
    <th></th>
  </tr>
  <tr>
    <td>How to programmatically control camera movement.</td>
    <td></td>
  </tr>
  <tr>
    <td>
    <div>
      <pre>
        <code>
@override
Widget build(BuildContext context) {
  // api key must be in JOURNEY_MAPS_API_KEY ENV_VAR
  return Scaffold(
    appBar: const SBBHeader(title: 'Camera'),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SBBMap(
              initialCameraPosition: const SBBCameraPosition(
                target: LatLng(46.947456, 7.451123), // Bern
                zoom: 8.0,
              ),
              isMyLocationEnabled: true,
              onMapCreated: (controller) =>
                  mapController.complete(controller),
            ),
          ),
          SBBGroup(
            padding: const EdgeInsets.symmetric(
                horizontal: sbbDefaultSpacing / 2,
                vertical: sbbDefaultSpacing / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SBBTertiaryButtonSmall(
                  label: 'Bern',
                  icon: SBBIcons.house_small,
                  onPressed: () => mapController.future.then(
                      (c) => c.animateCameraMove(cameraUpdate: _kCameraBern)),
                ),
                SBBTertiaryButtonSmall(
                  label: 'Zurich',
                  icon: SBBIcons.station_small,
                  onPressed: () => mapController.future.then((c) =>
                      c.animateCameraMove(cameraUpdate: _kCameraZurich)),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
        </code>
      </pre>
      </div>
    </td>
    <td style='text-align: center;'><img src="example/gallery/camera_example.png" width='33%'></td>
  </tr>
    </tr>
    <tr>
    <th>Custom UI</th>
    <th></th>
  </tr>
  <tr>
    <td>How to customize the map ui using the builder.</td>
    <td></td>
  </tr>
  <tr>
    <td>
    <div>
      <pre>
        <code>
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: const SBBHeader(title: 'Custom UI'),
    body: SBBMap(
      mapStyler: mapStyler,
      isMyLocationEnabled: true,
      isFloorSwitchingEnabled: true,
      builder: (context) => const Align(
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ThemeSegmentedButton(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(sbbDefaultSpacing),
                  child: SBBMapStyleSwitcher(),
                ),
                Padding(
                  padding: EdgeInsets.all(sbbDefaultSpacing),
                  child: SBBMapMyLocationButton(),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
        </code>
      </pre>
      </div>
    </td>
    <td style='text-align: center;'><img src="example/gallery/custom_ui_example.png" width='33%'></td>
  </tr>
    <tr>
    <th>POI</th>
    <th></th>
  </tr>
  <tr>
    <td>How to react to POI selection.</td>
    <td></td>
  </tr>
  <tr>
    <td>
    <div>
      <pre>
        <code>
@override
Widget build(BuildContext context) {
  final mapStyler = SBBRokasMapStyler.full(
    apiKey: Env.journeyMapsApiKey,
    isDarkMode: Provider.of<ThemeProvider>(context).isDark,
  );
  return Scaffold(
    appBar: const SBBHeader(title: 'POI'),
    body: SBBMap(
      initialCameraPosition: const SBBCameraPosition(
        target: LatLng(46.947456, 7.451123), // Bern
        zoom: 15.0,
      ),
      isMyLocationEnabled: true,
      mapStyler: mapStyler,
      poiSettings: SBBMapPOISettings(
        isPointOfInterestVisible: true,
        onPoiControllerAvailable: (poiController) =>
            _poiController.complete(poiController),
        onPoiSelected: (poi) => showSBBModalSheet(
          context: context,
          title: poi.name,
          child: const SizedBox(height: 64),
        ).then(
          (_) => _poiController.future.then(
            (c) => c.deselectPointOfInterest(),
          ),
        ),
      ),
    ),
  );
}
        </code>
      </pre>
      </div>
    </td>
    <td style='text-align: center;'><img src="example/gallery/poi_example.png" width='33%'></td>
  </tr>
</table>


Futher documentation files:

- [CODING_STANDARDS.md](CODING_STANDARDS.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [LICENSE.md](LICENSE.md)
- [Journey Maps API Documentation](https://developer.sbb.ch/apis/journey-maps/documentation)
- [Journey Maps Tiles API Documentation](https://developer.sbb.ch/apis/journey-maps-tiles/documentation)

<a id="License"></a>

## License

This project is licensed under [Apache 2.0](LICENSE.md).

<a id="Contributing"></a>

## Contributing

This repository includes a [CONTRIBUTING.md](CONTRIBUTING.md) file that outlines how to contribute to the project, including how to submit bug reports, feature requests, and pull requests.

### Maintainer

- [Nicolas Vidoni](mailto:30844036+smallTrogdor@users.noreply.github.com)

### Contributors
 - Loris Sorace
 - Hoang Tran

<a id="coding-standards"></a>

## Coding Standards

This repository includes a [CODING_STANDARDS.md](CODING_STANDARDS.md) file that outlines the coding standards that you should follow when contributing to the project.

<a id="code-of-conduct"></a>

## Code of Conduct

To ensure that your project is a welcoming and inclusive environment for all contributors, you should establish a good [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)


## Caveats, limitations and known bugs*

### Limitations

* When selecting POIs programmatically with the `RokasPOIController`, one can only select from the POIs that are loaded in the tile source, meaning that trying to select a POI at a very distant place will not be possible. The workaround would be to first move to the geo coordinate and then select the POI.

### Known Bugs

* The [SBBMapStyleSwitchButton] is not working when the [SBBMap] is rebuild and the passed in [SBBMapStyler] is not preserved in the state. Make sure to keep the styler in your state.


[Journey Maps API]: (https://developer.sbb.ch/apis/journey-maps/information)

[Flutter Maplibre GL plugin]: (https://github.com/maplibre/flutter-maplibre-gl/tree/main)

[Journey Maps Tile API]: (https://developer.sbb.ch/apis/journey-maps-tiles/information)