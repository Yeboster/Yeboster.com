defmodule YebosterWeb.PageController do
  use YebosterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def inspiration(conn, _params) do
    render(conn, "inspiration.html")
  end

  def contact(conn, _params) do
    render(conn, "contact.html")
  end
end
