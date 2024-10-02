$(document).ready(function () {
  const navToggle = $(".nav__toggle");
  const navWrapper = $(".nav__wrapper");

  // ナビゲーションメニューに 'active' クラスが付いているかを確認
  navToggle.on("click", function () {
    if (navWrapper.hasClass("active")) {
      // 'active' クラスがある場合の処理（メニューを閉じる）
      $(this).attr("aria-expanded", "false");
      $(this).attr("aria-label", "menu");
      navWrapper.removeClass("active");
    } else {
      // 'active' クラスがない場合の処理（メニューを開く）
      navWrapper.addClass("active");
      $(this).attr("aria-label", "close menu");
      $(this).attr("aria-expanded", "true");
    }
  });
});
