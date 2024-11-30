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

  # 分を「時間:分」形式に変換するメソッド
  def minutes_to_hours_and_minutes(total_minutes)
    hours = total_minutes / 60
    minutes = total_minutes % 60
    format("%d時間%02d分", hours, minutes)
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

  def sort_icon(column)
    if @sort_column == column.to_s
      if @sort_direction == 'asc'
        content_tag(:i, '', class: 'fas fa-sort-up ')
      else
        content_tag(:i, '', class: 'fas fa-sort-down')
      end
    else
      # 並べ替えの列が設定されていない場合はデフォルトのアイコンを表示
      content_tag(:i, '', class: 'fa-solid fa-sort')
    end
  end
  # 管理者モードの状態をチェックするメソッド
  def admin_mode_active?
    session[:admin_mode] == true
  end

end
