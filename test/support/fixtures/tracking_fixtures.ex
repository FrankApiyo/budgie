defmodule Budgie.TrackingFixtures do
  alias Budgie.AccountsFixtures

  defp valid_budget_attrs(attrs) do
    user = AccountsFixtures.user_fixture()

    Enum.into(attrs, %{
      creator_id: user.id,
      name: "some name",
      start_date: ~D[2025-01-01],
      end_date: ~D[2025-01-03]
    })
  end

  def budget_fixture(attrs \\ %{}) do
    {:ok, budget} =
      attrs
      |> valid_budget_attrs()
      |> Budgie.Tracking.create_budget()

    budget
  end
end
