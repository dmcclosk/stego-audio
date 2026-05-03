function message = bits2streamString(bitstream)
    message = '';
    num_bytes = floor(length(bitstream) / 8);

    for i = 1:num_bytes
        bitGroup = double(bitstream(8*(i-1)+1:8*i));
        charVal = 0;
        for j = 1:8
            charVal = charVal + bitGroup(j) * 2^(8-j);
        end
        message = [message, char(charVal)];
    end
end