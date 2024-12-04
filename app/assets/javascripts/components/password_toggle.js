// パスワードの表示・非表示を管理
$(document).on("turbo:load ready", function () {
  $(".password-toggle").on("click", function () {
    const $passwordField = $("#floatingPassword");
    const $icon = $(this).find("i");

    if ($passwordField.attr("type") === "password") {
      $passwordField.attr("type", "text");
      $icon.removeClass("bi-eye").addClass("bi-eye-slash");
    } else {
      $passwordField.attr("type", "password");
      $icon.removeClass("bi-eye-slash").addClass("bi-eye");
    }
  });
});
