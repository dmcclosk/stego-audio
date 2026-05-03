# Audio Steganography

MATLAB project for hiding data in audio files using LSB (Least Significant Bit) steganography.

## Quick Start

### Headless Demo (Recommended)
```bash
"/Applications/MATLAB_R2026a.app/bin/matlab" -batch "addpath('src'); run_demo"
```

### GUI Mode
```bash
./scripts/run_matlab.sh
```
Then open Live Scripts in `notebooks/`

## Project Structure

```
stego-audio/
├── src/                  # Core LSB encoding/decoding functions
├── scripts/              # Shell scripts and one time ulitities
├── notebooks/            # MATLAB Live Scripts (.mlx)
├── Media/                # Audio files
│   ├── host_audio/      # Original audio
│   ├── stego_samples/   # Pre-encoded examples
│   └── stego_output/    # Generated output
└── README.md
```

## Core Functions (src/)

- `makestream_string.m` - Convert string to bitstream
- `encode_audiostream_1D.m` - Encode into 1-LSB
- `encode_audiostream_ND.m` - Encode into N-LSBs
- `extractLSB.m` - Extract 1-LSB
- `extract_N_LSB.m` - Extract N-LSBs
- `bits2streamString.m` - Convert bits back to string

## Usage

```bash
# Run default demo (1-LSB, "Hello World!")
./scripts/run_demo.sh

# Run with custom parameters in MATLAB
addpath('src', 'demos');
run_demo('', 'Your message', 1)
```

## Parameters

- `host_file` - Path to audio file (default: Media/host_audio/CantinaBand60.wav)
- `secret_msg` - Message to hide (default: "Hello World!")
- `num_lsbs` - LSB depth 1-13 (default: 1)
- `output_file` - Output path (default: Media/stego_output/demo_output.wav)

