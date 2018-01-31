require 'erb'
require 'rubrowser/data'
require 'rubrowser/formatter/json'

module Rubrowser
  class Renderer
    # Accepted options are:
    # files: list of file paths to parse
    # toolbox: bool, show/hide toolbox
    def self.call(options = {})
      new(options).call
    end

    def call
      erb :index
    end

    private

    include ERB::Util

    attr_reader :files

    def initialize(options)
      @files = options[:files]
      @toolbox = options[:toolbox]
    end

    def toolbox?
      @toolbox
    end

    def data
      data = Data.new(files)
      formatter = Formatter::JSON.new(data)
      formatter.call
    end

    def file(path)
      File.read(resolve_file_path("/public/#{path}"))
    end

    def erb(template)
      path = resolve_file_path("/views/#{template}.erb")
      file = File.open(path).read
      ERB.new(file).result binding
    end

    def resolve_file_path(path)
      File.expand_path("../../..#{path}", __FILE__)
    end
  end
end
