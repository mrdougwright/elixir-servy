defmodule Servy.BearController do

  alias Servy.Bear
  alias Servy.Wildthings
  import Servy.View, only: [render: 3]

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2) # shorthand

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type}) do
    response = "Created a #{type} bear named #{name}!"
    %{ conv | status: 201, resp_body: response }
  end

end
