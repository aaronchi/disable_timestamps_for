module DisableTimestampsFor
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		
		def disable_timestamps_for(attributes)
			attributes = Array(attributes).map{|a| a.to_s}
			class_eval do
				cattr_accessor :timestamps_disabled_for
				self.timestamps_disabled_for = attributes.sort
				
				include DisableTimestampsFor::InstanceMethods
				
				before_save :disable_timestamps
				after_save  :enable_timestamps
			end
		end
		
	end
	
	module InstanceMethods
				
		private
		
			def disable_timestamps
				if !self.new_record? && !self.changed.empty? && (self.changed+self.class.timestamps_disabled_for).uniq.sort == self.class.timestamps_disabled_for
					class << self
						def record_timestamps; false; end
					end
				end
			end

			def enable_timestamps
				unless self.record_timestamps
					class << self
						def record_timestamps; true; end
					end
				end
			end

	end
end
