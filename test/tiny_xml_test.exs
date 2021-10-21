defmodule TinyXmlTest do
  use ExUnit.Case, async: true

  @data_path "test/data/dummy_data.xml"

  doctest TinyXml

  setup_all do
    dummy_xml = File.read!(@data_path)

    {:ok, dummy_xml: dummy_xml}
  end

  test "should get xml node from xml string", %{dummy_xml: dummy_xml} do
    result = TinyXml.first(dummy_xml, "/shiporder/orderperson")

    assert is_tuple(result)
  end

  test "should get xml node list from xml string", %{dummy_xml: dummy_xml} do
    result = TinyXml.all(dummy_xml, "/shiporder/item")

    assert is_list(result)
    assert length(result) == 2
  end

  test "should get xml node value", %{dummy_xml: dummy_xml} do
    result =
      dummy_xml
      |> TinyXml.first("/shiporder/shipto/country")
      |> TinyXml.text()

    assert result == "Norway"
  end

  test "should get xml node attribute", %{dummy_xml: dummy_xml} do
    result =
      dummy_xml
      |> TinyXml.first("/shiporder")
      |> TinyXml.attribute("orderid")

    assert result == "889923"
  end
end
