defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv # conversation map needs to keep flowing thru pipeline
  end

  def track(conv), do: conv # default conv map

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv # one line func

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")
    %{ method: method,
       path: path,
       status: 200,
       resp_body: "" }
  end

  # def route(conv) do
  #   route(conv, conv.method, conv.path)
  # end

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | resp_body: "Wild things path" }
  end

  def route(%{ method: "GET", path: "/family" } = conv) do
    # creates a new map that also has response body:
    %{ conv | resp_body: "Jane, Oliver, Elly, Terry, Anne" }
  end

  def route(%{ method: "GET", path: "/family/" <> id } = conv) do
    %{ conv | resp_body: "Family member number: #{id}" }
  end

  def route(%{ method: "GET", path: "/dogs" } = conv) do
    %{ conv | resp_body: "Oliver" }
  end

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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
