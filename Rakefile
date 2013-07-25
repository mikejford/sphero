# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugins.delete :rubyforge
Hoe.plugins.delete :flog
Hoe.plugin :minitest
Hoe.plugin :gemspec # `gem install hoe-gemspec`
Hoe.plugin :git     # `gem install hoe-git`

Hoe.spec 'sphero' do
  developer('Hybrid Group', 'sphero@hybridgroup.com')
  self.readme_file   = 'README.markdown'
  self.history_file  = 'CHANGELOG.rdoc'
  self.extra_rdoc_files  = FileList['*.{rdoc,markdown}']

  self.spec_extras = {
    :required_ruby_version => '>= 1.9.2'
  }
end

# vim: syntax=ruby
