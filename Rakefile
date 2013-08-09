# -*- ruby -*-

require "rubygems"
require "hoe"

Hoe.add_include_dirs("../../RubyInline/dev/lib",
                     "../../ZenTest/dev/lib")

Hoe.plugin :seattlerb
Hoe.plugin :inline

Hoe.spec "un" do
  developer "Ryan Davis", "ryand-ruby@zenspider.com"

  multiruby_skip << "1.9" << "2.0" << "trunk"
end

# vim: syntax=ruby
