require "simplecov"
SimpleCov.start("rails") do
  add_filter("/bin/")
  add_filter("/lib/tasks/annotate_rb.rake")
  add_filter("/lib/tasks/coverage.rake")
end
SimpleCov.minimum_coverage(90)
SimpleCov.use_merging(false)
