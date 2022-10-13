<!DOCTYPE html>
<html lang="en">
<head>
   <title>Wednesday Night Song Sheet</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

   <link rel="stylesheet" type="text/css" href="style.css?t=<?= uniqid(); ?>'">
</head>
<body id=''>
    <div id='songsheet'>
   <div id='controls'>
       <input id='filter' onClick="selectAll(this)" type='text' v-model='filter' placeholder='Search...'/>
       <div id='fontAdjust'>
        <button id='increaseFont' onClick="adjustFont(1.2)" type='button'>+</button>
        <button id='decreaseFont' onClick="adjustFont(0.8)" type='button'>-</button>
       </div>
   </div>

   <div id='songs'>
      <div class='song' v-for="s in filteredSongs" >
         <div class='title' onClick='toggleLyrics(this)' >{{ s.number }}: {{ s.title }}</div>
         <div class='lyrics' style='display:none;'>{{ s.lyrics }}</div>
      </div>
   </div>
    </div>
   <script type="text/javascript" src='lyrics.js?t=<?= uniqid(); ?>'></script>   
   <script type="text/javascript" src='vue.js'></script>   
   <script type="text/javascript">

    function setCookie(cname, cvalue, exdays) {
      const d = new Date();
      d.setTime(d.getTime() + (exdays*24*60*60*1000));
      let expires = "expires="+ d.toUTCString();
      document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
    }

    var lastActive = null;
    function toggleLyrics(el){
        lyrics = el.nextElementSibling;
        if ( lastActive !== null && lastActive !== lyrics ) {
            lastActive.style.display = "none";
        }
          if (lyrics.style.display === "none") {
            lyrics.style.display = "block";
          } else {
            lyrics.style.display = "none";
          }
        lastActive = lyrics;
    }

    function getCookie(cname) {
      let name = cname + "=";
      let decodedCookie = decodeURIComponent(document.cookie);
      let ca = decodedCookie.split(';');
      for(let i = 0; i <ca.length; i++) {
        let c = ca[i];
        while (c.charAt(0) == ' ') {
          c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
          return c.substring(name.length, c.length);
        }
      }
      return "";
    }

    function adjustFont(amount) {
      var sz = document.body.style.fontSize;
      if (sz =='') sz = 14; //default font size

      var size = parseFloat(sz) * (amount) + "px";
      document.body.style.fontSize = size;
        setCookie("fontSize", size, 365);
    }   

    userFontSize = getCookie("fontSize")
    if (userFontSize != "" ){ document.body.style.fontSize = userFontSize; }
    

    function selectAll(el)
    {
        el.focus();
        el.select();
    }

      var my_resume = new Vue({
        el: '#songsheet',
        data: {
            songs: songs.songs,
            filter: "",
        },
          computed: {
            filteredSongs() {
              return this.songs.filter(song => {
                return song.title.toLowerCase().includes(this.filter.toLowerCase()) || song.number.toString().includes(this.filter)
              })
            }
},
      })
   </script>   
</body>
</html>
