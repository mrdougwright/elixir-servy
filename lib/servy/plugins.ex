defmodule Servy.Plugins do
  alias Servy.Conv

  @doc "Logs 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :test do
      IO.puts "Warning: #{path} is on the loose!"
      Servy.FourOhFourCounter.bump_count(path)
    end
    conv # conversation map needs to keep flowing thru pipeline
  end

  def track(%Conv{} = conv), do: conv # default conv map

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    if Mix.env == :dev do
      IO.inspect conv
    end
    conv
  end
end
