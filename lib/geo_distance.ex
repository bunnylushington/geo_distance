defmodule GeoDistance do

  @moduledoc """

  Using the [Haversine
  formula](http://rosettacode.org/wiki/Haversine_formula#Erlang)
  calculate the distance between two point of latitude/longititude.  

  To and From parameters may be specified as 

       (from_lat, from_long, to_lat, to_long)

  or
  
       ({from_lat, from_long}, {to_lat, to_long})
  """

  @radius 6372.8

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
  Returns distance between two points in KMs.
  """
  def km(from, to), do: haversine(from, to)
  def km(la1, lo1, la2, lo2), do: km({la1, lo1}, {la2, lo2})

  @doc """
  Returns distance between two points in miles.
  """
  def mi(from, to), do: km(from, to) * 0.62137
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

end
