defmodule Xray.MixProject do
  use Mix.Project

  @version "1.2.0"

  def project do
    [
      app: :xray,
      name: "Xray",
      description: "Offers utility functions for inspecting string binaries and code points",
      source_url: "https://github.com/fireproofsocks/xray",
      version: @version,
      elixir: "~> 1.8",
      deps: deps(),
      package: package(),
      docs: [
        main: "readme",
        source_ref: "v#{@version}",
        logo: "logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  defp package do
    [
      maintainers: ["Everett Griffiths"],
      licenses: ["Apache-2.0"],
      logo: "logo.png",
      links: links(),
      files: [
        "lib",
        "logo.png",
        "mix.exs",
        "README*",
        "CHANGELOG*",
        "LICENSE*"
      ]
    ]
  end

  def links do
    %{
      "GitHub" => "https://github.com/fireproofsocks/xray",
      "Readme" => "https://github.com/fireproofsocks/xray/blob/v#{@version}/README.md",
      "Changelog" => "https://github.com/fireproofsocks/xray/blob/v#{@version}/CHANGELOG.md"
    }
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:base2, "~> 0.1.0"},
      {:ex_unicode, "~> 1.12.0"},
      {:ex_doc, "~> 0.28.3", runtime: false}
    ]
  end
end
