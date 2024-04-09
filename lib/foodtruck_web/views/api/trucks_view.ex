defmodule FoodTruckWeb.Api.TrucksView do
  @moduledoc false

  use FoodTruckWeb, :view
  alias FoodTruckWeb.Api.TrucksView

  def render("show.json", %{data: result}) do
    render_one(result, TrucksView, "trucks.json")
  end

  def render("show.json", %{gps_data: result}) do
    for r <- result do
      r
      |> Map.from_struct()
      |> get_gps()
    end
  end

  def render("trucks.json", %{trucks: trucks}) when is_list(trucks) do
    for r <- trucks do
      r
      |> Map.from_struct()
      |> Map.delete(:__meta__)
    end
  end

  def render("trucks.json", %{trucks: trucks}) do
    trucks
    |> Map.from_struct()
    |> Map.delete(:__meta__)
  end

  defp get_gps(%{latitude: "0", longitude: "0"} = m) do
    m
    |> Map.put(:lat, 0)
    |> Map.put(:lng, 0)
    |> Map.delete(:__meta__)
  end

  defp get_gps(%{latitude: lat, longitude: long} = m) do
    m
    |> Map.put(:lat, :erlang.binary_to_float(lat))
    |> Map.put(:lng, :erlang.binary_to_float(long))
    |> Map.delete(:__meta__)
  end
end
