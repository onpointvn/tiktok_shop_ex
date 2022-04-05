defmodule TiktokShop.MixProject do
  use Mix.Project

  def project do
    [
      app: :tiktok_shop,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:contrak, "~> 0.1"},
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17", optional: true},
      {:castore, "~> 0.1"},
      {:jason, ">= 1.0.0"}
    ]
  end
end
