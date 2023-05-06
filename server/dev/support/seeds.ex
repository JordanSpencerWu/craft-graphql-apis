defmodule PlateSlate.Seeds do

  def run() do
    alias PlateSlate.{Accounts, Menu, Repo}

    #
    # TAGS
    #

    vegetarian =
      %Menu.ItemTag{name: "Vegetarian"}
      |> Repo.insert!

    _vegan =
      %Menu.ItemTag{name: "Vegan"}
      |> Repo.insert!

    _gluten_free =
      %Menu.ItemTag{name: "Gluten Free"}
      |> Repo.insert!

    #
    # SANDWICHES
    #

    sandwiches = %Menu.Category{name: "Sandwiches"} |> Repo.insert!

    _rueben =
      %Menu.Item{name: "Reuben", price: 4.50, category: sandwiches, description: "Description for Reuben"}
      |> Repo.insert!

    _croque =
      %Menu.Item{name: "Croque Monsieur", price: 5.50, category: sandwiches, description: "Description for Croque Monsieur"}
      |> Repo.insert!

    _muffuletta =
      %Menu.Item{name: "Muffuletta", price: 5.50, category: sandwiches, description: "Description for Muffuletta"}
      |> Repo.insert!

    _bahn_mi =
      %Menu.Item{name: "Bánh mì", price: 4.50, category: sandwiches, description: "Description for Bánh mì"}
      |> Repo.insert!

    _vada_pav =
      %Menu.Item{name: "Vada Pav", price: 4.50, category: sandwiches, tags: [vegetarian], description: "Description for Vada Pav"}
      |> Repo.insert!

    #
    # SIDES
    #

    sides = %Menu.Category{name: "Sides"} |> Repo.insert!

    _fries =
      %Menu.Item{name: "French Fries", price: 2.50, category: sides, description: "Description for French Fries"}
      |> Repo.insert!

    _papadum =
      %Menu.Item{name: "Papadum", price: 1.25, category: sides, description: "Description for Papadum"}
      |> Repo.insert!

    _pasta_salad =
      %Menu.Item{name: "Pasta Salad", price: 2.50, category: sides, description: "Description for Pasta Salad"}
      |> Repo.insert!

    category = Repo.get_by(Menu.Category, name: "Sides")
    %Menu.Item{
      name: "Thai Salad",
      price: 3.50,
      category: category,
      allergy_info: [
        %{"allergen" => "Peanuts", "severity" => "Contains"},
        %{"allergen" => "Shell Fish", "severity" => "Shared Equipment"},
      ]
    } |> Repo.insert!

    #
    # BEVERAGES
    #

    beverages = %Menu.Category{name: "Beverages"} |> Repo.insert!

    _water =
      %Menu.Item{name: "Water", price: 0, category: beverages, description: "Description for Water"}
      |> Repo.insert!

    _soda =
      %Menu.Item{name: "Soft Drink", price: 1.5, category: beverages, description: "Description for Soft Drink"}
      |> Repo.insert!

    _lemonade =
      %Menu.Item{name: "Lemonade", price: 1.25, category: beverages, description: "Description for Lemonade"}
      |> Repo.insert!

    _chai =
      %Menu.Item{name: "Masala Chai", price: 1.5, category: beverages, description: "Description for Masala Chai"}
      |> Repo.insert!

    _vanilla_milkshake =
      %Menu.Item{name: "Vanilla Milkshake", price: 3.0, category: beverages, description: "Description for Vanilla Milkshake"}
      |> Repo.insert!

    _chocolate_milkshake =
      %Menu.Item{name: "Chocolate Milkshake", price: 3.0, category: beverages, description: "Description for Chocolate Milkshake"}
      |> Repo.insert!

    #
    # Users
    #

    _employee =
      %Accounts.User{}
      |> Accounts.User.changeset(%{role: "employee", name: "Becca Wilson", email: "foo@example.com", password: "abc123"})
      |> Repo.insert!

    _customer =
      %Accounts.User{}
      |> Accounts.User.changeset(%{role: "customer", name: "Joe Hubert", email: "bar@example.com", password: "abc123"})
      |> Repo.insert!

    :ok
  end
end
