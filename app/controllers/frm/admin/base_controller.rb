module Frm
  module Admin
    class BaseController < ApplicationController

      layout 'groups'

      before_filter :load_group
      before_filter :authenticate_forem_admin

      def index
        # TODO: perhaps gather some stats here to show on the admin page?
      end

      private

      def authenticate_forem_admin
        if !current_user || !current_user.forem_admin?
          flash.alert = t("frm.errors.access_denied")
          redirect_to group_forums_url(@group)
        end
      end
    end
  end
end