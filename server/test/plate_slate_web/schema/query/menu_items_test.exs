defmodule PlateSlateWeb.Schema.Query.MenuItemsTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Seeds.run()
  end

  @query """
  {
    menuItems {
      description
      name
      price
    }
  }
  """
  test "menuItems field return menu items" do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
             "data" => %{
               "menuItems" => [
                 %{
                   "name" => "Reuben",
                   "description" => "Description for Reuben",
                   "price" => "4.5"
                 },
                 %{
                   "name" => "Croque Monsieur",
                   "description" => "Description for Croque Monsieur",
                   "price" => "5.5"
                 },
                 %{
                   "name" => "Muffuletta",
                   "description" => "Description for Muffuletta",
                   "price" => "5.5"
                 },
                 %{
                   "name" => "Bánh mì",
                   "description" => "Description for Bánh mì",
                   "price" => "4.5"
                 },
                 %{
                   "name" => "Vada Pav",
                   "description" => "Description for Vada Pav",
                   "price" => "4.5"
                 },
                 %{
                   "name" => "French Fries",
                   "description" => "Description for French Fries",
                   "price" => "2.5"
                 },
                 %{
                   "name" => "Papadum",
                   "description" => "Description for Papadum",
                   "price" => "1.25"
                 },
                 %{
                   "name" => "Pasta Salad",
                   "description" => "Description for Pasta Salad",
                   "price" => "2.5"
                 },
                 %{
                   "name" => "Water",
                   "description" => "Description for Water",
                   "price" => "0"
                 },
                 %{
                   "name" => "Soft Drink",
                   "description" => "Description for Soft Drink",
                   "price" => "1.5"
                 },
                 %{
                   "name" => "Lemonade",
                   "description" => "Description for Lemonade",
                   "price" => "1.25"
                 },
                 %{
                   "name" => "Masala Chai",
                   "description" => "Description for Masala Chai",
                   "price" => "1.5"
                 },
                 %{
                   "name" => "Vanilla Milkshake",
                   "description" => "Description for Vanilla Milkshake",
                   "price" => "3.0"
                 },
                 %{
                   "name" => "Chocolate Milkshake",
                   "description" => "Description for Chocolate Milkshake",
                   "price" => "3.0"
                 }
               ]
             }
           }
  end
end
