(function (window) {
  var document = window.document
  
  // Polyfill Array.includes
	if (!Array.prototype.includes) {
	  Array.prototype.includes = function(searchElement /*, fromIndex*/ ) {
	    'use strict';
	    var O = Object(this);
	    var len = parseInt(O.length) || 0;
	    if (len === 0) {
	      return false;
	    }
	    var n = parseInt(arguments[1]) || 0;
	    var k;
	    if (n >= 0) {
	      k = n;
	    } else {
	      k = len + n;
	      if (k < 0) {k = 0;}
	    }
	    var currentElement;
	    while (k < len) {
	      currentElement = O[k];
	      if (searchElement === currentElement ||
	         (searchElement !== searchElement && currentElement !== currentElement)) {
	        // NaN !== NaN
	        return true;
	      }
	      k++;
	    }
	    return false;
	  };
	}

  var PostsHandler = function (container) {
    this.container = container

    window.addEventListener('hashchange', this.reloadFromHash.bind(this))
  }

  window.PostsHandler = PostsHandler

  PostsHandler.prototype = {
    load: function () {

      var checkboxes = postsForm.elements['tag']
      this.checkboxes = []
      
      for (var i in checkboxes)
        if (checkboxes[i].addEventListener)
          this.checkboxes.push(checkboxes[i])

      this.reloadFromHash()
      this.displayPosts()
    },

    /**
     * Afficher les posts
     */
    displayPosts: function () {

      // Affichage de la liste des tags
      var postsForm = this.container.querySelector('form')
      var onTagChange = this.onTagChange.bind(this)

      //console.log(postsForm, postsForm.elements, checkboxes)

      for (var i in this.checkboxes) {
        this.checkboxes[i].addEventListener('change', onTagChange)
      }
    },

    /**
     * Changer les valeurs des checkboxes en fonction du hash
     */
    reloadFromHash: function() {
      var selectedTags = this.getHashTags()

      for (var t = 0; t < this.checkboxes.length; t++) {
        this.checkboxes[t].checked = ""
      }

      for (var t = 0; t < this.checkboxes.length; t++) {
        for (var m = 0; m < selectedTags.length; m++) {
          if (this.checkboxes[t].value === selectedTags[m]) {
            console.log(selectedTags[m])
            this.checkboxes[t].checked = "checked"
            break
          }
        }
      }

      this.updateVisiblePosts()
    },

    /**
     * Retourne les tags présents dans le hash
     * @return <Array>
     */
    getHashTags: function () {
      var hash = window.location.hash
      var matches = hash.match(/([a-z0-9._-]+)/g) || []

      for (var m = 0; m < matches.length; m++) {
        matches[m] = matches[m].replace(/_/g, ' ')
      }

      return matches
    },

    /**
     * Écouteur sur les tags
     */
    onTagChange: function (event) {
      var tags = this.getHashTags()
      var checkbox = event.target

      console.log(event)

      var found = false

      for (var m = 0; m < tags.length; m++) {
        if (tags[m] === checkbox.value) {
          found = true

          if (!checkbox.checked) {
            tags.splice(m, 1)
            break
          }
        }
      }

      if (!found && checkbox.checked) {
        tags.push(checkbox.value)
      }

      window.location.hash = '#' + tags.join('&').replace(/ /g, '_')
    },

    /**
     * Mettre à jour la liste des posts en fonction des tags cliqués
     */
    updateVisiblePosts: function () {
      // Recherche des tags sélectionnés
      var checkedTags = []

      for (var t = 0; t < this.checkboxes.length; t++) {
        if (this.checkboxes[t].checked) {
          checkedTags.push(this.checkboxes[t].value)
        }
      }

      // Masquer les posts non concernés
      var liElements = this.container.querySelectorAll('ol.posts > li')

      for (var l = 0; l < liElements.length; l++) {
        var li = liElements[l]
        var liTags = li.dataset.tags.split(', ')

        if (checkedTags.length > 0) {
          for (var ct = 0; ct < checkedTags.length; ct++) {
            if (liTags.includes(checkedTags[ct])) {
              li.classList.remove('hidden')
              break
            } else {
              li.classList.add('hidden')
            }
          }
        } else {
          li.classList.remove('hidden')
        }
      }
    }
  }
})(window)
