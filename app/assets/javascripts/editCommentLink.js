$(document).on("turbolinks:load", function () {
  $('a.edit-comment-link').on('click ajax:success', toggleEditCommentMode);
});

function toggleEditCommentMode(e) {
  e.preventDefault();
  $('.edit-comment-link').hide();
  var commentId = $(this).data('commentId');
  $('form#edit-comment-' + commentId).show();
};
