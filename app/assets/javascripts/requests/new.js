/**
 * Created by wackm on 11-Jan-17.
 */

// Hides and shows elements based on click.
function toggle_visibility(id) {
    var e = document.getElementById(id);
    if (e.style.display == 'none')
        e.style.display = 'block';
    else
        e.style.display = 'none';
}

// Helps to correctly handle nested models.
$("form").submit(function () {
    $(this).submit(function () {
        return false;
    });
    return true;
});

// Handles DataTable bootup function.
$(document).ready(function () {
    $('#main_table').DataTable({
        "columnDefs": [
            {"width": "8%", "targets": 2},
            {"width": "11%", "targets": 4},
            {"width": "7%", "targets": 6},
            {"width": "9%", "targets": 8},
            {"width": "8%", "targets": 9},
            {"width": "8%", "targets": 10}
        ],
        "order": [[0, "desc"]]
    });
});

// Bootstrap 3 filebuttons.
$(document).ready(function () {
    $('input[type=file]').bootstrapFileInput();
    $('.file-inputs').bootstrapFileInput();
});

$(document).ready(function () {
    if ($("#request_status").val() == "Pending") {
        $("#esthours_div").fadeOut('fast');
        $("#tothours_div").fadeOut('fast');
    } else if ($("#request_status").val() == "Ongoing") {
        $("#tothours_div").fadeOut('fast', function () {
            $("#esthours_div").fadeIn('fast');
        });
    } else if ($("#request_status").val() == "Complete") {
        $("#esthours_div").fadeOut('fast', function () {
            $("#tothours_div").fadeIn('fast');
        });
    }

    $("#request_status").change(function () {
        if ($("#request_status").val() == "Pending") {
            $("#esthours_div").fadeOut('fast');
            $("#tothours_div").fadeOut('fast');
        } else if ($("#request_status").val() == "Ongoing") {
            $("#tothours_div").fadeOut('fast', function () {
                $("#esthours_div").fadeIn('fast');
            });
        } else if ($("#request_status").val() == "Complete") {
            $("#esthours_div").fadeOut('fast', function () {
                $("#tothours_div").fadeIn('fast');
            });
        }
    });
});