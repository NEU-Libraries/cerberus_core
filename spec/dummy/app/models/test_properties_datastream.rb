class TestPropertiesDatastream < DrsCore::Datastreams::PropertiesDatastream 
  use_terminology DrsCore::Datastreams::PropertiesDatastream 

  extend_terminology do |t| 
    t.test_attribute(path: 'test_attribute', namespace: 'dc')
  end
end