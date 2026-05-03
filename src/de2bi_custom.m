function binary = de2bi_custom(decimal, nbits, varargin)
    leftMsb = false;
    if nargin > 2
        if strcmp(varargin{1}, 'left-msb')
            leftMsb = true;
        end
    end

    binary = zeros(1, nbits);
    temp = decimal;
    for i = nbits:-1:1
        binary(nbits - i + 1) = mod(temp, 2);
        temp = floor(temp / 2);
    end

    if leftMsb
        binary = fliplr(binary);
    end
end