import numpy as np
from scipy.ndimage import gaussian_filter1d, median_filter
from scipy.signal import find_peaks
from skimage.filters import gaussian

class TissueMasker:
    def __init__(
        self,
        nbins: int = 256,
        smooth_sigma_hist: float = 1.0,
        median_filter_size: int = 7,
        n_peaks: int = 1,
        gaussian_smoothing: float = 3.0,
    ):
        """
        The TissueMasker class generates tissue masks based on intensity histograms:
        1) For each image, it collapses the multi-channel image into a single channel
           by taking the mean across channels after arcsinh transformation and scaling.
        2) It applies a median filter to reduce noise.
        3) It computes the intensity histogram of the filtered image.
        4) It identifies the minimum to the left of the median intensity in the histogram.
        5) It thresholds the image at this minimum to create a binary tissue mask.

        Note: higher nbins and higher n_peaks result usually in more background being detected.

        Parameters:
        - nbins (int): Number of bins for the histogram.
        - smooth_sigma_hist (float): Sigma for Gaussian smoothing of histogram counts.
        - smooth_sigma_median_filter (int): Size of the median filter applied to the image
        - n_peaks (int): Number of minima to consider when determining the threshold.
        - gaussian_smoothing (float): Sigma for Gaussian smoothing applied to the final mask.
        """
        self.nbins = nbins
        self.smooth_sigma_hist = smooth_sigma_hist
        self.median_filter_size = median_filter_size
        self.n_peaks = n_peaks
        self.gaussian_smoothing = gaussian_smoothing

    def _find_left_of_median_minimum(self, image: np.ndarray) -> float:
        """
        image: 2D numpy array (one-channel). dtype can be uint8, float, etc.
        nbins: histogram bins (use 256 for 8-bit images).
        smooth_sigma: gaussian smoothing sigma on histogram counts.
        returns: intensity_value_of_minimum
        """
        # Flatten and compute median
        vals = image.ravel().astype(np.float64)
        median_val = np.median(vals)

        # Make histogram over full possible range of values in the image
        vmin, vmax = vals.min(), vals.max()
        counts, bin_edges = np.histogram(vals, bins=self.nbins, range=(vmin, vmax))
        bin_centers = (bin_edges[:-1] + bin_edges[1:]) / 2.0

        # Smooth counts
        counts_s = gaussian_filter1d(counts.astype(float), sigma=self.smooth_sigma_hist)

        # Limit to left-of-median (<= median)
        left_mask = bin_centers <= median_val
        left_centers = bin_centers[left_mask]
        left_counts = counts_s[left_mask]

        # Option A: find local minima using find_peaks on negative
        peaks, _ = find_peaks(-left_counts)  # peaks indexes into left_counts that are minima
        minima_indices = peaks  # indices into left_counts

        chosen_idx = None
        if minima_indices.size == 0:
            # No local minima: fall back to 0
            intensity_min = 0.0
        else:
            # Choose the leftmost minimum that is not zero
            if self.n_peaks == 1:
                for idx in minima_indices:
                    if left_centers[idx] > 0:
                        chosen_idx = idx
                        break
                intensity_min = left_centers[chosen_idx]
            if self.n_peaks > 1:
                if len(minima_indices) >= self.n_peaks:
                    intensity_min = left_centers[minima_indices[self.n_peaks-1]]
                else:
                    print(f"Warning: requested {self.n_peaks} minima but only found {len(minima_indices)}. Returning the last available minimum.")
                    for idx in minima_indices:
                        if left_centers[idx] > 0:
                            chosen_idx = idx
                            break
                    intensity_min = left_centers[chosen_idx]

        return intensity_min

    def process_image(self, image: np.ndarray) -> np.ndarray:

        img_arcsinh = np.arcsinh(image / 5)
        img_min = img_arcsinh.min(axis=(1, 2), keepdims=True)
        img_max = img_arcsinh.max(axis=(1, 2), keepdims=True)
    
        scaled_image = (img_arcsinh - img_min) / (
            img_max - img_min + 1e-8
        )  # Avoid division by zero
        scaled_image = scaled_image * (1 - 0) + 0
        collapsed_image = np.mean(scaled_image, axis=0, keepdims=True)
        
        img_filtered = median_filter(collapsed_image, size=self.median_filter_size)
        intensity_min = self._find_left_of_median_minimum(img_filtered)
        final_mask = img_filtered > intensity_min
        smoothed_mask = np.empty_like(final_mask.astype(np.float32))
        for channel in range(final_mask.shape[0]):  # Apply filter channel-wise
            smoothed_mask[channel] = gaussian(final_mask[channel], sigma=3)
        final_mask = smoothed_mask > 0.5

        # Add a fallback for empty (only 0s) mask
        if np.sum(final_mask == 0) == final_mask.size:
            final_mask = np.ones((1, image.shape[1], image.shape[2]), dtype=np.float32)

        return final_mask