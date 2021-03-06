defmodule Servy.Mixfile do
  use Mix.Project

  def project do
    [
      app: :servy,
      description: "A humble HTTP server",
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Servy, []}, # callback mod: any `use Application` behavior
      env: [port: 4020]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:poison, "~> 3.1"}, # json encoder from http://hex.pm
      {:httpoison, "~> 1.0"} # http client for elixir
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
