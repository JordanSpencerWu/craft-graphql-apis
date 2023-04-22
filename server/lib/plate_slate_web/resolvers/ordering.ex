defmodule PlateSlateWeb.Resolvers.Ordering do
  alias PlateSlate.Ordering

  def ready_order(_parent, %{id: id}, _resolution) do
    order = Ordering.get_order!(id)

    with {:ok, order} <- Ordering.update_order(order, %{state: "ready"}) do
      {:ok, %{order: order}}
    else
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
    end
  end

  def complete_order(_parent, %{id: id}, _resolution) do
    order = Ordering.get_order!(id)

    with {:ok, order} <- Ordering.update_order(order, %{state: "complete"}) do
      {:ok, %{order: order}}
    else
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
    end
  end

  def place_order(_parent, %{input: place_order_input}, _resolution) do
    case Ordering.create_order(place_order_input) do
      {:ok, order} ->
        Absinthe.Subscription.publish(PlateSlateWeb.Endpoint, order, new_order: "*")
        {:ok, %{order: order}}

      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
    end
  end

  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn
      {key, value} ->
        %{key: key, message: value}
    end)
  end

  @spec format_error(Ecto.Changeset.error()) :: String.t()
  defp format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
