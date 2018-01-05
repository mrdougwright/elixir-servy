# Fetcher not used. Modeled after Elixir Task module.
defmodule Servy.Fetcher do

  def async(spawn_fun) do # Task.async
    parent = self()
    spawn(fn -> send(parent, {self(), :result, spawn_fun.()}) end)
  end

  def get_result(pid) do # Task.await
    receive do
      {^pid, :result, value} -> value
    after 2000 -> # optional timeout clause
      raise "Timed out!"
    end
  end
end
