#!ruby

require "digest"

def list_files(path)
    filepaths = []
    filenames = Dir.entries(path)

    filenames.each do |filename|
        if filename == "." || filename == ".."
            next
        end

        filepath = "#{path}/#{filename}"

        if File.directory?(filepath)
            arr = list_files(filepath)
            filepaths.append(*arr)

            next
        end

        filepaths << "#{filepath}"
    end

    return filepaths
end

def scan(path)
    file_index = {}
    file_index_c = {}

    filenames = list_files(path)

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

    keys = file_index_c.sort_by {|key, val| -val}.map {|item| item[0]}
    max = file_index_c.values.max

    if max > 1 && keys.length > 0
        keys.each_with_index { |key, index|
            if file_index_c[keys[index]] < max
                next
            end

            filepath = file_index[keys[index]][0]

            if !File.exists?(filepath)
                next
            end

            file = File.open(filepath)
            content = file.read

            puts "#{content} #{file_index_c[keys[index]]}"
        }
    else
        puts "No file duplication"
    end
end

scan("./DropsuiteTest")
