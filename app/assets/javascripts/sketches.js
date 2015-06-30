$(function() {

  var dragSrcEl = null;

  function handleDragStart(e) {
    this.style.opacity = '0.4';  // this / e.target is the source node.

    dragSrcEl = this;

    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/html', this.innerHTML);
    e.dataTransfer.setData('data-id', this.getAttribute('data-id'));
    e.dataTransfer.setData('data-name', this.getAttribute('data-name'));
    e.dataTransfer.setData('id', this.id)
  }

  function handleDragOver(e) {
    if (e.preventDefault) {
      e.preventDefault(); // Necessary. Allows us to drop.
    }

    e.dataTransfer.dropEffect = 'move';  

    return false;
  }

  function handleDragEnter(e) {
    // this / e.target is the current hover target.
    this.classList.add('over');
  }

  function handleDragLeave(e) {
    this.classList.remove('over');  // this / e.target is previous target element.
  }

  function handleDrop(e) {
    // this / e.target is current target element.

    if (e.stopPropagation) {
      e.stopPropagation(); // stops the browser from redirecting.
    }

    // Don't do anything if dropping the same column we're dragging.
    if (dragSrcEl != this) {
      // Set the source column's HTML to the HTML of the column we dropped on.
      dragSrcEl.innerHTML = this.innerHTML;
      dragSrcEl.setAttribute('data-id', this.getAttribute('data-id'));
      dragSrcEl.setAttribute('data-name', this.getAttribute('data-name'));
      dragSrcEl.id = this.id;
 
      this.innerHTML = e.dataTransfer.getData('text/html');
      this.setAttribute('data-id', e.dataTransfer.getData('data-id'));
      this.setAttribute('data-name', e.dataTransfer.getData('data-name'));
      this.id = e.dataTransfer.getData('id');
      
    }

    return false;
  }

  function handleDragEnd(e) {
    // this/e.target is the source node.
    this.style.opacity = 1.0;

    [].forEach.call(cols, function (col) {
      col.classList.remove('over');
    });
  }

  var cols = document.querySelectorAll('#patterns .pattern');
  [].forEach.call(cols, function(col) {
    col.addEventListener('dragstart', handleDragStart, false);
    col.addEventListener('dragenter', handleDragEnter, false);
    col.addEventListener('dragover', handleDragOver, false);
    col.addEventListener('dragleave', handleDragLeave, false);
    col.addEventListener('drop', handleDrop, false);
    col.addEventListener('dragend', handleDragEnd, false);
  });

  var formEl = document.getElementById("new_sketch");
  if (!formEl) {
    formEl = document.getElementsByClassName("edit_sketch")[0];
  }  
  if (formEl) {
    formEl.addEventListener('submit', function(e) {
      if (e.preventDefault) {
        e.preventDefault(); 
      }
      root = {};
      var categories = [];
      $("[data-category]").each(function() {
        categories.push($(this).data('category'));
      });
      categories = categories.unique();
      for (var i = 0; i < categories.length; i++) {
        root[categories[i]] = {};
      }
      $.each($(".pattern"), function(ind,val) { 
        category = $(this).data('category');
        pattern = root[category][$(val).attr("data-name")] = {};
        var pattern_id = $(val).attr("data-id");
        var settings = $("#settings-" + pattern_id).children('input'); 
        
        for (var i = 0; i < settings.length; i++) {
          var property = settings[i].id.split("-")[2];
          var value = settings[i].value
          pattern[property] = value;
        }
      });
      
      //document.getElementById("sketch_config").textContent = JSON.stringify(root);
      this.submit();
    });
  }

  // Preliminary pattern-list deletion
  $(".pattern-remove").on("click", function() {
    var parent = $(this).parents('li');
    var id = parent.attr('data-id');
    parent.remove(); 
    $("#pattern-" + id).remove();
  });

  $(".pattern-play").on("click", function() {
    var id = $(this).parents(".pattern-desc").data('id');
    var settingEls = $("#settings-" + id).children("input");
    var settings = {};
    $.each(settingEls, function(ind, val) {
      // Expects an ID of "setting-XX-name" -- we want name.
      var paramName = val.id.split("-")[2];
      settings[paramName] = val.value;
    });
    $.ajax({
      url: "/components/test_pattern",
      type: "POST",
      data: "settings=" + JSON.stringify(settings) + "&id=" + id,
      success: function(data) { console.log(data); }
    });
  });

  // Show pattern info in side div
  $(".pattern").on("click", function() {
    var id = $(this).data('id');
    var dest = "#pattern-" + id;
    $(".pattern-desc").addClass("hidden");
    $(dest).removeClass("hidden");
  });

  // Get list of patterns for "Add more patterns..." behavior
  $("#add_patterns").on("click", function() {
    current_patterns = [];
    $.each($(".pattern"), function (ind, val) { 
      current_patterns.push(this.dataset.name);
    });
    $.ajax({
      url: "/components/patterns", 
      dataType: "json", 
      type: "GET", 
      data: "current_patterns=" + current_patterns.join(","),
      success: function(data) { 
        var new_patterns = data;
        console.log(new_patterns);
        $.each(new_patterns, function (ind, val) {
          $("#new_pattern_list").append(buildNewPatternLi(val));
        });
        $("#new_pattern_modal").modal('show');
      }
    });

  });

  function buildNewPatternLi(pat) {
    var id = "comp_" + pat.id;
    var li = '<li id="' + id + '" data-name="' + pat.name + '">';
    li += '<label><input type="checkbox" value="' + id + '"> <strong>' +
      pat.pretty_name + '</strong></label>';
    li += "<p>" + pat.description + "</p>";
    li += '</li>';

    return li;
  }

  Array.prototype.unique = function() {
    var a = [];
    for (var i=0, l=this.length; i<l; i++)
        if (a.indexOf(this[i]) === -1)
            a.push(this[i]);
    return a;
  }

});
