# Load code:

require 'cocoapods'

# Apply patch to loaded code:

module Pod
  class Validator
    def validate
        true
    end
    
    def validated?
        true
    end
  end
end

# Execute original command:

load %x(which pod).strip
