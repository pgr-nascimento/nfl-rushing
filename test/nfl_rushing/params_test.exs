defmodule NflRushing.ParamsTest do
  use ExUnit.Case, async: true

  alias NflRushing.Params

  describe "parse/0" do
    test "with empty params, should return the default params" do
      assert %{direction: :desc, order_by: :total_yards, limit: 10, offset: 0} = Params.parse(%{})
    end

    test "with valid params, transform the keys in atom and return the new map" do
      params = %{
        "name" => "test",
        "direction" => "asc",
        "order_by" => "total_yards",
        "limit" => "10",
        "offset" => "20"
      }

      assert %{name: "test", direction: :asc, order_by: :total_yards, limit: 10, offset: 20} =
               Params.parse(params)
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
      assert %{direction: :desc} = Params.parse(params)
    end

    test "with invalid order_by, use the total_yards to order" do
      params = %{"order_by" => "name"}

      assert %{order_by: :total_yards} = Params.parse(params)
    end

    test "with invalid limit, use the default limit" do
      params = %{"limit" => "test"}

      assert %{limit: 10} = Params.parse(params)
    end

    test "with invalid offset, use the default offset" do
      params = %{"offset" => "test"}

      assert %{offset: 0} = Params.parse(params)
    end

    test "with negative offset, use the default offset" do
      params = %{"offset" => "-1"}

      assert %{offset: 0} = Params.parse(params)
    end
  end
end
