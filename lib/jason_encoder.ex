alias Todo.{User, Todo}
















       
  
  

































defimpl Jason.Encoder, for: User do
  def encode(%{__struct__: _} = struct, options) do

    map =
      struct
      |> Map.from_struct()
      |> sanitize_map()

    Jason.Encoder.Map.encode(map, options)
  end

  def sanitize_map(map) do
    user_without_password = Map.drop(map, [:__meta__, :__struct__, :password])

    if (Map.get(user_without_password, :todos)) do
      user_todos_without_user = Enum.map(user_without_password.todos, fn todo ->
        Map.drop(todo, [:user])
      end)

      Map.replace(user_without_password, :todos, user_todos_without_user)

      else
        user_without_password
    end
  end
end

defimpl Jason.Encoder, for: Todo do
  def encode(%{__struct__: _} = struct, options) do

    map =
      struct
      |> Map.from_struct()
      |> sanitize_map()

    Jason.Encoder.Map.encode(map, options)
  end

  def sanitize_map(map) do
    sanitized_todo = Map.drop(map, [:__meta__, :__struct__])

    if (Map.get(sanitized_todo, :user)) do
      sanitized_todo_user = Map.drop(sanitized_todo.user, [:todos, :__meta__, :__struct__])

      Map.replace(sanitized_todo, :user, sanitized_todo_user)
      else
        sanitized_todo
    end
  end
end
