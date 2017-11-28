defmodule Servy.FileHandler do

  @doc "Handle file content"
  def handle_file({:ok, content}, conv) do
    %{ conv | resp_body: content }
  end

  def handle_file({:error, :enoent}, conv) do
    %{ conv | status: 404, resp_body: "File not found!" }
  end

  def handle_file({:error, reason}, conv) do
    %{ conv | status: 500, resp_body: "File error: #{reason}" }
  end
end
