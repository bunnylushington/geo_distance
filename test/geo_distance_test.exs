defmodule GeoDistanceTest do
  use ExUnit.Case

  test "m to k, k to m" do
    assert Float.round(GeoDistance.miles_to_km(1), 6) == 1.609344
    assert GeoDistance.km_to_miles(1) == 0.621371192237
  end
  
  # http://rosettacode.org/wiki/Haversine_formula#Erlang
  @a1 36.12
  @a2 33.94
  @o1 -86.67
  @o2 -118.40
  @from {@a1, @o1}
  @to {@a2, @o2}
  @distance_km 2887.2599506071106
  @distance_mi 1794.06

  
  # Carefully researched!
  @fortress   {29.9673338, -90.0558269}
  @spottedcat {29.9640677, -90.0576594}
  @stlawrence {29.952786,  -90.065518}
  
  test "from rosettacode entry" do
    assert GeoDistance.km(@from, @to) == @distance_km
    assert GeoDistance.km(@to, @from) == @distance_km
  end

  test "as miles" do
    assert Float.round(GeoDistance.mi(@from, @to), 3) == @distance_mi
    assert Float.round(GeoDistance.mi(@to, @from), 3) == @distance_mi
  end

  test "alternate signatures" do
    assert GeoDistance.mi(@from, @to) == GeoDistance.mi(@a1, @o1, @a2, @o2)
    assert GeoDistance.km(@from, @to) == GeoDistance.km(@a1, @o1, @a2, @o2)
  end

  test "inside, outside" do
    assert GeoDistance.in_radius_mi?(@fortress, @spottedcat, 0.5)
    refute GeoDistance.in_radius_mi?(@fortress, @stlawrence, 0.5)

    assert GeoDistance.in_radius_km?(@fortress, @spottedcat, 0.5)
    refute GeoDistance.in_radius_km?(@fortress, @stlawrence, 0.5)
  end


  # See http://janmatuschek.de/LatitudeLongitudeBoundingCoordinates
  # for a narrative of how this works.  The examples were taken from
  # https://www.briandunning.com/cf/1491 and rounded just a little.
  @mm_test_lat  37.4064806
  @mm_test_long -121.984204
  @mm_test_maxl 37.4155
  @mm_test_minl 37.3975
  @mm_test_maxg -121.9729
  @mm_test_ming -121.9955
  @mm_test_distance 1.0
  
  test "min/max lat" do
    {minl, maxl} = GeoDistance.latitude_bounds(@mm_test_lat, @mm_test_distance)
    assert Float.round(minl, 4) == @mm_test_minl
    assert Float.round(maxl, 4) == @mm_test_maxl
  end

  test "min/max long" do
    {ming, maxg} = GeoDistance.longitude_bounds(@mm_test_lat, @mm_test_long,
                                                  @mm_test_distance)
    assert Float.round(maxg, 4) == @mm_test_maxg
    assert Float.round(ming, 4) == @mm_test_ming
  end

  test "bounding coordinates" do
    {{minl, maxl}, {ming, maxg}} =
      GeoDistance.bounds_km(@mm_test_lat, @mm_test_long, @mm_test_distance)
    assert Float.round(maxg, 4) == @mm_test_maxg
    assert Float.round(ming, 4) == @mm_test_ming
    assert Float.round(minl, 4) == @mm_test_minl
    assert Float.round(maxl, 4) == @mm_test_maxl

    test_distance_mi = GeoDistance.km_to_miles(@mm_test_distance)
    
    {{minl, maxl}, {ming, maxg}} =
      GeoDistance.bounds_mi(@mm_test_lat, @mm_test_long, test_distance_mi)
    assert Float.round(maxg, 4) == @mm_test_maxg
    assert Float.round(ming, 4) == @mm_test_ming
    assert Float.round(minl, 4) == @mm_test_minl
    assert Float.round(maxl, 4) == @mm_test_maxl
  end

end
