defmodule GeoDistanceTest do
  use ExUnit.Case

  # http://rosettacode.org/wiki/Haversine_formula#Erlang
  @a1 36.12
  @a2 33.94
  @o1 -86.67
  @o2 -118.40
  @from {@a1, @o1}
  @to {@a2, @o2}
  @distance_km 2887.2599506071106
  @distance_mi 1794.057

  
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
  # for a narrative of how this works and where these test cases are
  # derived.
  @mm_test_lat 1.3963
  @mm_test_long -0.6981
  @mm_test_maxl 1.5532
  @mm_test_minl 1.2394
  @mm_test_maxg 0.422
  @mm_test_ming -1.818
  @mm_test_distance 1000
  
  test "min/max lat" do
    {minl, maxl} = GeoDistance.latitude_bounds(@mm_test_lat, @mm_test_distance)
    assert Float.round(minl, 4) == @mm_test_minl
    assert Float.round(maxl, 4) == @mm_test_maxl
  end

  test "min/max long" do
    {ming, maxg} = GeoDistance.longititude_bounds(@mm_test_lat, @mm_test_long,
                                                  @mm_test_distance)
    assert Float.round(maxg, 3) == @mm_test_maxg
    assert Float.round(ming, 3) == @mm_test_ming
  end

  
end
