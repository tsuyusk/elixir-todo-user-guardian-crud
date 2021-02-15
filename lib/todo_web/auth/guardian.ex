defmodule TodoWeb.Auth.Guardian do

 
















  use Guardian, otp_app: :todo
  alias Todo.{Repo,User}

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)

    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]

    resource = Repo.get!(User, id)

    {:ok, resource}
  end
end
