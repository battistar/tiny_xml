defmodule SchemaTest do
  use ExUnit.Case, async: true

  @dummy_data_path "test/data/dummy_data.xml"
  @schema_path "test/data/dummy_schema.xsd"

  setup_all do
    dummy_xml = File.read!(@dummy_data_path)

    {:ok, dummy_xml: dummy_xml}
  end

  test "xml should be valid", %{dummy_xml: dummy_xml} do
    assert :ok = TinyXml.Schema.validate(dummy_xml, @schema_path)
  end

  test "xml should be invalid", %{dummy_xml: dummy_xml} do
    invalid_xml = String.replace(dummy_xml, "orderperson", "person")

    assert {:error, _} = TinyXml.Schema.validate(invalid_xml, @schema_path)
  end
end
