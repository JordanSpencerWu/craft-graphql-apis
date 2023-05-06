defmodule PlateSlate.AccountsTest do
  use PlateSlate.DataCase, async: true

  alias PlateSlate.Accounts
  alias PlateSlate.Accounts.User

  @user %{
    role: "employee",
    name: "Becca Wilson",
    email: "foo@example.com",
    password: "abc123"
  }

  setup do
    user =
      %User{}
      |> User.changeset(@user)
      |> Repo.insert!()

    %{user: user}
  end

  describe "accounts" do
    test "authenticate/3 with valid email and password", %{user: user} do
      invalid_password = "123"
      :error = Accounts.authenticate(@user.role, @user.email, invalid_password)

      {:ok, authenticated_user} = Accounts.authenticate(@user.role, @user.email, @user.password)

      assert authenticated_user == user
    end
  end
end
