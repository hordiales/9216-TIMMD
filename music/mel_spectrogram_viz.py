import librosa
import librosa.display
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.backends.backend_pdf import PdfPages
import os

# Function to visualize the Mel spectrogram
def visualize_mel_spectrogram(audio_path):
    # Load the audio file
    y, sr = librosa.load(audio_path, sr=None)

    # Compute the Mel spectrogram
    S = librosa.feature.melspectrogram(y, sr=sr, n_mels=128)
    S_dB = librosa.power_to_db(S, ref=np.max)

    # Plot the Mel spectrogram
    plt.figure(figsize=(10, 4))
    librosa.display.specshow(S_dB, sr=sr, x_axis='time', y_axis='mel', fmax=8000)
    plt.colorbar(format='%+2.0f dB')
    plt.title('Mel Spectrogram')
    plt.tight_layout()
    plt.show()


def generate_spectrogram(file_path):
    y, sr = librosa.load(file_path)
    S = librosa.feature.melspectrogram(y, sr=sr)
    S_dB = librosa.power_to_db(S, ref=np.max)
    return S_dB

def save_spectrogram_to_pdf(spectrograms, output_pdf):
    with PdfPages(output_pdf) as pdf:
        for spec in spectrograms:
            plt.figure(figsize=(10, 4))
            librosa.display.specshow(spec, x_axis='time', y_axis='mel', sr=22050, fmax=8000)
            plt.colorbar(format='%+2.0f dB')
            plt.title('Mel Spectrogram')
            plt.tight_layout()
            pdf.savefig()
            plt.close()

def generate_drums_spectrograms(stem):
    folder_path = 'sample_audio/loops'
    files = [f for f in os.listdir(folder_path) if stem in f.lower()]

    spectrograms = []
    for file in files:
        file_path = os.path.join(folder_path, file)
        spectrogram = generate_spectrogram(file_path)
        spectrograms.append(spectrogram)
    
    save_spectrogram_to_pdf(spectrograms, stem + '_spectrograms.pdf')

if __name__ == "__main__":
    stem = 'bass'
    generate_drums_spectrograms(stem)
    stem = 'other'
    generate_drums_spectrograms(stem)
# Example usage
#audio_path = 'spotify-track-1cgKW6P31HXhlspXNWSFiP_segment.mp3'  # Replace with the path to your audio file
#visualize_mel_spectrogram(audio_path)