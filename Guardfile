ignore %r{^ignored\/path\/, /public/}

guard :rspec, :cli => '--drb --fail-fast --color --format doc' do
  watch(/^spec\/.+_spec\.rb$/)
  watch(/^app\/(.+)\.rb$/)     { |m| "spec/#{m[1]}_spec.rb" }
  watch(/^lib\/(.+)\.rb$/)     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard :jasmine do
  watch(/spec\/javascripts\/spec\.(js\.coffee|js|coffee)$/)         { "spec/javascripts" }
  watch(/spec\/javascripts\/.+_spec\.(js\.coffee|js|coffee)$/)
  watch(/app\/assets\/javascripts\/(.+?)\.(js\.coffee|js|coffee)$/)  { |m| "spec/javascripts/#{m[1]}_spec.#{m[2]}" }
end