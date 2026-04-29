function bitstream = compressAudioToBitstream(file,fs)
    % Compress audio into mp3 bitstream
    % Inputs:
    %   filepath: path to audio file
    % Output:
    %   bitstream: boolean array representing compressed MP3
    if ischar(file)
        [audio, fs] = audioread(file);
    else
        audio = file;
    end
    % Convert to temporary mp3 file (to save on space)
    tmpfile = tempname + ".mp3";
    audiowrite(tmpfile, audio, fs);

    % Read as raw bytes
    fid = fopen(tmpfile, 'rb');
    bytes = fread(fid, Inf, 'uint8');
    fclose(fid);

    % Convert bytes to bitstream
    bits = de2bi(bytes, 8, 'left-msb');
    bitstream = bits(:)';

    % Delete temporary mp3 file
    delete(tmpfile);
end