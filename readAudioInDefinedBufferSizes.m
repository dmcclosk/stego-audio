function [buffers, info] = readAudioInDefinedBufferSizes(filepath, bufferSize)
    % Read in audio in bufferSize chunks
    % Inputs:
    %   filename: path to audio file
    %   bufferSize: number of samples per buffer chunk
    % Output:
    %   buffers: cell array of buffer chunks

    info = audioinfo(filepath);
    totalSamples = info.TotalSamples;
    
    audio = audioread(filepath);

    chunkSizes = [repmat(bufferSize, 1, floor(totalSamples/bufferSize)), mod(totalSamples, bufferSize)];
    chunkSizes = chunkSizes(chunkSizes > 0); % remove trailing zero if evenly divisible
    buffers = mat2cell(audio, chunkSizes);

end