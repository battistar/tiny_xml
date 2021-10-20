defmodule SchemaTest do
  use ExUnit.Case, async: true

  @data_path "test/data/dummy_data.xml"
  @schema_path "test/data/dummy_schema.xsd"

  setup_all do
    dummy_xml = File.read!(@data_path)

    {:ok, dummy_xml: dummy_xml}
  end

  test "xml string should be valid", %{dummy_xml: dummy_xml} do
    assert :ok = TinyXml.Schema.validate_string(dummy_xml, @schema_path)
  end

  test "xml string should be invalid", %{dummy_xml: dummy_xml} do
    invalid_xml = String.replace(dummy_xml, "orderperson", "person")

    assert {:error, _} = TinyXml.Schema.validate_string(invalid_xml, @schema_path)
  end

  test "xml file should be valid" do
    assert :ok = TinyXml.Schema.validate_file(@data_path, @schema_path)
  end

  test "xml file should not exists" do
    assert {:error, _} = TinyXml.Schema.validate_file("invalid/data/path", @schema_path)
  end
end
