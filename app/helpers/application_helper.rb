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

end
