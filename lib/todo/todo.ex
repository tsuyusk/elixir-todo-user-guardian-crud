defmodule Todo.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field(:done, :boolean, default: false)
    field(:title, :string)
    # field(:user_id, :id)
    belongs_to(:user, Todo.User)

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :done])
    |> validate_required([:title, :done])
    |> validate_length(:title, min: 4)
  end
end
