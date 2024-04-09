defmodule FoodTruckWeb.Router do
  @moduledoc false
  use FoodTruckWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", FoodTruckWeb.Api, as: :api do
    pipe_through(:api)

    scope "/trucks" do
      post("/", TrucksController, :truck)
      post("/get", TrucksController, :list_with_filters)
      get("/", TrucksController, :list)
      options("/get/gps", TrucksController, :options)
      post("/get/gps", TrucksController, :gps_list_with_filters)
      get("/gps/", TrucksController, :gps_list)
      get("/:id", TrucksController, :show)
      delete("/:id", TrucksController, :delete)
    end
  end
end
