# rubocop:disable Metrics/BlockLength
class StatisticApi < ApiV1
  namespace :statistic do
    before do
      authenticated
    end

    desc "Get day off statistic"
    params do
      requires :year, type: Integer, message: I18n.t("errors.required")
      optional :month, type: Integer
    end
    get "/day_off" do
      awol = if params[:month]
               current_user.day_offs.filter_time(params[:year], params[:month])[0].awol
             else
               current_user.day_offs.filter_year(params[:year]).sum_awol
             end
      leave = if params[:month]
                current_user.day_offs.filter_time(params[:year], params[:month])[0].awol
              else
                current_user.day_offs.filter_year(params[:year]).sum_awol
              end
      render_success_response(:ok, DayOffFormat, {awol: awol, leave: leave}, I18n.t("success.common"))
    end

    desc "Get request statistic"
    params do
      requires :year, type: Integer, message: I18n.t("errors.required")
      optional :month, type: Integer
    end
    get "/requests" do
      approved = Request.filter_status(current_user.id, Settings.approved_status_id).count
      rejected = Request.filter_status(current_user.id, Settings.rejected_status_id).count

      render_success_response(:ok,
                              RequestStatisticFormat,
                              {approved: approved, rejected: rejected},
                              I18n.t("success.common"))
    end

    desc "Get all statistic"
    params do
      requires :year, type: Integer, message: I18n.t("errors.required")
      optional :month, type: Integer
    end
    get "/all" do
      error! I18n.t("errors.not_allowed"), :forbidden unless authorized_one_of %w(Manager)
      results = []
      unit_members = User.get_unit current_user.unit_id
      unit_members.each do |member|
        approved = Request.filter_status(member.id, Settings.approved_status_id).count
        rejected = Request.filter_status(member.id, Settings.rejected_status_id).count
        awol = if params[:month]
                          member.day_offs.filter_time(params[:year], params[:month])[0].awol
                        else
                          member.day_offs.filter_year(params[:year]).sum_awol
                        end
        leave = if params[:month]
                           member.day_offs.filter_time(params[:year], params[:month])[0].awol
                         else
                           member.day_offs.filter_year(params[:year]).sum_awol
                         end
        result = {
          id: member.id,
          email: member.email,
          name: member.name,
          awol: awol,
          leave: leave,
          approved: approved,
          rejected: rejected
        }
        results << result
      end
      render_success_response(:ok, StatisticFormat, results, I18n.t("success.common"))
    end
  end
end
# rubocop:enable Metrics/BlockLength
