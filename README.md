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

Curl localhost to see server response.

```shell
$ curl http://localhost:4000/sensors

# PID: #PID<0.199.0>: working on it!
# Received request:
#
# GET /sensors HTTP/1.1
# Host: localhost:4000
# User-Agent: curl/7.49.0
# Accept: */*
```
