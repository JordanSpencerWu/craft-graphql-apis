defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.Menu
  alias PlateSlate.Repo

  def menu_items(_parent, args, _resolution) do
    {:ok, Menu.list_items(args)}
  end

  def items_for_category(category, _args, _resolution) do
    query = Ecto.assoc(category, :items)
    {:ok, Repo.all(query)}
  end

  def search(_parent, %{matching: term}, _resolution) do
    {:ok, Menu.search(term)}
  end

  def create_item(_parent, %{input: params}, _resolution) do
    with {:ok, item} <- Menu.create_item(params) do
      {:ok, %{menu_item: item}}
    end
  end
end
