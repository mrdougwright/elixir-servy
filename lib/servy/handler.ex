defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."
  alias Servy.Conv

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.Parser,      only: [parse: 1]
  import Servy.Plugins,     only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.FileHandler, only: [handle_file: 2]

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def route(%Conv{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | resp_body: "Wild things path" }
  end

  def route(%Conv{ method: "GET", path: "/family" } = conv) do
    # creates a new map that also has response body:
    %{ conv | resp_body: "Jane, Oliver, Elly, Terry, Anne" }
  end

  def route(%Conv{ method: "GET", path: "/family/" <> id } = conv) do
    %{ conv | resp_body: "Family member number: #{id}" }
  end

  def route(%Conv{ method: "GET", path: "/dogs" } = conv) do
    %{ conv | resp_body: "Oliver" }
  end

  def route(%Conv{ method: "POST", path: "/bears" } = conv) do
    %{ conv | status: 201,
              resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!" }
  end

  def route(%{ method: "GET", path: "/about" } = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /family HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /family/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response



request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts response
