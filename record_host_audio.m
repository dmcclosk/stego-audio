function signal1 = record_host_audio(audio_length,fs)
    recObj1 = audiorecorder(fs,16,1,1);

    record(recObj1);
    pause(audio_length);
    stop(recObj1);
    
    signal1 = getaudiodata(recObj1);
end