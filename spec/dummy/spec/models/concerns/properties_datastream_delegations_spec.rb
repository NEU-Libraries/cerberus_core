require 'spec_helper'

RSpec.shared_examples "A Properties Delegator" do 
  let(:delegator) { described_class.new } 

  it "forwards the expected methods" do 
    methods = [:in_progress?, :tag_as_in_progress, :tag_as_completed, 
               :canonize, :uncanonize, :canonical?]

    expect(methods.all? { |x| delegator.respond_to? x }).to be true 
  end
end
