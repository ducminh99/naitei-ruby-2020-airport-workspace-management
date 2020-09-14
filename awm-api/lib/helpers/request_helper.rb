module RequestHelper
  include AuthHelper

  def valid_user request_id
    request = valid_request request_id
    return true if request.requester_id == current_user.id

    error!(I18n.t("errors.invalid_user"), :bad_request)
  end

  def valid_manager request_id
    request = valid_request request_id
    current_user.position_id == Settings.admin_id && current_user.unit_id == request.unit_id
  end

  def valid_request request_id
    request = Request.find_by id: request_id
    error!(I18n.t("errors.request_id_not_found"), :bad_request) unless request
    request
  end

  def update_day_off requester_id, year, month
    requester = User.find_by id: requester_id
    day_off = requester.day_offs.filter_time(year, month)[0]
    day_off.update!(
      awol: day_off.awol + 1
    )
  end
end
