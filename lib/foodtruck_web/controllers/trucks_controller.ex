defmodule FoodTruckWeb.Api.TrucksController do
  use FoodTruckWeb, :controller

  alias FoodTruck.Trucks.Trucks
  alias FoodTruckWeb.Validation
  alias Plug.Conn

  require Logger

  def show(conn, params) do
    Logger.debug("show: #{inspect(params)}")

    case Trucks.get(params) do
      nil ->
        conn
        |> Conn.put_status(404)
        |> Conn.send_resp(:not_found, "")

      truck ->
        render(add_cors(conn), "show.json", data: truck)
    end
  end

  def delete(conn, params) do
    Logger.debug("show: #{inspect(params)}")

    Trucks.delete(params)

    conn
    |> Conn.put_status(204)
    |> Conn.send_resp(:no_content, "")
  end

  def truck(conn, params) do
    Logger.debug("Upsert truck: #{inspect(params)}")
    params = Map.put(params, "id", unique_id())

    case Validation.is_valid_request(params) do
      {:ok, _} ->
        with {:ok, truck} <- Trucks.upsert(params) do
          render(add_cors(conn), "show.json", data: truck)
        else
          {:error, %Ecto.Changeset{}} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Invalid request"})

          _ ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Internal server error"})
        end

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(reason)
    end
  end

  def options(conn, _params) do
    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("access-control-allow-methods", "GET, POST, PUT, DELETE, OPTIONS")
    |> put_resp_header("access-control-allow-headers", "content-type,authorization")
    |> send_resp(204, "")
  end

  def list(conn, params) do
    Logger.debug("trucks: #{inspect(params)}")

    render(add_cors(conn), "show.json", data: Trucks.list())
  end

  def list_with_filters(conn, params) do
    Logger.debug("list_with_filters: #{inspect(params)}")
    render(add_cors(conn), "show.json", data: Trucks.list(params))
  end

  def gps_list(conn, params) do
    Logger.debug("gps_list: #{inspect(params)}")
    render(add_cors(conn), "show.json", gps_data: Trucks.list())
  end

  def gps_list_with_filters(conn, params) do
    Logger.debug("gps_list_with_filters: #{inspect(params)}")
    render(add_cors(conn), "show.json", gps_data: Trucks.list(params))
  end

  defp add_cors(conn) do
    Plug.Conn.put_resp_header(conn, "Access-Control-Allow-Origin", "*")
  end

  defp unique_id() do
    # Need to do this to adhere to the integer type for "id"
    # Autogenerate would need e.g. UUID type
    :erlang.phash2(:erlang.unique_integer([:positive]), 1_000_000) + 1_000_000
  end
end
