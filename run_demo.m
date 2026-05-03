function run_demo(host_file, secret_msg, num_lsbs, output_file, output_fig)
    if isempty(which('run_demo'))
        projectDir = pwd;
    else
        scriptDir = fileparts(which('run_demo'));
        if exist(fullfile(scriptDir, 'src'), 'dir')
            projectDir = scriptDir;
        else
            projectDir = fileparts(scriptDir);
        end
    end
    addpath(fullfile(projectDir, 'src'));

    fprintf('=== Audio Steganography Headless Demo ===\n\n');

    if nargin < 1 || isempty(host_file)
        host_file = fullfile(projectDir, 'Media', 'host_audio', 'CantinaBand60.wav');
    end
    if nargin < 2
        secret_msg = 'Hello World!';
    end
    if nargin < 3
        num_lsbs = 1;
    end
    if nargin < 4
        output_file = fullfile(projectDir, 'Media', 'stego_output', 'demo_output.wav');
    end
    if nargin < 5
        output_fig = fullfile(projectDir, 'Media', 'outputs', 'demo_visualization.png');
    end

    fprintf('Parameters:\n');
    fprintf('  Host file: %s\n', host_file);
    fprintf('  Secret message: "%s"\n', secret_msg);
    fprintf('  LSB depth: %d\n', num_lsbs);
    fprintf('  Output file: %s\n\n', output_file);

    fprintf('1. Loading host audio...\n');
    [audio, fs] = audioread(host_file, 'native');
    audio = audio(:, 1);
    audio = audio + int16(100);
    fprintf('   Loaded %d samples, sample rate: %d Hz\n', length(audio), fs);

    fprintf('2. Encoding message...\n');
    bitstream = makestream_string(secret_msg);
    num_bits = length(bitstream);
    fprintf('   Message converted to %d bits\n', num_bits);

    if num_lsbs == 1
        stegoAudio = encode_audiostream_1D(audio, bitstream);
    else
        stegoAudio = encode_audiostream_ND(audio, bitstream, num_lsbs);
    end
    fprintf('   Encoding complete\n');

    fprintf('3. Saving stego audio...\n');
    audiowrite(output_file, double(stegoAudio)/32767, fs);
    fprintf('   Saved to: %s\n', output_file);

    [stegoReloaded, ~] = audioread(output_file, 'native');
    stegoReloaded = stegoReloaded(:, 1);

    fprintf('4. Decoding message...\n');
    num_bytes = ceil(num_bits / 8);
    num_samples_used = ceil(num_bits / num_lsbs);

    lsbValues = [];

    for i = 1:num_samples_used
        sampleVal = double(stegoReloaded(i));
        if sampleVal < 0, sampleVal = -sampleVal; end

        extracted = double(bitand(int16(sampleVal), int16(2^num_lsbs - 1)));

        for j = num_lsbs:-1:1
            bitPos = (i-1) * num_lsbs + (num_lsbs - j + 1);
            if bitPos <= num_bits
                bitVal = bitshift(extracted, -(j-1));
                bitVal = bitand(bitVal, 1);
                lsbValues = [lsbValues, double(bitVal)];
            end
        end
    end


    recovered = '';
    for i = 1:8:length(lsbValues)
        if i + 7 <= length(lsbValues)
            byteBits = lsbValues(i:i+7);
        else
            byteBits = [lsbValues(i:end), zeros(1, 8 - (length(lsbValues) - i + 1))];
        end
        byteVal = 0;
        for j = 1:8
            if j <= length(byteBits)
                byteVal = byteVal + byteBits(j) * 2^(8-j);
            end
        end
        if byteVal >= 32 && byteVal <= 126
            recovered = [recovered, char(byteVal)];
        else
            break;
        end
    end

    fprintf('   Decoded message: "%s"\n', recovered);

    fprintf('\n5. Verification:\n');
    if strcmp(secret_msg, recovered)
        fprintf('   SUCCESS: Messages match!\n');
    else
        fprintf('   WARNING: Messages do not match.\n');
        fprintf('   Original:   "%s"\n', secret_msg);
        fprintf('   Recovered:  "%s"\n', recovered);
    end

    audio_double = double(audio) / 32767;
    stego_double = double(stegoReloaded) / 32767;

    min_len = min(length(audio_double), length(stego_double));
    signal_power = mean(audio_double(1:min_len).^2);
    noise_power = mean((audio_double(1:min_len) - stego_double(1:min_len)).^2);
    if noise_power > 0
        snr = 10 * log10(signal_power / noise_power);
    else
        snr = Inf;
    end
    fprintf('   SNR: %.2f dB\n', snr);

    bits_per_sec = (length(secret_msg) * 8) / (length(audio) / fs);
    fprintf('   Data rate: %.2f bps\n', bits_per_sec);

    fprintf('\n6. Generating visualization...\n');
    fig = figure('Position', [100, 100, 1200, 800]);

    plot_len = min(1000, min(length(audio_double), length(stego_double)));

    subplot(3, 2, 1);
    hold on;
    plot(audio_double(1:plot_len), 'b-', 'LineWidth', 1);
    plot(stego_double(1:plot_len), 'r--', 'LineWidth', 1);
    hold off;
    title('Original vs Stego Audio');
    xlabel('Sample');
    ylabel('Amplitude');
    legend('Original', 'Stego');
    grid on;

    subplot(3, 2, 2);
    plot(stego_double(1:plot_len) - audio_double(1:plot_len), 'g-', 'LineWidth', 1);
    title('Difference Signal (Stego - Original)');
    xlabel('Sample');
    ylabel('Difference');
    grid on;

    subplot(3, 2, 3);
    hold on;
    original_lsbs = double(bitand(audio(1:100), int16(1)))';
    stego_lsbs = double(bitand(stegoReloaded(1:100), int16(1)))';
    stairs(1:100, original_lsbs, 'b-', 'LineWidth', 1);
    stairs(1:100, stego_lsbs + 0.1, 'r-', 'LineWidth', 1);
    hold off;
    title('LSB Comparison (first 100 samples)');
    xlabel('Sample');
    ylabel('LSB Value');
    legend('Original LSB', 'Stego LSB');
    grid on;

    subplot(3, 2, 4);
    histogram(double(audio), 50, 'FaceAlpha', 0.5, 'FaceColor', 'b');
    hold on;
    histogram(double(stegoReloaded), 50, 'FaceAlpha', 0.5, 'FaceColor', 'r');
    hold off;
    title('Sample Distribution');
    xlabel('Sample Value (int16)');
    ylabel('Count');
    legend('Original', 'Stego');
    grid on;

    subplot(3, 2, 5);
    text_str = sprintf('Encoded Message:\n"%s"\n\nParameters:\n- LSB Depth: %d\n- Bits embedded: %d\n- SNR: %.2f dB\n- Data rate: %.2f bps', ...
        secret_msg, num_lsbs, num_bits, snr, bits_per_sec);
    text(0.1, 0.5, text_str, 'FontSize', 14, 'VerticalAlignment', 'middle');
    axis off;
    title('Encoding Summary');

    subplot(3, 2, 6);
    sample_idx = 1:200;
    stem(sample_idx, double(bitand(audio(sample_idx), int16(1))), 'b', 'MarkerSize', 3);
    hold on;
    stem(sample_idx, double(bitand(stegoReloaded(sample_idx), int16(1))) + 0.2, 'r', 'MarkerSize', 3);
    hold off;
    title('LSB Embedding Visualization');
    xlabel('Sample Index');
    ylabel('LSB (0 or 1)');
    legend('Original LSB', 'Embedded LSB');
    grid on;

    sgtitle(sprintf('Audio Steganography Demo - %d-LSB Encoding', num_lsbs));

    [fig_dir, ~] = fileparts(output_fig);
    if ~exist(fig_dir, 'dir')
        mkdir(fig_dir);
    end
    saveas(fig, output_fig);
    fprintf('   Figure saved to: %s\n', output_fig);

    close(fig);

    fprintf('\n=== Demo Complete ===\n');
end