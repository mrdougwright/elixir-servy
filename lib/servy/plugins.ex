defmodule Servy.Plugins do
  @doc "Logs 404 requests"
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
end
