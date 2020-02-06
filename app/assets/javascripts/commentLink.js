$(document).on("turbolinks:load", function () {
  $('a.edit-comment-link').on('click ajax:success', toggleEditCommentMode);
  App.cable.subscriptions.create({channel: 'CommentsChannel', question_id: gon.question_id},
    {
      received(data) {
        console.log(data)
        if (data.action == 'create') { CommentCreate(data) };
      }
    });
});

function CommentCreate(data) {

  newComment(data);
  formComment(data.comment);
  if (data.comment.user_id == gon.user_id) { buttonСomment(data.comment) };
};

function newComment(data) {
  var commentableForm = $(".comments.commentsFor" + data.commentable_type + '#commentCommentableId-' + data.commentable_id)
  commentableForm.append('<div class="form-horizontal" id="commentShow-' + data.comment.id + '">');
};

function formComment(comment) {
  $('#commentShow-' + comment.id).append('<div class="form-group"></div>');
  $('#commentShow-' + comment.id).find('.form-group').append('<div class="col-sm-3"></div>');
  var lableComment = $('<label>').attr({
    class: "form-control control-label label-warning",
  }).text('Комментарий:');
  $('#commentShow-' + comment.id).find('.form-group').find('.col-sm-3').append(lableComment)
  $('#commentShow-' + comment.id).find('.form-group').append('<div class="col-sm-9"></div>');
  var lableCommentBody = $('<label>').attr({
    class: "form-control",
    id: "comment_body_" + comment.id
  }).text(comment.body);
  $('#commentShow-' + comment.id).find('.form-group').find('.col-sm-9').append(lableCommentBody);
};

function buttonСomment(comment) {
  $('#answerShow-' + comment.id).append('<div class="form-group"></div>');

  var buttonEdit = $('<a>').attr({
    class: "btn btn-info form-control edit-comment-link",
    "data-comment-id": comment.id,
  }).text('Edit comment');
  $('#commentShow-' + comment.id).find('.form-group').last().append(buttonEdit)

  var buttonDelete = $('<a>').attr({
    "data-confirm": "Вы действительно хотите удалить?",
    class: "btn btn-danger form-control edit-comment-link",
    rel: "nofollow",
    "data-method": "delete",
    href: "/comments/" + comment.id,
  }).text('Delete comment');
  $('#commentShow-' + comment.id).find('.form-group').last().append(buttonDelete)
};

function toggleEditCommentMode(e) {
  e.preventDefault();
  var commentId = $(this).data('commentId');
  $('.form-horizontal#commentShow-' + commentId).hide();
  $('form#commentEdit-' + commentId).show();
};
