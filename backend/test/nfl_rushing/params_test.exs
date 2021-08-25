defmodule NflRushing.ParamsTest do
  use ExUnit.Case, async: true

  alias NflRushing.Params

  describe "parse/0" do
    test "with empty params, should return the direction param" do
      assert %{direction: :asc} = Params.parse(%{})
    end

    test "with valid params, transform the keys in atom and return the new map" do
      params = %{"name" => "test", "direction" => "asc", "order_by" => "total_yards"}

      assert %{name: "test", direction: :asc, order_by: :total_yards} = Params.parse(params)
    end

    test "with valid params and invalid, transform the valid ones and return the new map" do
      params = %{
        "name" => "test",
        "direction" => "asc",
        "order_by" => "total_yards",
        "total_fumbles" => 19
      }

      assert %{name: "test", direction: :asc, order_by: :total_yards} = Params.parse(params)
    end

    test "with invalid direction, return the default direction" do
      params = %{"direction" => "updown"}
      assert %{direction: :asc} = Params.parse(params)
    end

    test "with invalid order_by, remove the order" do
      params = %{"order_by" => "name"}

      refute Map.has_key?(Params.parse(params), :order_by)
    end
  end
end
