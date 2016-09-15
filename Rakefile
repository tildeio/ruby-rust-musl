task :rust do
  Dir.chdir "rust-extension" do
    Dir.chdir("deps") { sh "make" }
    sh "make"
  end
end

task :ruby do
  Dir.chdir "ruby-code" do
    sh "rake"
  end
end

task :test do
  Dir.chdir "ruby-code" do
    sh "ruby test.rb"
  end
end

task default: [:rust, :ruby, :test]