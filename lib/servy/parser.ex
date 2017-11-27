defmodule Servy.Parser do
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
end
