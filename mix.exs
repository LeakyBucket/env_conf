defmodule EnvConf.Mixfile do
  use Mix.Project

  def project do
    [app: :env_conf,
      version: "0.1.0",
      elixir: "~> 0.14.3",
      description: description,
      package: package,
      deps: deps(Mix.env)]
  end

  # Configuration for the OTP application
  def application do
    [mod: { EnvConf, [] }]
  end

  defp description do
    """
      A simple 12-Factor configuration service for Elixir.
    """
  end

  defp package do
    [ files: ["lib", "docs", "test", "mix.exs", "README.*", "LICENSE"],
      contributors: ["Glen Holcomb"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/leakybucket/env_conf.git"}]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps(_env) do
    [
      {:ex_doc, github: "elixir-lang/ex_doc"}
    ]
  end
end
