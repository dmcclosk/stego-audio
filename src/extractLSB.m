function LsbByteArray = extractLSB(audio, bits)
    LSBarray = bitand(audio(1:end), int16(1));
    LSBarray = LSBarray(1:floorDiv(length(LSBarray), bits) * bits);
    LSBarray = reshape(LSBarray, bits, []);
    LsbByteArray = bin2dec(num2str(LSBarray'))';
end