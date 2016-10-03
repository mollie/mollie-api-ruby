#!/usr/bin/env ruby

# From https://github.com/test-unit/test-unit/blob/master/test/run-test.rb

$VERBOSE = true

$KCODE = "utf8" unless "".respond_to?(:encoding)

base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
lib_dir = File.join(base_dir, "lib")
test_dir = File.join(base_dir, "test")

$LOAD_PATH.unshift(lib_dir)

require 'test/unit'

exit Test::Unit::AutoRunner.run(true, test_dir)
