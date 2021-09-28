defmodule TinyXml.MixProject do
  use Mix.Project

  def project do
    [
      app: :tiny_xml,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :xmerl]
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.10", only: :test},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false}
    ]
  end
end
