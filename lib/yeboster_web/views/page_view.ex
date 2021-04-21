defmodule YebosterWeb.PageView do
  use YebosterWeb, :view

  def my_age do
    {:ok, birthdate} = Date.new(1999, 06, 29)
    today = Date.utc_today()

    Date.diff(
      today,
      birthdate
    )
    |> Integer.floor_div(365)
  end
end
