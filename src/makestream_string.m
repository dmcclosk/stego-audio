function hidden_bits = makestream_string(message)
    message = uint8(message);
    hidden_bits = [];

    for i = 1:length(message)
        binStr = dec2bin(message(i), 8);

        for j = 1:8
            hidden_bits = [hidden_bits, binStr(j)];
        end
    end
end