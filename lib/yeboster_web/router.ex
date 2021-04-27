defmodule YebosterWeb.Router do
  use YebosterWeb, :router

  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    # TODO: Enforce CSP
    plug :put_secure_browser_headers, %{"Content-Security-Policy" => ""}
    plug :put_root_layout, {YebosterWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", YebosterWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :about
    live "/knowledge", KnowledgeLive, :index
    get "/contact", PageController, :contact
  end

  # Other scopes may use custom stacks.
  # scope "/api", YebosterWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: YebosterWeb.Telemetry
    end
  end
end
