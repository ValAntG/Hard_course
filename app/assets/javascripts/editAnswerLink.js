$(document).on("turbolinks:load", function () {
  $('.edit-answer-link').on('click ajax:success', function (e) {
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();
  });
});
