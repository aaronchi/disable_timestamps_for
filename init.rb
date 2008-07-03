require 'disable_timestamps_for'
ActiveRecord::Base.class_eval { include DisableTimestampsFor }
