/*
---
description: Basic widget
 
license: Public domain (http://unlicense.org).

authors: 
 
requires:
  - SemanticDatas
  - LSD/LSD.Type

provides:
  - SemanticDatas.Widget
 
...
*/

new LSD.Type('Widget', 'SemanticDatas');

// Fuck lsd bugs with links!
SemanticDatas.Widget.A = new Class({
  options: {
    pseudos: Array.fast('clickable')
  },
  
  click: function () {
    window.location = this.element.get('href');
  }
});

// Inject native widgets into default widget pool as a fallback
LSD.Element.pool.unshift(SemanticDatas.Widget);