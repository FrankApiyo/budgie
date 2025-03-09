defmodule BudgetWeb.BudgetShowListsTest do
  use BudgieWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Budgie.TrackingFixtures

  setup do
    user = Budgie.AccountsFixtures.user_fixture()
    budget = budget_fixture(%{creator_id: user.id})

    %{user: user, budget: budget}
  end

  describe "show budget" do
    test "show budget when it exists", %{conn: conn, user: user, budget: budget} do
      conn = log_in_user(conn, user)
      {:ok, _lv, html} = live(conn, ~p"/budgets/#{budget}")

      assert html =~ budget.name
    end

    test "redirect to budget list page when budget does not exist", %{conn: conn, user: user} do
      fake_budget_id = Ecto.UUID.generate()

      conn = log_in_user(conn, user)

      {:ok, conn} =
        conn
        |> live(~p"/budgets/#{fake_budget_id}")
        |> follow_redirect(conn, ~p"/budgets")

      assert %{"error" => "Budget not found"} = conn.assigns.flash
    end

    test "redirect to budget list page when an invalid budget id is supplied", %{
      conn: conn,
      budget: _budget,
      user: user
    } do
      conn = log_in_user(conn, user)

      {:ok, conn} =
        conn
        |> live(~p"/budgets/thisisatest")
        |> follow_redirect(conn, ~p"/budgets")

      assert %{"error" => "Budget not found"} = conn.assigns.flash
    end

    test "redirect to budget list page when budget is hidden from user", %{
      conn: conn,
      user: _user,
      budget: budget
    } do
      other_user = Budgie.AccountsFixtures.user_fixture()

      conn = log_in_user(conn, other_user)

      {:ok, conn} =
        conn
        |> live(~p"/budgets/#{budget}")
        |> follow_redirect(conn, ~p"/budgets")

      assert %{"error" => "Budget not found"} = conn.assigns.flash
    end
  end
end
