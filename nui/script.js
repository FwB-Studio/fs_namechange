$(function () {
  window.onload = (e) => {

    //  display(true);
      function display(bool) {
        if (bool) {
          $("body").css("display", "flex");
        } else {
          $("body").css("display", "none");
        }
      }
     
      window.addEventListener("message", (event) => {
        var item = event.data;
       
        if (item.display == "true") {
          document.getElementById(`fname`).value = '';
          document.getElementById(`lname`).value = '';
          display(true);
         
        } else {
          display(false)
        }
      });

      var change = document.getElementById(`change`);
      

      change.onclick = async function () {
        display(false)
      var fname = document.getElementById(`fname`).value;
      var lname = document.getElementById(`lname`).value;
      $.post("https://fs_namechange/fs_namechangeexit", JSON.stringify({ firstname : fname, lastname : lname }))
      };
   

      document.onkeyup = function (data) {
        if (data.which == 27 || data.which == 8) {
          display(false)
          $.post("https://fs_namechange/fs_namechangeclose", JSON.stringify({}))
        }
      };

   };
});
