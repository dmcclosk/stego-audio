function message = bytes2message(bytes)
    message = '';
    for i = 1:length(bytes)
        if bytes(i) >= 32 && bytes(i) <= 126
            message = [message, char(bytes(i))];
        else
            break;
        end
    end
end