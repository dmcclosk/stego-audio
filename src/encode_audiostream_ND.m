function output = encode_audiostream_ND(audio, bitstream, n_bits)
    zero_out = repmat('0', 1, n_bits);
    one_out = repmat('1', 1, 16-n_bits);
    binstr = [one_out zero_out];
    ander = typecast(uint16(bin2dec(binstr)), 'int16');

    num_samples_needed = ceil(length(bitstream) / n_bits);
    encoded_audio = audio(1:num_samples_needed);

    for i = 1:length(encoded_audio)
        bit_idx_start = (i-1) * n_bits + 1;
        bit_idx_end = min(i * n_bits, length(bitstream));
        bitsection = bitstream(bit_idx_start:bit_idx_end);

        if length(bitsection) < n_bits
            bitsection = [bitsection, zeros(1, n_bits - length(bitsection))];
        end

        encoded_audio(i) = bitand(encoded_audio(i), int16(ander));
        encoded_audio(i) = bitor(encoded_audio(i), typecast(uint16(bin2dec(bitsection)), 'int16'));
    end

    output = [encoded_audio; audio(num_samples_needed+1:end)];
end