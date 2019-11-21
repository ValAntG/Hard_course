$(document).on("turbolinks:load", function () {
  $('a.edit-answer-link').on('click ajax:success', toggleEditAnswerMode);
});

function toggleEditAnswerMode(e) {
  e.preventDefault();
  $('.edit-answer-link').hide();
  var answerId = $(this).data('answerId');
  $('form#edit-answer-' + answerId).show();
};