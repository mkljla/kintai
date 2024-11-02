module ApplicationHelper

  # フラッシュメッセージを処理し、適切なCSSクラスを持つHTMLのdivタグでラップするメソッド
  def display_flash_messages
    # フラッシュメッセージを格納する配列を初期化
    flash_messages = flash.map do |key, message|
      # フラッシュのキーに応じてBootstrapのアラートクラスを割り当てる
      css_class = {
        notice: 'alert-success',  # 通知メッセージには成功のスタイルを適用
        alert: 'alert-danger'     # 警告メッセージにはエラースタイルを適用
      }.fetch(key.to_sym, 'alert-info')  # デフォルトは'alert-info'（情報メッセージ）

      # メッセージを適切なクラスを持つdivタグでラップ
      content_tag(:div, message, class: "alert #{css_class} flash_window")
    end

    # 全てのフラッシュメッセージのdivを結合し、HTMLとして返す
    safe_join(flash_messages)
  end

  def formatted_date_with_weekday(datetime)
    "#{datetime.strftime('%Y/%m/%d')}(#{I18n.t('date.abbr_day_names')[datetime.wday]})"
  end

  def formatted_time_only(datetime)
    Time.at((datetime).to_i).in_time_zone('Tokyo').strftime("%H:%M")
  end

  # 前月と前月の年を返すメソッド
  def previous_month_and_year(current_month, current_year)
    if current_month == 1
      [12, current_year - 1]
    else
      [current_month - 1, current_year]
    end
  end

  # 翌月と翌月の年を返すメソッド
  def next_month_and_year(current_month, current_year)
    if current_month == 12
      [1, current_year + 1]
    else
      [current_month + 1, current_year]
    end
  end
end
