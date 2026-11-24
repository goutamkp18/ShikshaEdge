import os

# Create valid silent MP3 frame (MPEG-1 Layer 3, 128 kbps, 44100 Hz, with padding = 418 bytes)
# Sync: 0xFF, 0xFB (MPEG 1, Layer 3, no CRC)
# Bitrate/Freq: 0x90 (128 kbps, 44.1 kHz)
# Channel: 0x64 (Joint stereo)
frame_header = bytes([0xFF, 0xFB, 0x90, 0x64])
frame_data = frame_header + bytes([0x00] * (418 - 4))
# Repeat for ~2-3 seconds of audio (approx 80 frames)
sample_mp3_data = frame_data * 80

audio_files = [
    "D:/ShikshaEdge/android-app/assets/audio/en/mathematics/math_mult_intro.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/kn/mathematics/math_mult_intro.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/en/mathematics/math_mult_q1.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/kn/mathematics/math_mult_q1.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/en/science/sci_photo_intro.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/kn/science/sci_photo_intro.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/en/science/sci_photo_q1.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/kn/science/sci_photo_q1.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/en/english/eng_nouns_intro.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/kn/english/eng_nouns_intro.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/en/english/eng_nouns_q1.mp3",
    "D:/ShikshaEdge/android-app/assets/audio/kn/english/eng_nouns_q1.mp3",
]

for p in audio_files:
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, "wb") as f:
        f.write(sample_mp3_data)
    print(f"Generated valid MP3 asset: {p}")

print("All sample MP3 audio assets generated successfully!")
