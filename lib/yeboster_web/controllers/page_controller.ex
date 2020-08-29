defmodule YebosterWeb.PageController do
  use YebosterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
