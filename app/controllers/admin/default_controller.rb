class Admin::DefaultController < ApplicationController
  require_privilege Privilege::ACCESS_ADMIN_MODULE
  layout 'admin/default'
end
