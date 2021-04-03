defmodule YebosterWeb.PageController do
  use YebosterWeb, :controller

  alias Yeboster.Knowledge

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def inspiration(conn, _params) do
    fact = Knowledge.get_random_fact()
    render(conn, "inspiration.html", fact: fact)
  end

  def contact(conn, _params) do
    render(conn, "contact.html")
  end
end
