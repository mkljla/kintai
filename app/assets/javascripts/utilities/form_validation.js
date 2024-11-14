$(document).ready(function () {
  "use strict";

  // Select all forms with .needs-validation class
  const forms = $(".needs-validation");

  forms.each(function () {
    const form = $(this);
    form.on("submit", function (event) {
      if (!this.checkValidity()) {
        // Prevent form submission if invalid
        event.preventDefault();
        event.stopPropagation();
      }
      // Add Bootstrap validation classes
      form.addClass("was-validated");
    });
  });
});
