class TestPropertiesDatastream < DrsCore::Datastreams::PropertiesDatastream 
  use_terminology DrsCore::Datastreams::PropertiesDatastream 

  extend_terminology do |t| 
    t.test_attribute(path: 'testAttribute', namespace: 'dc')
  end

  def get_depositor 
    self.depositor.first
  end
end