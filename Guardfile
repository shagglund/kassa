ignore %r{^ignored\/path\/, /public/}

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/environments/test.rb')
  watch('config/routes.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch(%r{^config/locales/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch(%r{^spec/support/.*\.rb$}) { :rspec }
  watch(%r{features/support/}) { :cucumber }
end

guard :rspec do
  watch(/^spec\/.+_spec\.rb$/)
  watch(/^app\/(.+)\.rb$/)     { |m| "spec/#{m[1]}_spec.rb" }
  watch(/^lib\/(.+)\.rb$/)     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch('spec/factories.rb') { "spec" }
end

guard :jasmine do
  watch(/spec\/javascripts\/.+_spec\.(js\.coffee|js|coffee)$/)
  watch(/spec\/javascripts\/spec\.(js\.coffee|js|coffee)$/)         { "spec/javascripts" }
  watch(/app\/assets\/javascripts\/(.+?)\.(js\.coffee|js|coffee)$/)  { |m| "spec/javascripts/#{m[1]}_spec.#{m[2]}" }
end

