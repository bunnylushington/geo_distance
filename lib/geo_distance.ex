defmodule GeoDistance do

  @moduledoc """
  Using the [Haversine
  formula](http://rosettacode.org/wiki/Haversine_formula#Erlang)
  calculate the distance between two point of latitude/longititude.  

  To and From parameters may be specified as 

       (from_lat, from_long, to_lat, to_long)

  or
  
       ({from_lat, from_long}, {to_lat, to_long})

  Latitude and Longitude bounding coordinates can be computed using
  the [formulae
  provided](http://janmatuschek.de/LatitudeLongitudeBoundingCoordinates)
  by Jan Philip Matuschek.
  """

  @radius 6372.8
  @mk_conversion 0.621371192237

  defp haversine({lat_1, long_1}, {lat_2, long_2}) do
    v = :math.pi/180
    r = @radius
    diff_lat = (lat_2 - lat_1) * v
    diff_long = (long_2 - long_1) * v
    nlat = lat_1 * v
    nlong = lat_2 * v
    a = (:math.sin(diff_lat/2) * :math.sin(diff_lat/2) +
         :math.sin(diff_long/2) * :math.sin(diff_long/2) *
         :math.cos(nlat) * :math.cos(nlong))
    c = 2 * :math.asin(:math.sqrt(a))
    r * c
  end


  @doc """ 
  Computes {{min_lat, max_lat}, {min_long, max_long}} given
  origin_lat, origin_long, and distance (in KM)
  """
  def bounds_km(origin_lat, origin_long, distance) do
    {latitude_bounds(origin_lat, distance),
     longitude_bounds(origin_lat, origin_long, distance)}
  end

  @doc """ 
  Computes {{min_lat, max_lat}, {min_long, max_long}} given
  origin_lat, origin_long, and distance (in miles)
  """
  def bounds_mi(origin_lat, origin_long, distance) do
    bounds_km(origin_lat, origin_long, miles_to_km(distance))
  end
  
  @doc """
  Returns the {minimum,maximum} latitude of the bounding box.
  """
  def latitude_bounds(origin_lat, distance) do
    r = distance/@radius
    {(origin_lat - r), (origin_lat + r)}
  end

  @doc """
  Returns the {minimum,maximum} longititude of the bounding box.
  """
  def longitude_bounds(origin_lat, origin_long, distance) do
    r = distance/@radius
    delta = :math.asin(:math.sin(r) / :math.cos(origin_lat))
    {(origin_long - delta), (origin_long + delta)}
  end

  @doc """
  Returns distance between two points in KMs.
  """
  def km(from, to), do: haversine(from, to)
  def km(la1, lo1, la2, lo2), do: km({la1, lo1}, {la2, lo2})

  @doc """
  Returns distance between two points in miles.
  """
  def mi(from, to), do: km(from, to) |> km_to_miles
  def mi(la1, lo1, la2, lo2), do: mi({la1, lo1}, {la2, lo2})

  @doc """ 
  Returns true if distance between from and to is within the specified
  radius (measured in KMs).
  """
  def in_radius_km?(from, to, radius), do: km(from, to) < radius
  def in_radius_km?(la1, lo1, la2, lo2, radius) do
    in_radius_km?({la1, lo1}, {la2, lo2}, radius)
  end

  @doc """
  Returns true if distance between from and two is within the
  specified radius (measured in miles).  
  """
  def in_radius_mi?(from, to, radius), do: mi(from, to) < radius
  def in_radius_mi?(la1, lo1, la2, lo2, radius) do
    in_radius_mi?({la1, lo1}, {la2, lo2}, radius)
  end

  @doc """
  Converts KMs to miles.
  """
  def km_to_miles(x), do: x * @mk_conversion

  @doc """
  Converts miles to KMs.
  """
  def miles_to_km(x), do: x / @mk_conversion
    
end
