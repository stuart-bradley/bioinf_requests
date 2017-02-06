/**
 * Created by wackm on 07-Feb-17.
 */
$(document).ready(function () {
    $('.wysihtml5').each(function (i, elem) {
        $(elem).wysihtml5({'toolbar': {'image': false}});
    });
});