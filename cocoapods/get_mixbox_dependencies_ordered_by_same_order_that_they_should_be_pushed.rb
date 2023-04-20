require 'git'
require 'cocoapods-core'
require 'json'
require 'find'

repo_path = File.dirname(__FILE__) + '/..'

podspecs_to_order = Dir.glob("#{repo_path}/*\\.podspec").map { |podspec_path|
  Pod::Specification.from_file(podspec_path)
}.sort_by { |podspec|
  podspec.name
}

specs_to_push_in_order = []
specs_to_push_count_before_loop = specs_to_push_in_order.count

if podspecs_to_order.empty?
  raise Exception.new "Did not ind any podspecs in repo: #{repo_path}"
end

while not podspecs_to_order.empty?
  podspecs_to_order.delete_if { |podspec|
    dependencies_blocking_push = podspec.dependencies.select { |dependency|
      dependency.name.start_with?("Mixbox") and not specs_to_push_in_order.any? { |spec_to_push|
        spec_to_push.name == dependency.name
      }
    }

    if dependencies_blocking_push.empty?
      specs_to_push_in_order.append(podspec)
      true
    else
      false
    end
  }

  if specs_to_push_count_before_loop == specs_to_push_in_order.count
    raise Exception.new "Got into an infinite loop, can't resolve dependencies"
  end

  specs_to_push_count_before_loop = specs_to_push_in_order.count
end

puts specs_to_push_in_order.to_json
