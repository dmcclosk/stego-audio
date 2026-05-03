function output = encode_audiostream_1D(audio, bitstream)
    for i = 1:length(bitstream)
        audio(i) = bitand(audio(i), int16(-2));
        audio(i) = bitor(audio(i), typecast(uint16(bin2dec(bitstream(i))), 'int16'));
    end
    output = audio;
end