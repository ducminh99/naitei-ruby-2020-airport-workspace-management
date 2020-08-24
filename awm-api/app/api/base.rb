class Base < Grape::API
  helpers LocaleHelper
  helpers AuthHelper
  helpers ResponseHelper
  helpers PasswordResetHelper
  helpers UserHelper
  helpers RequestHelper

  before do
    set_locale
  end

  mount ApiV1
end
