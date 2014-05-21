require 'csvlint'

module Cid

  class Validation

    def self.validate(path)
      result = {
        errors: {},
        warnings: {}
      }

      paths = Dir.glob("#{path}/**")

      paths.each do |path|
        begin
          schema = Csvlint::Schema.load_from_json_table(File.new(Dir["#{path}/schema.json"][0]))
        rescue
          # Error! No schema in place!
        end

        Dir["#{path}/*.csv"].each do |csv|
          validator = Csvlint::Validator.new(File.new(csv), nil, schema)
          ref =  csv.split("/").last(2).join("/")

          result[:errors][ref] = validator.errors
          result[:warnings][ref] = validator.warnings
        end
      end

      result
    end

  end

end
