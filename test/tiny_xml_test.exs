defmodule TinyXmlTest do
  use ExUnit.Case, async: true

  import Test.Data, only: [dummy_xml: 0]

  doctest TinyXml

  test "should get xml node from xml string" do
    result = TinyXml.first(dummy_xml(), "//shiporder/orderperson")

    assert is_tuple(result)
  end

  test "should get xml node list from xml string" do
    result = TinyXml.all(dummy_xml(), "//shiporder/item")

    assert is_list(result)
    assert length(result) == 2
  end

  test "should get xml node value" do
    result =
      dummy_xml()
      |> TinyXml.first("//shiporder/shipto/country")
      |> TinyXml.text()

    assert result == "Norway"
  end
end
