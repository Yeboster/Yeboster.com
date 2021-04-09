defmodule Yeboster.Knowledge do
  @moduledoc """
  Repository to interacts with multiple models
  """

  import Ecto.Query, warn: false
  alias Yeboster.Repo

  alias Yeboster.Knowledge.Category


  # TODO: What is the best way to manage these queries ?
  #       Create a module for each category ?
  #       Or put composable queries into Schema?

end
