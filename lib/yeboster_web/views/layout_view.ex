defmodule YebosterWeb.LayoutView do
  use YebosterWeb, :view

  defp navbar_link(conn, text, [to: route, class: classes]) do
    current_path = conn.request_path
    all_classes = if current_path == route do
      classes <> " nav-active"
    else
      classes <> " nav-inactive"
    end

    link(
      text,
      to: route,
      class: all_classes
    )
  end
end
