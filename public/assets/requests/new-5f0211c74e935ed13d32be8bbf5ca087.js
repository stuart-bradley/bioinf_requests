function toggle_visibility(t){var e=document.getElementById(t);e.style.display="none"==e.style.display?"block":"none"}$("form").submit(function(){return $(this).submit(function(){return!1}),!0}),$(document).ready(function(){$("#main_table").DataTable({columnDefs:[{width:"8%",targets:2},{width:"11%",targets:4},{width:"7%",targets:6},{width:"9%",targets:8},{width:"8%",targets:9},{width:"8%",targets:10}],order:[[0,"desc"]]})}),$(document).ready(function(){$("input[type=file]").bootstrapFileInput(),$(".file-inputs").bootstrapFileInput()}),$(document).ready(function(){"Pending"==$("#request_status").val()?($("#esthours_div").fadeOut("fast"),$("#tothours_div").fadeOut("fast")):"Ongoing"==$("#request_status").val()?$("#tothours_div").fadeOut("fast",function(){$("#esthours_div").fadeIn("fast")}):"Complete"==$("#request_status").val()&&$("#esthours_div").fadeOut("fast",function(){$("#tothours_div").fadeIn("fast")}),$("#request_status").change(function(){"Pending"==$("#request_status").val()?($("#esthours_div").fadeOut("fast"),$("#tothours_div").fadeOut("fast")):"Ongoing"==$("#request_status").val()?$("#tothours_div").fadeOut("fast",function(){$("#esthours_div").fadeIn("fast")}):"Complete"==$("#request_status").val()&&$("#esthours_div").fadeOut("fast",function(){$("#tothours_div").fadeIn("fast")})})});