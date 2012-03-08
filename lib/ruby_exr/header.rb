

module RubyEXR
	class Header
		# initialize ourself with an optional file stream
		def initialize(stream=nil)
			@header = Hash.new
			if stream
				read stream
			end
		end
		
		# Interface
		def attribute(name)
			attribute_info name[1]
		end
		
		# Returns a list of [attr_type_name, data] for the given attribute name
		# Nil is returned if the attribute doesn't exist in the header.
		def attribute_info(name)
			@header[name]
		end
		
		def attributes
			@header.keys
		end
		
		# end interface
		
		
	end # class header
end # end module ruby_exr
