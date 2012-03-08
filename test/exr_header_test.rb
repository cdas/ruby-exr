require File.join(File.dirname(__FILE__), 'base')


class TestExrHeader < TestBase
	
	def test_initialization
		h = RubyEXR::Header.new
		
		# verify an empty, uninitialized instance throws proper exceptions
		assert(h.attribute_info(:nonexisting) == nil, "should get nil for nonexisting attr")
		assert(h.attributes.size == 0, "should have no attributes yet")
	end
	
end #
