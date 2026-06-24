# spaud/compute_mic_positions.py
import sofar
import numpy as np


def extract_mic_positions_from_sofa(sofa_file, mic_type="zylia"):
    """
    Extract microphone positions from a SOFA file.

    Parameters
    ----------
    sofa_file : str
        Path to the SOFA file.
    mic_type : str, optional
        Type of mic positions to extract: "zylia" (19 mics) or "eigenmic" (64 mics).

    Returns
    -------
    mic_positions : ndarray
        Array of shape (n_mics, 3) containing microphone positions (azimuth, elevation, radius).
    """

    # Open the SOFA file
    sofa_data = sofar.read_sofa(sofa_file)

    # Access ReceiverPosition
    mic_positions = np.array(sofa_data.ReceiverPosition)


    # Remove singleton dimensions
    mic_positions = np.squeeze(mic_positions)  # Converts (19,3,1) -> (19,3)
    #if mic_type == "zylia":
    #    mic_positions = sofa_data.getDataIR()['ReceiverPosition']
    #elif mic_type == "eigenmic":
    #    mic_positions = sofa_data.ReceiverPosition[:64]
    #else:
    #    raise ValueError(f"Unknown mic_type: {mic_type}")

    return mic_positions
