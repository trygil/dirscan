#!ruby

require "digest"

def scan(path)
    filepaths = []
    filenames = Dir.entries(path)

    filenames.each do |filename|
        if filename == "." || filename == ".."
            next
        end

        filepath = "#{path}/#{filename}"

        if File.directory?(filepath)
            arr = scan(filepath)
            filepaths.append(*arr)

            next
        end

        filepaths << "#{filepath}"
    end

    return filepaths
end

file_index = {}
file_index_c = {}

filenames = scan("./DropsuiteTest")

# hash each files, put in on file_index
filenames.each { |filepath|
    filehash = (Digest::SHA256.file filepath).to_s

    if !file_index.key?(filehash)
        file_index[filehash] = []
    end

    if !file_index_c.key?(filehash)
        file_index_c[filehash] = 0
    end

    file_index[filehash] << filepath
    file_index_c[filehash] += 1
}

file_index_c.each { |key, c| puts "#{key}: #{c}"}