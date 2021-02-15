defmodule TodoWeb.SessionController do
 
 



































































































































   use TodoWeb,:controller
  alias Todo.{Repo,User}

  def create(conn, %{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email, password: password) do
      user = %User{} ->
        user = Map.drop(user, [:todos])
        {:ok, token, _claims} = Guardian.encode_and_sign(TodoWeb.Auth.Guardian, user)
        json(conn, %{"user" => user, "token" => token})

        _ ->
          json(conn, %{"error" => "Invalid Email/Password credentials"})
    end
  end

  def delete(conn, _params) do
    token =
      get_req_header(conn, "authorization")
      |> Enum.at(0)
      |> String.split("Bearer ")
      |> Enum.at(1)

    Guardian.revoke(TodoWeb.Auth.Guardian, token)

    json(conn, %{"ok" => true})
  end
end
