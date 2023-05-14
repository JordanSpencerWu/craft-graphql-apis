defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.Menu

  # import Absinthe.Resolution.Helpers, only: [on_load: 2]

  def menu_items(_parent, args, _resolution) do
    {:ok, Menu.list_items(args)}
  end

  # def items_for_category(category, args, %{context: %{loader: loader}}) do
  #   loader
  #   |> Dataloader.load(Menu, {:items, args}, category)
  #   |> on_load(fn loader ->
  #     items = Dataloader.get(loader, Menu, {:items, args}, category)
  #     {:ok, items}
  #   end)
  # end

  # def category_for_item(menu_item, _, _) do
  #   batch({PlateSlate.Menu, :categories_by_id}, menu_item.category_id, fn
  #     categories ->
  #       {:ok, Map.get(categories, menu_item.category_id)}
  #   end)
  # end

  # def category_for_item(menu_item, _, %{context: %{loader: loader}}) do
  #   loader
  #   |> Dataloader.load(Menu, :category, menu_item)
  #   |> on_load(fn loader ->
  #     category = Dataloader.get(loader, Menu, :category, menu_item)
  #     {:ok, category}
  #   end)
  # end

  def search(_parent, %{matching: term}, _resolution) do
    {:ok, Menu.search(term)}
  end

  def create_item(_parent, %{input: params}, _resolution) do
    with {:ok, item} <- Menu.create_item(params) do
      {:ok, %{menu_item: item}}
    end
  end
end
