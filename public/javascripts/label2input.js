Event.addBehavior({
    'label.text' : function(e) {
      this.hide();
    },
    'input[type=text].text' : function(e) {
      label = this.previous('label').innerHTML;
      this.addClassName('with_label');
      (this.tagName.toLowerCase() == 'input') ? this.value = label : this.innerHTML = label;
    },
    'input[type=text].text:focus' : function(e) {
      label = this.previous('label').innerHTML;
      if (this.value == label) {
        this.removeClassName('with_label');
        (this.tagName.toLowerCase() == 'input') ? this.value = '' : this.innerHTML = '';
      }
    }
    });
