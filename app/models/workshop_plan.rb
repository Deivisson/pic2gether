class WorkshopPlan < ActiveRecord::Base
	has_many :workshops
	has_many :orders
	scope :active, -> {where(active:true)}

	after_find :write_settings_methods

	define_method "teste" do
		return 0
	end

	def description
		I18n.t("user.#{self.i18n_key}")
	end

private 
	def write_settings_methods
		settings = JSON.parse(self.settings)
		settings.each do |setting|
			method_name  =  setting["key"]
			method_name +=  setting["type"]== "boolean" ? "?" : ""
	 	
			WorkshopPlan.class_eval do
			 	define_method :"#{method_name}" do
					if setting["type"]== "boolean"
						setting["value"] == "1" ? true : false
					elsif setting["type"] == "integer"
						setting["value"].to_i
					else
						setting["value"]
					end			 		
	   		end
   		end
   		
		end
	end		
end
