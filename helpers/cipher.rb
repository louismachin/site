def offset_map(n, arr = [1, 0])
    arr << (arr.last(2).sum % 26) until arr.size == n
    return arr
end

def encode(input_text)
#   puts "input_text:\t#{input_text}"
    plain_text = input_text.upcase.chars.map { |c| c.ord == 32 ? 32 : c.ord - 65 }
#   puts "plain_text:\t#{plain_text}"
    offsets = offset_map(input_text.gsub(' ', '').size)
    cipher_text = ''
    for ord in plain_text do
        if ord == 32 # space
            cipher_text += ' '
        else
            cipher_text += (((ord + offsets.pop) % 26) + 65).chr
        end
    end
    return cipher_text
end

def decode(input_text)
    cipher_text = input_text.upcase.chars.map { |c| c.ord == 32 ? 32 : c.ord - 65 }
    offsets = offset_map(input_text.gsub(' ', '').size)
    plain_text = ''
    for ord in cipher_text do
        if ord == 32 # space
            plain_text += ' '
        else
            plain_text += (((ord - offsets.pop) % 26) + 65).chr
        end
    end
    return plain_text
end

def encode_from_raw_content(raw_content)
    lines = raw_content.split('\n')
    output = ['']
    # Build plain text
    for line in lines do
        line == '' ? output << '' : output[-1] += line.gsub(/[^A-Za-z ]/, '') + ''
    end
    # Remove any empty lines
    output.select! { |line| line != '' }
    # Return encoded cipher text
    return output.map { |line| encode(line) }
end

def test_cipher
    text = 'abc my name is louis machin'
    puts "text:\t#{text}"
    cipher_text = encode(text)
    puts "cipher:\t#{cipher_text}"
    plain_text = decode(cipher_text)
    puts "plain:\t#{plain_text}"
end

# test_cipher