/*
---
description: Basic script
 
license: Public domain (http://unlicense.org).

authors: 

requires:
  - SemanticDatas.Widget
  - More/URI
  - Core/Request

provides:
  - SemanticDatas.Widget.RssForm

...
*/

SemanticDatas.Widget.RssForm = new Class({
  options: {
    path: '/rss/feed.rss',
    htmlTemplate: '<link rel="alternate" type="application/rss+xml" title="RSS" href="{URL}" />'
  },
  
  build: Macro.onion(function() {
    this.options.host = this.element['host'].value;
    
    this.element.getElements("input, select").addEvents({
     'change': this.generateRssUrl.bind(this),
     'keyup': this.generateRssUrl.bind(this)
    });
    
    this.element.getElements(".get_peview").addEvent("click", function(e) {
      e.stop();
      this.makePreview();
    }.bind(this));
    
    if (window.location.hash.length > 3) {
      this.element['feed[url]'].value = window.location.hash.replace(/^#/, "");
      this.generateRssUrl()
    }
  }),
  
  makePreview: function () {
    var url = this.generateRssUrl().replace(/http:\/\/([^\/]+)/, "");
    
    new Request({
      url: url,
      onComplete: this.showPreviewPosts
    }).GET()
  },
  
  showPreviewPosts: function (content, tree) {
    var ch = Element.getElement(tree, 'channel');
    var title = ch.getElement('title').get('text');
    var description = ch.getElement('description').get('text');
    console.log(title, description);
  },
  
  generateRssUrl: function () {
    var uri = new URI("http://" + this.options.host + this.options.path);
    
    uri.set('data', this.collectData());
    
    this.element.getElement('.result_url').set('value', uri.toString());
    
    var html = this.options.htmlTemplate.replace("{URL}", uri.toString());
    this.element.getElement('.result_html').set('value', html);
    
    window.location.hash = this.element['feed[url]'].value;
    return uri.toString();
  },
  
  collectData: function () {
    var data = {url: this.element['feed[url]'].value};
    
    if (this.element['feed[max_posts]'].value.toInt() != 20) {
      data.max_post = this.element['feed[max_posts]'].value.toInt()
    }
    
    if (this.element['feed[max_age]'].value.toInt() != 2592000) {
      data.max_age = this.element['feed[max_age]'].value.toInt()
    }
    
    return data;
  },
});
