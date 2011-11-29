require "runtime/object"
require "runtime/class"
require "runtime/method"
require "runtime/context"

# Bootstrap the runtime. This is where we assemble all the classes and objects together
# to form the runtime.

                                     # what happens in the runtime
rclass = RClass.new                  # Class
rclass.runtime_class = rclass        # Class.class = Class
object_class = RClass.new            # Object = Class.new
object_class.runtime_class = rclass  # Object.class = Class

Runtime = Context.new(object_class.new) # Object.new

Runtime["Class"] = rclass
Runtime["Object"] = object_class
Runtime["Number"] = RClass.new
Runtime["String"] = RClass.new
Runtime["TrueClass"] = RClass.new
Runtime["FalseClass"] = RClass.new
Runtime["NilClass"] = RClass.new

Runtime["true"] = Runtime["TrueClass"].new_with_value(true)
Runtime["false"] = Runtime["FalseClass"].new_with_value(false)
Runtime["nil"] = Runtime["NilClass"].new_with_value(nil)

# Object.new
Runtime["Class"].runtime_methods["new"] = proc do |receiver, arguments|
  receiver.new
end

# print("hi")
Runtime["Object"].runtime_methods["print"] = proc do |receiver, arguments|
  puts arguments.first.ruby_value
  Runtime["nil"]
end

# 1 + 2
Runtime["Number"].runtime_methods["+"] = proc do |receiver, arguments|
  a = receiver.ruby_value
  b = arguments.first.ruby_value
  Runtime["Number"].new_with_value a + b
end