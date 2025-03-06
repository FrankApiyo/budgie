defmodule Budgie.TrackingTest do
  use Budgie.DataCase
  import Budgie.TrackingFixtures

  alias Budgie.Tracking

  describe "budgets" do
    alias Budgie.Tracking.Budget

    test "create_budget/2 with valid data creates budget" do
      user = Budgie.AccountsFixtures.user_fixture()

      valid_attrs = %{
        name: "some name",
        description: "some descriptions",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-01-03],
        creator_id: user.id
      }

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert budget.name == "some name"
      assert budget.description == "some descriptions"
      assert budget.start_date == ~D[2025-01-01]
      assert budget.end_date == ~D[2025-01-03]
      assert budget.creator_id == user.id
    end

    test "create_budget/2 requires name" do
      user = Budgie.AccountsFixtures.user_fixture()

      attrs_without_name = %{
        description: "some descriptions",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-01-03],
        creator_id: user.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(attrs_without_name)

      assert changeset.valid? == false

      assert %{name: ["can't be blank"]} ==
               errors_on(changeset)

      assert Keyword.keys(changeset.errors) == [:name]
    end

    test "create_budget/2 requires valid dates" do
      user = Budgie.AccountsFixtures.user_fixture()

      attrs_ends_before_start = %{
        name: "some name",
        description: "some description",
        start_date: ~D[2025-01-01],
        end_date: ~D[2024-01-01],
        creator_id: user.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Tracking.create_budget(attrs_ends_before_start)

      assert changeset.valid? == false

      assert %{end_date: ["must end after start date"]} ==
               errors_on(changeset)

      assert Keyword.keys(changeset.errors) == [:end_date]
    end

    test "list_budget/0 returns all budgets" do
      budget = budget_fixture()
      assert Tracking.list_budgets() == [budget]
    end

    test "get_budget/1 returns the budget with given id" do
      budget = budget_fixture()

      assert Tracking.get_budget(budget.id) == budget
    end

    test "get_budget/1 returns nil when budget does not exist" do
      _unrelated_budget = budget_fixture()
      assert is_nil(Tracking.get_budget("10fe1ad8-6133-5d7d-b5c9-da29581bb923"))
    end
  end
end
