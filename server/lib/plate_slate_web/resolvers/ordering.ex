defmodule PlateSlateWeb.Resolvers.Ordering do
  alias PlateSlate.Ordering

  def ready_order(_parent, %{id: id}, _resolution) do
    order = Ordering.get_order!(id)

    with {:ok, order} <- Ordering.update_order(order, %{state: "ready"}) do
      {:ok, %{order: order}}
    end
  end

  def complete_order(_parent, %{id: id}, _resolution) do
    order = Ordering.get_order!(id)

    with {:ok, order} <- Ordering.update_order(order, %{state: "complete"}) do
      {:ok, %{order: order}}
    end
  end

  def place_order(_parent, %{input: place_order_input}, _resolution) do
    case Ordering.create_order(place_order_input) do
      {:ok, order} ->
        Absinthe.Subscription.publish(PlateSlateWeb.Endpoint, order, new_order: "*")
        {:ok, %{order: order}}
    end
  end
end
