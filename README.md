# smart-list-js
Implementation of iOS UITabeViewCell. Only render view when it is appear in viewport

##Usage example
```javascript
(function() {
  document.addEventListener("DOMContentLoaded", function(event) {
    window.smartList = new window.SmartList({
      numberOfRows: function() {//dynamic number of rows
        return 2000;
      },
      heightOfRowAt: function(index) {//support dynamic height updating. It could be Changed programmatically
        return 100;
      },
      contentOfRowAt: function(index) {//example of content
        var t;
        return ((function() {
          var i, results;
          results = [];
          for (t = i = 1; i <= 5; t = ++i) {
            results.push((((function() {
              var j, ref, results1;
              results1 = [];
              for (t = j = 1, ref = index; 1 <= ref ? j <= ref : j >= ref; t = 1 <= ref ? ++j : --j) {
                results1.push(t);
              }
              return results1;
            })()).join()) + "<br>");
          }
          return results;
        })()).join();
      },
      root: document.getElementById("my_list")//DOM element to add rows to
    });
    window.smartList.refresh();
    return document.addEventListener("scroll", function() {
      return smartList.refresh();
    }, false);
  });

}).call(this);
```
	
```html
Content shows as below
Start
<div id=”my_list”>
</div>
End
```
