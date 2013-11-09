actions :run
attribute :job_name, :kind_of => String, :name_attribute => true, :required => true
attribute :nodes, :kind_of => Array, :required => true
attribute :require_success, :kind_of => [FalseClass, TrueClass], :default => false
