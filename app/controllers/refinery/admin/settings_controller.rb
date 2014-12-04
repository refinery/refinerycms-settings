module ::Refinery
  module Admin
    class SettingsController < ::Refinery::AdminController

      helper "refinery/admin/settings"

      crudify :'refinery/setting',
              :order => "name ASC",
              :redirect_to_url => :redirect_to_where?

      before_filter :sanitise_params, :only => [:create, :update]

      def new
        form_value_type = ((current_refinery_user.has_role?(:superuser) && params[:form_value_type]) || 'text_area')
        @setting = ::Refinery::Setting.new(:form_value_type => form_value_type)
      end

      def edit
        @setting = ::Refinery::Setting.find(params[:id])

        render :layout => false if request.xhr?
      end

    protected
      def find_all_settings
        @settings = ::Refinery::Setting.order('name ASC')

        unless current_refinery_user.has_role?(:superuser)
          @settings = @settings.where("restricted <> ? ", true)
        end

        @settings
      end

      def search_all_settings
        # search for settings that begin with keyword
        term = "^" + params[:search].to_s.downcase.gsub(' ', '_')

        # First find normal results, then weight them with the query.
         @settings = find_all_settings.with_query(term)
      end

    private
      def redirect_to_where?
        (from_dialog? && session[:return_to].present?) ? session[:return_to] : refinery.admin_settings_path
      end

      # this fires before an update or create to remove any attempts to pass sensitive arguments.
      def sanitise_params
        params.delete(:scoping)
      end

      def setting_params
        params.require(:setting).permit(:title, :name, :value, :destroyable,
                                          :scoping, :restricted, :form_value_type)
      end

    end
  end
end
