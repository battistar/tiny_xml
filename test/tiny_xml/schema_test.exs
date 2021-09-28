defmodule SchemaTest do
  use ExUnit.Case, async: true

  import Test.Data, only: [dummy_xml: 0]

  @schema_path "test/tiny_xml/dummy_schema.xsd"

  test "xml should be valid" do
    assert :ok = TinyXml.Schema.validate(dummy_xml(), @schema_path)
  end

  test "xml should be invalid" do
    invalid_xml = String.replace(dummy_xml(), "orderperson", "person")

    assert {:error, _} = TinyXml.Schema.validate(invalid_xml, @schema_path)
  end
end
