defmodule TodoWeb.UserController do

 






































































































  use TodoWeb, :controller
  alias Todo.{Repo,User}

  def create(conn, %{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil ->
        changeset = User.changeset(%User{}, %{"email" => email, "password" => password})

        case Repo.insert(changeset) do
          {:ok, user} ->
            user = Repo.preload(user, :todos)

            json(conn, user)

          {:error, reason = %Ecto.Changeset{}} ->
            errors =
              Ecto.Changeset.traverse_errors(reason, fn {raw_message, message_parameters} ->
                Enum.reduce(message_parameters, raw_message, fn {key, value}, accumulator ->
                  String.replace(accumulator, "%{#{key}}", to_string(value))
                end)
              end)

            json(conn, %{"errors" => errors})

          {:error, _} ->
            json(conn, %{error: "Error while creating user"})
        end

      _ = %User{} ->
        json(conn, %{error: "E-mail already taken"})

      _ ->
        json(conn, %{error: "Unknown error"})
    end

  end
end
