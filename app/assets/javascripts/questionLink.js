$(document).on('turbolinks:load', function () {
  $('a.edit-question-link').on('click ajax:success', toggleEditQuestionMode);
  $('a.edit-question-link').on('click ajax:error', toggleErrorQuestionMode);
  $('a.answer-question-link').on('click ajax:success', toggleNewAnswerForQuestionMode);
  $('a.comment-link').on('click ajax:success', toggleNewCommentMode);
  App.cable.subscriptions.create({ channel: 'QuestionsChannel' },
    {
      received(data) {
        $('.col-lg-9').append(data);
      }
    });

  if ($('.question-show-form').length > 0) {
    $('.edit_question').hide();
  }
});

function toggleEditQuestionMode(e) {
  e.preventDefault();
  $('.question-show-button').hide();
  $('.edit_question').show();
};

function toggleErrorQuestionMode(e) {
  e.preventDefault();
  $('.question-errors').append();
};

function toggleNewAnswerForQuestionMode(e) {
  e.preventDefault();
  $('.new_answer').toggle();
};

function toggleNewCommentMode(e) {
  e.preventDefault();
  $('.new_comment').toggle();
};
