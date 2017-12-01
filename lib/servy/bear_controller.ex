defmodule Servy.BearController do

  alias Servy.Bear
  alias Servy.Wildthings

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(fn(b) -> Bear.is_grizzly(b) end)
      |> Enum.sort(fn(b1, b2) -> Bear.order_asc_by_name(b1, b2) end)
      |> Enum.map(fn(b) -> bear_item(b) end)
      |> Enum.join

    %{ conv | resp_body: "<ul>#{items}</ul>" }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{ conv | resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>" }
  end

  def create(conv, %{"name" => name, "type" => type}) do
    response = "Created a #{type} bear named #{name}!"
    %{ conv | status: 201, resp_body: response }
  end

end
