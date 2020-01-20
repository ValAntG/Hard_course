$(document).on("turbolinks:load", function () {
  $('form.new_comment')
  .bind('ajax:success', function (evt) {
    if (evt.detail[0].DOCUMENT_TYPE_NODE == 10) {
      $('.comments-show-form').html(evt.detail[2].responseText);
    } else {
      comment = $.parseJSON(evt.detail[2].responseText);
      $('.comments-show-form').append('<div class="form-horizontal edit-comment-link"></div>');

      $('.edit-comment-link').last().append('<div class="form-group"></div>');
      $('.comments-show-form').find('.form-horizontal').find('.form-group').last()
        .append('<div class="col-sm-3"></div>');
      $('.comments-show-form').find('.form-horizontal').find('.form-group').find('.col-sm-3').last()
        .append('<label class="form-control control-label label-warning">Комментарий:</label>');
      $('.comments-show-form').find('.form-horizontal').find('.form-group').last()
        .append('<div class="col-sm-9"></div>');
      $('.comments-show-form').find('.form-horizontal').find('.form-group').find('.col-sm-9').last()
        .append('<div class="form-control">' + comment.comment.body + '</div>');

      $('.form-horizontal').last().append('<div class="form-group"></div>');
      $('.comments-show-form').find('.form-horizontal').find('.form-group').last()
        .append('<a class="btn btn-info form-control edit-comment-link">Edit comment</a>');
      $('.comments-show-form').find('.form-horizontal').last()
        .append('<a data-confirm="Вы действительно хотите удалить?" class="btn btn-danger form-control ' +
          'edit-comment-link" rel="nofollow" data-method="delete" href="/comments/' + comment.comment.id +
          + '">Delete comment</a>');
    };
  })
  .bind('ajax:error', function (evt) {
    if (evt.detail[0].DOCUMENT_TYPE_NODE == 10) {
      $('.comment-errors').html(evt.detail[2].responseText);
    } else {
      errors = $.parseJSON(evt.detail[2].responseText);
      $.each(errors, function (index, value) {
        $('.comment-errors').append('<p>' + value + '</p>');
      });
    };
  });
});
