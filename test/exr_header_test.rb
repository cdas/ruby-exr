require File.join(File.dirname(__FILE__), 'base')


class TestExrHeader < TestBase
	
	def test_initialization
		h = RubyEXR::Header.new
		
		# verify an empty, uninitialized instance throws proper exceptions
		assert(h.attribute_info(:nonexisting) == nil, "should get nil for nonexisting attr")
		assert(h.attributes.size == 0, "should have no attributes yet")
	end
	
	def test_channel
		c = RubyEXR::Channel.new
		assert ! c != c
		
		assert c.compatible? c
		assert c.to_s == "Channel(, HALF, 1, 1, false)"
		assert c == RubyEXR::Channel.new
		
		#Layer examples
		[['layer', 'layer', ''],
		 ['lay.g', 'lay',   'g'],
		 ['m.l.b', 'm.l',   'b'],
		 ['.r',    '',      'r'],
		 [''     , ''   ,   '' ]].each do |name, layer, suffix|
		 	 c = RubyEXR::Channel.new(name)
		 	 assert c.layer == layer
		 	 assert c.suffix == suffix
		 end
		 
	 end # test_channel
	
end #
