module RubyCode
  # @api private
  # Whether or not the native extension is present
  @@has_native_ext = false

  def self.native?
    @@has_native_ext
  end

  def self.librustextension_path
    File.expand_path("../../../../rust-extension/target/dist/x86_64-linux", __FILE__)
  end

  begin
    lib = "#{librustextension_path}/librustextension.so"

    if File.exist?(lib)
      # First attempt to require the native extension
      puts "Requiring Native"
      require_relative "../../target/x86_64-linux/ruby_code_native"

      # Attempt to link the .sb
      puts "Loading Rust Extension"
      load_librustextension(lib)

      # If nothing was thrown, then the native extension is present
      @@has_native_ext = true
    else
      raise LoadError, "Cannot find native extensions in #{librustextension_path}"
    end
  end

end
