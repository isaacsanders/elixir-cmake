defmodule ElixirCmake.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_cmake,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      source_url: "https://github.com/code-lever/elixir-cmake",
      homepage_url: "https://github.com/code-lever/elixir-cmake",
      description: description(),
      docs: [main: "README", extras: ["README.md"]],
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    A CMake compiler to help building Ports/NIFs in your Elixir/mix project.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      maintainers: ["Nick Veys"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/code-lever/elixir-cmake"
      }
    ]
  end
end
