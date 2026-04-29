function audio = record_audio_for_n_seconds(n_seconds)
    % Record live audio from microphone
    % Inputs:
    %   duration: recording length in seconds
    % Output:
    %   audio: recorded audio samples

    % Common Audio Defaults
    fs = 44100;
    nBits = 16;       
    nChannels = 1;    

    % Create recorder object
    recorder = audiorecorder(fs, nBits, nChannels);

    % Record
    disp('Recording...');
    recordblocking(recorder, n_seconds);
    disp('Done');

    % Get audio data
    audio = getaudiodata(recorder);
end