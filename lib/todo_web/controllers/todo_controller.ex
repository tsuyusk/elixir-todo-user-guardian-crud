defmodule TodoWeb.TodoController do







     
  
  



































































  use TodoWeb, :controller
  alias Todo.{Repo}

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:todos)

    user_todos = Enum.map(user.todos, fn todo ->
      Map.drop(todo, [:user])
    end)

    json(conn, user_todos)
  end

  def create(conn, %{"title" => title}) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:todos)
    changeset = Todo.Todo.changeset(%Todo.Todo{ user_id: user.id }, %{title: title})

    case Repo.insert(changeset) do
      {:ok, todo} ->
        todo = Repo.preload(todo, :user)

        json(conn, todo)

      {:error, reason = %Ecto.Changeset{}} ->
        errors =
          Ecto.Changeset.traverse_errors(reason, fn {raw_message, message_parameters} ->
            # Example of raw_message -> "should be at least %{count} character(s)"
            # Example of message_parameters -> [count: 4, validation: :length, kind: :min, type: :string]
            Enum.reduce(message_parameters, raw_message, fn {key, value}, accumulator ->
              # Therefore, this line will replace %{count} for '4', and so on
              String.replace(accumulator, "%{#{key}}", to_string(value))
            end)
          end)

        json(conn, %{"errors" => errors})

      {:error, _} ->
        json(conn, %{"error" => "An unexpected error occoured"})
    end
  end

  def update_done_status(conn, %{"todo_id" => todo_id}) do
    user =
      Guardian.Plug.current_resource(conn)
      |> Map.drop([:todos])

    case Repo.get(Todo.Todo, todo_id) do
      todo = %Todo.Todo{} ->
        if (todo.user_id == user.id) do
          updated_todo = Todo.Todo.changeset(todo, %{"done" => !todo.done})

          case Repo.update(updated_todo) do
            {:ok, updated_struct} ->
              updated_struct = Map.drop(updated_struct, [:user])

              json(conn, updated_struct)
            {:error, _} ->
              conn
              |> put_status(400)
              |> json(%{"error" => "An unexpected error occoured"})
          end


          else
            conn
            |> put_status(400)
            |> json(%{"error" => "This Todo does not belong to you"})
        end

      _ ->
        conn
        |> put_status(400)
        |> json(%{"error" => "Invalid Todo Id"})
    end
  end
end
