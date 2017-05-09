/**
 * Created by wackm on 11-Jan-17.
 */

$(document).ready(function () {
    var user_tables = [
        "#user_table_Total",
        "#user_table_waynemitchell",
        "#user_table_stuartbradley",
        "#user_table_aseladassanayake",
        "#user_table_jamesdaniell",
        "#user_table_vinicioreynoso"
    ];
    $.each(user_tables, function (index, value) {
        $(value).DataTable({
            "order": [[0, "desc"]]
        });
    });
});

// Datepicker functions.
$(document).ready(function () {
    $("#specific_dates").change(function () {
        var d = new Date();
        var allowed_change = false
        if ($("#specific_dates").val() == "1 Month") {
            d = new Date(d.setMonth(d.getMonth() - 1));
            allowed_change = true
        } else if ($("#specific_dates").val() == "3 Months") {
            d = new Date(d.setMonth(d.getMonth() - 3));
            allowed_change = true
        } else if ($("#specific_dates").val() == "6 Months") {
            d = new Date(d.setMonth(d.getMonth() - 6));
            allowed_change = true
        } else if ($("#specific_dates").val() == "1 Year") {
            d = new Date(d.setYear(d.getFullYear() - 1));
            allowed_change = true
        }
        if (allowed_change) {
            $("#date_max").val(dateToYMD(new Date()))
            $("#date_min").val(dateToYMD(d))
        }
    });
});

function dateToYMD(date) {
    var d = date.getDate();
    var m = date.getMonth() + 1;
    var y = date.getFullYear();
    return '' + y + '-' + (m <= 9 ? '0' + m : m) + '-' + (d <= 9 ? '0' + d : d);
}