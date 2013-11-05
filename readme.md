# Settings

![Refinery Settings](http://refinerycms.com/system/images/0000/0666/settings.png)

## About

Refinery Settings was extracted from Refinery CMS just before 2.0.0 was released
and can now be used separately.

## Installation
Add the gem to you Gemfile:

    gem 'refinerycms-settings'

Generate and install the necessary migrations:

    rails generate refinery:settings
    rake db:migrate

## Upgrading from 2.0.x
When you upgrade from version 2.0.x make sure you run:

    rails generate refinery:settings
    rake db:migrate

It will copy the new migration and migrate the database.

## How do I Make my Own Settings?

### In view

Settings can be really useful, especially when you have custom display logic or
new plugins that need to behave in different ways.

To best explain how settings work, let's use an example. Say you have a client
who has a display in a local trade show every year and 2 months before the trade
show, they want to display a little banner in the header of all pages.

Once the trade show is finished, the client needs to be able to hide it again
until next year. This is what your ``application.html.erb`` file might look like:

    ...
    <div id='header'>
      <h1>My Company</h1>

      <% if ::Refinery::Setting.find_or_set(:show_trade_show_banner, false) %>
        <%= image_tag ('trade-show-banner.jpg') %>
      <% end %>
    </div>
    ...

The following will automatically create a new Refinery setting called
"show_trade_show_banner" and set its default to ``false``.
If that setting already exists, it just reads in what the current value is.

So as you can see, this is quite clever because you can quickly define new settings
 and their defaults right from the view as you need them.

This setting would then show up in the backend in the 'Settings' area where the
client could change the value as their trade show approaches. Easy as pie!

### In Controller

    limit = Refinery::Setting.find_or_set(:list_limit, 20)
