function LsbByteArray = extract_N_LSB(audio, bits, num_LSBs)
    zero_out = repmat('0', 1, 16-num_LSBs);
    one_out = repmat('1', 1, num_LSBs);
    binstr = [zero_out one_out];

    LSBarray = dec2bin(bitand(audio(1:end), typecast(uint16(bin2dec(binstr)), 'int16')));
    LSBarray = reshape(LSBarray.', 1, []);
    LSBarray = LSBarray(1:floorDiv(length(LSBarray), bits) * bits);
    LSBarray = reshape(LSBarray', bits, []).';
    LSBarray = bin2dec(LSBarray)';
    LsbByteArray = LSBarray;
end