defmodule FoodTruckWeb.Validation do
  @moduledoc false
  alias :liver, as: Liver

  defp filter_schema() do
    %{
      "id" => [],
      "applicant" => [],
      "facility_type" => [],
      "cnn" => [],
      "location_description" => [],
      "address" => [],
      "blocklot" => [],
      "block" => [],
      "lot" => [],
      "permit" => [],
      "status" => [],
      "food_items" => [],
      "x" => [],
      "y" => [],
      "latitude" => [],
      "longitude" => [],
      "schedule" => [],
      "dayshours" => [],
      "noi_sent" => [],
      "approved" => [],
      "received" => [],
      "prior_permit" => [],
      "expiration_date" => [],
      "location" => [],
      "fire_prevention_districts" => [],
      "police_districts" => [],
      "supervisor_districts" => [],
      "zip_codes" => [],
      "neighborhoods" => []
    }
  end

  def is_valid_request(params),
    do: Liver.validate(filter_schema(), params, [{:strict, true}])
end
