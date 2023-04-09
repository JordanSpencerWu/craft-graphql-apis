defmodule PlateSlateWeb.Schema.MenuTypes do
  use Absinthe.Schema.Notation

  alias PlateSlateWeb.Resolvers

  object :menu_queries do
    @desc "The list of available items on the menu"
    field :menu_items, list_of(:menu_item) do
      @desc "filter by menu item filter"
      arg(:filter, :menu_item_filter)
      @desc "order by asc or desc"
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end

    @desc "Search for menu item or category"
    field :search, list_of(:search_result) do
      @desc "matching by of menu item name or category name"
      arg(:matching, non_null(:string))
      resolve(&Resolvers.Menu.search/3)
    end
  end

  @desc "Filtering options for the menu item list"
  input_object :menu_item_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Matching a category name"
    field :category, :string

    @desc "Matching a tag"
    field :tag, :string

    @desc "Priced above a value"
    field :priced_above, :float

    @desc "Priced below a value"
    field :priced_below, :float

    @desc "Added to the menu before this date"
    field :added_before, :date

    @desc "Added to the menu after this date"
    field :added_after, :date
  end

  @desc "A item in a menu"
  object :menu_item do
    interfaces([:search_result])
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

  @desc "A category of menu items"
  object :category do
    interfaces([:search_result])
    @desc "name of category"
    field :name, :string
    @desc "description of category"
    field :description, :string
    @desc "list of menu items"
    field :items, list_of(:menu_item) do
      resolve(&Resolvers.Menu.items_for_category/3)
    end
  end
end