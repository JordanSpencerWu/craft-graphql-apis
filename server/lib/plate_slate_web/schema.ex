defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlate.{Menu, Repo}

  import_types(Absinthe.Type.Custom)

  query do
    @desc "The list of available items on the menu"
    field :menu_items, list_of(:menu_item) do
      resolve(fn _, _, _ ->
        {:ok, Repo.all(Menu.Item)}
      end)
    end
  end

  @desc "A item in a menu"
  object :menu_item do
    @desc "id"
    field :id, :id
    @desc "date of when menu item was added"
    field :added_on, :date
    @desc "description of menu item"
    field :description, :string
    @desc "name of menu item"
    field :name, :string
    @desc "price of menu item"
    field :price, :decimal
  end
end
