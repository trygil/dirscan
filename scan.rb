#!ruby

def scan(path)
    filenames = Dir.entries(path)
    filenames.each { |filename|
        if filename == "." || filename == ".."
            next
        end

        filepath = "#{path}/#{filename}"

        if File.directory?(filepath)
            scan(filepath)
            next
        end

        puts "#{filepath}"
    }
end

scan(".")
