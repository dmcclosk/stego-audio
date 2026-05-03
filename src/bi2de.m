function decimal = bi2de(binary, varargin)
    leftMsb = false;
    if nargin > 1
        if strcmp(varargin{1}, 'left-msb')
            leftMsb = true;
        end
    end

    binary = double(binary);
    if leftMsb
        binary = fliplr(binary);
    end

    decimal = 0;
    for i = 1:length(binary)
        decimal = decimal + binary(i) * 2^(length(binary) - i);
    end
    decimal = uint8(decimal);
end