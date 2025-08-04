def offset_map(n, arr = [1, 0])
    arr << (arr.last(2).sum % 26) until arr.size == n
    return arr
end

def encode(input_text)
#   puts "input_text:\t#{input_text}"
    plain_text = input_text.gsub(' ', '').upcase.chars.map { |c| c.ord - 65 }
#   puts "plain_text:\t#{plain_text}"
    offsets = offset_map(plain_text.size)
    plain_text.map { |ord| (((ord + offsets.pop) % 26) + 65).chr }.join
end

def decode(input_text)
    cipher_text = input_text.gsub(' ', '').upcase.chars.map { |c| c.ord - 65 }
    offsets = offset_map(cipher_text.size)
    cipher_text.map { |ord| (((ord - offsets.pop) % 26) + 65).chr }.join
end

def encode_from_file(file_path)
    return '' unless File.file?(file_path)
    output = ['']
    # Build plain text
    for line in File.readlines(file_path).map(&:chomp) do
        line == '' ? output << '' : output[-1] += line.gsub(/[^A-Za-z]/, '') + ''
    end
    # Remove any empty lines
    output.select! { |line| line != '' }
    # Return encoded cipher text
    return output.map { |line| encode(line) }
end

# text = 'abc my name is louis machin'
# puts "text:\t#{text}"
# cipher_text = encode(text)
# puts "cipher:\t#{cipher_text}"
# plain_text = decode(cipher_text)
# puts "plain:\t#{plain_text}"