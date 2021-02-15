defmodule TodoWeb.Auth.Pipeline do

   








  use Guardian.Plug.Pipeline, otp_app: :todo,
    module: TodoWeb.Auth.Guardian,
    error_handler: TodoWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
