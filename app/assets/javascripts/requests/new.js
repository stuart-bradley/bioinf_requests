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

$(document).ready(function () {
    $('#requests-table').dataTable({
        "processing": true,
        "serverSide": true,
        "ajax": $('#requests-table').data('source'),
        "pagingType": "full_numbers",
        "autoWidth": false,
        "columns": [
            {data: 'id'},
            {data: 'title'},
            {data: 'submitted_by'},
            {
                data: 'description', "createdCell": function (td, cellData, rowData, row, col) {
                $(td).addClass('long-text-td');
            }
            },
            {data: 'download_attachment'},
            {data: 'results', className: 'long-text-td'},
            {data: 'result_files'},
            {
                data: 'status', "createdCell": function (td, cellData, rowData, row, col) {
                if (cellData == "Complete") {
                    $(td).css('background-color', "#4CAE4C").css('color', 'white');
                } else if (cellData == "Ongoing") {
                    $(td).css('background-color', "#46B8DA").css('color', 'white');
                } else {
                    $(td).css('background-color', "#EEA236").css('color', 'white');
                }
            }
            },
            {data: 'status_history'},
            {data: 'priority'},
            {data: 'job_assignment'},
            {data: 'buttons'}
        ]
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