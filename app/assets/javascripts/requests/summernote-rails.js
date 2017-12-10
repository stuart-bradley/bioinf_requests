/**
 * Created by wackm on 05-Mar-17.
 */
$(document).ready(function () {
    $('.summernote').each(function () {
        $(this).summernote({
            callbacks: {
                onImageUpload: function (data) {
                    data.pop();
                }
            },
            toolbar: [
                ['style', ['style']],
                ['style_text', ['bold', 'italic', 'underline', 'clear']],
                ['font', ['fontname', 'fontsize']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['insert_table', ['table']],
                ['link', ['link']],
                ['misc', ['fullscreen', 'codeview', 'help']]
            ]
        });
    });
});