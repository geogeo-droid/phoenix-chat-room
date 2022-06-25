defmodule TomboChat.AccountsTest do
  use TomboChat.DataCase, async: true

  alias TomboChat.Accounts
  alias TomboChat.Accounts.User

  describe "register_user/1" do
    @valid_attrs %{
      name: "User",
      username: "user",
      password: "super_secret",
      email: "test@example.com"
    }
    @invalid_attrs %{}

    test "with valid data inserts user" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.name == @valid_attrs.name
      assert user.username == @valid_attrs.username
      assert user.email == @valid_attrs.email
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data does not insert user" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert [] == Accounts.list_users()
    end

    test "enforces unique usernames" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)

      assert %{username: ["has already been taken"]} = errors_on(changeset)

      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "does not accept long usernames" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
      {:error, changeset} = Accounts.register_user(attrs)

      assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)

      assert [] == Accounts.list_users()
    end

    test "requires password to be at least 8 chars long" do
      attrs = Map.put(@valid_attrs, :password, "1234567")
      {:error, changeset} = Accounts.register_user(attrs)

      assert %{password: ["should be at least 8 character(s)"]} = errors_on(changeset)

      assert [] == Accounts.list_users()
    end
  end

  describe "authenticate_by_username_and_pass/2" do
    @pass "12345678"

    setup do
      {:ok, user: user_fixture(password: @pass)}
    end

    test "returns user with correct password", %{user: user} do
      assert {:ok, auth_user} = Accounts.authenticate_by_username_and_pass(user.username, @pass)

      assert user.id == auth_user.id
    end

    test "returns unauthorized error with invalid password", %{user: user} do
      assert {:error, :unauthorized} =
               Accounts.authenticate_by_username_and_pass(user.username, "bad_pass")
    end

    test "returns not found error" do
      assert {:error, :not_found} =
               Accounts.authenticate_by_username_and_pass("unknown_user", @pass)
    end
  end
end
