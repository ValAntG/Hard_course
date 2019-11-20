$(document).on("turbolinks:load", function () {
  $('a.edit-question-link').on('click ajax:success', toggleEditQuestionMode);
});

function toggleEditQuestionMode(e) {
  e.preventDefault();
  $('.edit-question-link').hide();
  $('.edit_question').show();
};