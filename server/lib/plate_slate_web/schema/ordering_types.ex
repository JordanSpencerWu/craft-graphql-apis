defmodule PlateSlateWeb.Schema.OrderingTypes do
  use Absinthe.Schema.Notation

  alias PlateSlateWeb.Resolvers
  alias PlateSlateWeb.Schema.Middleware

  object :ordering_mutations do
    @desc "Place a order"
    field :place_order, :order_result do
      @desc "order input object"
      arg(:input, non_null(:place_order_input))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.Ordering.place_order/3)
    end

    @desc "Order is ready"
    field :ready_order, :order_result do
      @desc "Id of order"
      arg(:id, non_null(:id))
      resolve(&Resolvers.Ordering.ready_order/3)
    end

    @desc "Order is complete"
    field :complete_order, :order_result do
      @desc "Id of order"
      arg(:id, non_null(:id))
      resolve(&Resolvers.Ordering.complete_order/3)
    end
  end

  object :ordering_subscriptions do
    field :update_order, :order do
      arg(:id, non_null(:id))

      config(fn args, _info ->
        {:ok, topic: args.id}
      end)

      trigger([:ready_order, :complete_order],
        topic: fn
          %{order: order} -> [order.id]
          _ -> []
        end
      )

      resolve(fn %{order: order}, _args, _info ->
        {:ok, order}
      end)
    end

    field :new_order, :order do
      config(fn _args, %{context: context} ->
        case context[:current_user] do
          %{role: "customer", id: id} ->
            {:ok, topic: id}

          %{role: "employee"} ->
            {:ok, topic: "*"}

          _ ->
            {:error, "unauthorized"}
        end
      end)
    end
  end

  input_object :order_item_input do
    field :menu_item_id, non_null(:id)
    field :quantity, non_null(:integer)
  end

  input_object :place_order_input do
    field :customer_number, :integer
    field :items, non_null(list_of(non_null(:order_item_input)))
  end

  object :order_result do
    field :order, :order
    field :errors, list_of(:input_error)
  end

  object :order do
    field :id, :id
    field :customer_number, :integer
    field :items, list_of(:order_item)
    field :state, :string
  end

  object :order_item do
    field :name, :string
    field :quantity, :integer
  end
end
