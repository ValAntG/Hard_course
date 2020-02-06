$(document).on("turbolinks:load", function () {
  $('a.edit-answer-link').on('click ajax:success', toggleEditAnswerMode);
  App.cable.subscriptions.create({channel: 'AnswersChannel', question_id: gon.question_id},
    {
      received(data) {
        if (data.action == 'create') { AnswerCreate(data.answer) };
      }
    });
});

function AnswerCreate(answer) {
  newAnswer(answer);
  if (answer.attachments.length != 0) { formAttachment(answer) };
  if (answer.user_id == gon.user_id) { buttonAnswer(answer) };
};

function toggleEditAnswerMode(e) {
  e.preventDefault();
  var answerId = $(this).data('answerId');
  $('.form-horizontal#answerShow-' + answerId).hide();
  $('form#answerEdit-' + answerId).show();
};

function newAnswer(answer) {
  $('.answers-index-form').add('.commentableObject-Answer')
  $('.answers-index-form').append('<div class="form-horizontal" id="answerShow-' + answer.id + '">');
  formAnswer(answer)
};

function formAnswer(answer) {
  $('#answerShow-' + answer.id).append('<div class="form-group"></div>');
  $('#answerShow-' + answer.id).find('.form-group').append('<div class="col-sm-3"></div>');
  const lableAnswer = $('<label>').attr({
    class: "form-control control-label label-warning",
  }).text('Ответ:');
  $('#answerShow-' + answer.id).find('.form-group').find('.col-sm-3').append(lableAnswer)
  $('#answerShow-' + answer.id).find('.form-group').append('<div class="col-sm-9"></div>');
  var lableAnswerBody = $('<label>').attr({
    class: "form-control",
    id: "answer_body_" + answer.id
  }).text(answer.body);
  $('#answerShow-' + answer.id).find('.form-group').find('.col-sm-9').append(lableAnswerBody);
};

function formAttachment(answer) {
  $('#answerShow-' + answer.id).append('<div class="form-group"></div>');
  $('#answerShow-' + answer.id).find('.form-group').last().append('<div class="col-sm-3"></div>');
  const lableAttachments = $('<label>').attr({
    class: "form-control control-label label-warning",
  }).text('Attachments:');
  $('#answerShow-' + answer.id).find('.form-group').last().find('.col-sm-3').append(lableAttachments)

  $.each(answer.attachments,function(index,attachment){
    var lableAttachmentFiles = $('<a>').attr({
      href: attachment.file.url
    }).text(attachment.file.url.split('/').pop());
    $('#answerShow-' + answer.id).find('.form-group').last().append('<div class="col-sm-9 attachment"></div>');
    $('#answerShow-' + answer.id).find('.form-group').last().find('.col-sm-9.attachment').append(lableAttachmentFiles);
  });
};

function buttonAnswer(answer) {
  $('#answerShow-' + answer.id).append('<div class="form-group"></div>');

  var buttonEdit = $('<a>').attr({
    class: "btn btn-info form-control edit-answer-link",
    "data-answer-id": answer.id,
  }).text('Edit answer');
  $('#answerShow-' + answer.id).find('.form-group').last().append(buttonEdit)

  var buttonDelete = $('<a>').attr({
    "data-confirm": "Вы действительно хотите удалить?",
    class: "btn btn-danger form-control edit-answer-link",
    rel: "nofollow",
    "data-method": "delete",
    href: "/answers/" + answer.id,
  }).text('Delete answer');
  $('#answerShow-' + answer.id).find('.form-group').last().append(buttonDelete)
};

function commentForCommentable(answer) {

};
