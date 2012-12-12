# encoding: UTF-8

def get_test_xml path
  Nokogiri::XML::Document.parse(File.read(path), nil, "UTF-8").xpath("//ValuteCursOnDate")
end