defmodule NflRushing.Params do
  @valid_directions ["asc", "desc"]
  @sortable_fields ["total_yards", "longest_rush", "total_touchdowns"]

  defp base_params do
    %{direction: :asc}
  end

  def parse(wire_params) do
    Enum.reduce(wire_params, base_params(), &compose_params/2)
  end

  defp compose_params({"name", name}, params) do
    Map.put(params, :name, name)
  end

  defp compose_params({"order_by", field}, params) when field in @sortable_fields do
    Map.put(params, :order_by, String.to_existing_atom(field))
  end

  defp compose_params({"direction", direction}, params) when direction in @valid_directions do
    Map.put(params, :direction, String.to_existing_atom(direction))
  end

  defp compose_params(_wire_params, params), do: params
end
