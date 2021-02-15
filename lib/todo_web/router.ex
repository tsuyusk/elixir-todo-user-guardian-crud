defmodule TodoWeb.Router do
  use TodoWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :auth do
    plug(TodoWeb.Auth.Pipeline)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TodoWeb do
    pipe_through([:api])

    resources("/users", UserController)

    post("/sessions", SessionController, :create)
  end

  scope "/", TodoWeb do
    pipe_through([:api, :auth])

    get("/todos", TodoController, :index)
    post("/todos", TodoController, :create)
    patch("/todos/:todo_id/set_done", TodoController, :update_done_status)
    delete("/sessions", SessionController, :delete)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TodoWeb do
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
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: TodoWeb.Telemetry)
    end
  end
end
