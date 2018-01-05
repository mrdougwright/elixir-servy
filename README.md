# Servy

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `servy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:servy, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/servy](https://hexdocs.pm/servy).

## To Run

From command line within Servy directory, enter an iex shell.
Call HttpServer start function with any port:

```elixir
$ iex -S mix
> Servy.HttpServer.start(4000)
```

Or spawn the process within iex:

```elixir
  spawn(Servy.HttpServer, :start, [4000])
```
