class SearchesController < ApplicationController
  skip_before_action :verify_authenticity_token

  SESSION_TIMEOUT = 5.minutes

  def create
    query_text = I18n.transliterate(params[:query].to_s)
                      .downcase
                      .gsub(/[[:punct:]]/, "")
                      .strip
                      .squeeze(" ")

    return head :ok if query_text.blank?

    user_ip = request.remote_ip
    last_search = Search.where(user_ip: user_ip)
                        .where("last_seen_at > ?", SESSION_TIMEOUT.ago)
                        .order(last_seen_at: :desc)
                        .first

    if last_search && query_text.start_with?(last_search.query) && query_text != last_search.query
      last_search.update!(query: query_text, last_seen_at: Time.current)
    else
      Search.create!(query: query_text, user_ip: user_ip, last_seen_at: Time.current)
    end

    head :ok
  end
end
