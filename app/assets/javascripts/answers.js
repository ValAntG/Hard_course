$(document).on("turbolinks:load", function () {
  $('form.new_answer')
  .bind('ajax:success', function (evt) {
    if (evt.detail[0].DOCUMENT_TYPE_NODE == 10) {
      $('.answers-show-form').html(evt.detail[2].responseText);
    } else {
      answer = $.parseJSON(evt.detail[2].responseText);
      $('.answers-show-form').append('<div class="form-horizontal edit-answer-link"></div>');

      $('.form-horizontal').last().append('<div class="form-group"></div>');
      $('.answers-show-form').find('.form-horizontal').find('.form-group').last().append('<div class="col-sm-3"></div>');
      $('.answers-show-form').find('.form-horizontal').find('.form-group').find('.col-sm-3').last()
        .append('<label class="form-control control-label label-warning">Ответ:</label>');
      $('.answers-show-form').find('.form-horizontal').find('.form-group').last().append('<div class="col-sm-9"></div>');
      $('.answers-show-form').find('.form-horizontal').find('.form-group').find('.col-sm-9').last()
        .append('<div class="form-control">' + answer.answer.body + '</div>');

      $('.form-horizontal').last().append('<div class="form-group"></div>');
      $('.answers-show-form').find('.form-horizontal').find('.form-group').last().append('<div class="col-sm-3"></div>');
      $('.answers-show-form').find('.form-horizontal').find('.form-group').find('.col-sm-3').last()
        .append('<label class="form-control control-label label-warning">Attachments:</label>');
      $('.answers-show-form').find('.form-horizontal').find('.form-group').last()
        .append('<div class="col-sm-offset-3 col-sm-9 attachment"></div>');
      $('.answers-show-form').find('.form-horizontal').find('.form-group').find('.col-sm-9').last()
        .append("<a href='" + answer.attachments[0].file.url + "'>" + answer.attachments[0].file.url + '</a>');

      $('.form-horizontal').last().append('<div class="form-group"></div>');
      $('.answers-show-form').find('.form-horizontal').find('.form-group').last()
        .append('<a class="btn btn-info form-control edit-answer-link">Edit answer</a>');
    };
  })
  .bind('ajax:error', function (evt) {
    if (evt.detail[0].DOCUMENT_TYPE_NODE == 10) {
      $('.answer-errors').html(evt.detail[2].responseText);
    } else {
      errors = $.parseJSON(evt.detail[2].responseText);
      $.each(errors, function (index, value) {
        $('.answer-errors').append('<p>' + value + '</p>');
      });
    };
  });
})
