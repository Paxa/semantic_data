06-12-2011
Microdata layout with Ruby on Rails

When I was making this website I wrote some hacks for HAML, ActiveView, ActiveRecord and Mida that makes development more easier. Now I make a gem that can be used by everyone!

## Gem [green_monkey](http://github.com/Paxa/green_monkey)

It works with last versions of Haml, Rails 3 and Rails 3.1

For me now is very easy to make nice haml-templates, see examples.

*itemprop*:

    %span[:name]= item.name
    <span itemprop='name'>Item name</span>
    
*itemscope* and *itemtype*:

    %article[Mida(:Event)]
    <article itemscope itemtype='http://schema.org/Event'></article>

    %article[Mida(:Event, :DrinkUp)]
    <article itemscope itemtype='http://schema.org/Event/DrinkUp'></article>

    %article[@user]
    <article class='user' id='1' itemid='1' itemscope iteptype='http://schema.org/Person'></article>
    

ActiveRecord models supports `html_schema_type`

```ruby
class User < ActiveRecord::Base
  html_schema_type :Person
end

User.html_schema_type #=> Mida::SchemaOrg::Person
User.find(1).html_schema_type #=> Mida::SchemaOrg::Person
```

```haml
%article[@post]
  %h1[:title]= @post.title
```
    
More examples you can find in [source code](http://github.com/paxa/semantic_data/) of this project and on [gem page](http://github.com/Paxa/green_monkey)

I'm open to all suggestions, bug reports, contributions, pull requests and etc. boom