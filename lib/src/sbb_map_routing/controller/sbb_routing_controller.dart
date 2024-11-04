import 'package:sbb_maps_flutter/src/sbb_map_routing/geo_json_routing_entities/feature_collection.dart';

/// Interface for routing controllers in the SBB Maps.
///
/// This interface defines methods for routing based on geographic features
/// and GeoJSON data.
///
/// Please note that this controller is currently in BETA and subject to change in future versions
/// of the package.
abstract class SBBRoutingController {
  /// Routes based on a [FeatureCollection].
  ///
  /// The [featureCollection] parameter represents a collection of geographic features
  /// that can be used for routing.
  void routeFromFeatureCollection(FeatureCollection featureCollection);

  /// Routes based on GeoJSON data.
  ///
  /// The [json] parameter is a map representation of the GeoJSON object.
  /// This method parses the GeoJSON data and routes accordingly.
  void routeFromGeoJSON(Map<String, dynamic> json);
}
