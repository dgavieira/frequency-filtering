import os
import numpy as np
import cv2
import matplotlib.pyplot as plt
from image_processor import ImageProcessor
from constants import IMAGE_XRAY, IMAGE_WOMAN

if __name__ == '__main__':
    try:
        # Create the directory for saving images
        save_dir = 'generated_images'
        os.makedirs(save_dir, exist_ok=True)

        # Part (a): Apply Butterworth filters and plot results
        processor_woman = ImageProcessor(IMAGE_WOMAN)
        img_lowpass, H_lowpass = processor_woman.apply_filter('low', cutoff=30, order=2)
        img_highpass, H_highpass = processor_woman.apply_filter('high', cutoff=30, order=2)
        
        # Save images
        processor_woman.save_image(img_lowpass, 'lowpass_filtered_image.tif', save_dir)
        processor_woman.save_image(img_highpass, 'highpass_filtered_image.tif', save_dir)

        processor_woman.plot_results(img_lowpass, img_highpass, H_lowpass, H_highpass, save_dir)

        # Part (b): Create and plot high-emphasis filter
        a = 0.5
        b = 1.5
        HHFE = processor_woman.high_emphasis_filter(a, b, cutoff=30, order=2, filter_type='high', show=True)
        
        # Save high-emphasis filter
        processor_woman.save_image(HHFE, 'high_emphasis_filter.tif', save_dir)

        # Part (c): Test high-emphasis filter with chestXray.tif
        processor_xray = ImageProcessor(IMAGE_XRAY)
        HHFE = processor_xray.high_emphasis_filter(a, b, cutoff=30, order=2, filter_type='high', show=True)

        # Spectrum before and after filtering
        plt.figure()
        plt.subplot(121), plt.imshow(np.log(1 + np.abs(processor_xray.image_fft_shifted)), cmap='gray'), plt.title('Original Spectrum')
        fshift_filtered = processor_xray.image_fft_shifted * HHFE
        plt.subplot(122), plt.imshow(np.log(1 + np.abs(fshift_filtered)), cmap='gray'), plt.title('Filtered Spectrum')
        plt.savefig(os.path.join(save_dir, 'spectrum_comparison.png'))  # Save as PNG
        plt.close()

        # Apply high-emphasis filter
        img_filtered = np.fft.ifft2(np.fft.ifftshift(fshift_filtered))
        img_filtered = np.abs(img_filtered)

        # Histogram equalization
        img_equalized = processor_xray.histogram_equalization(img_filtered)
        processor_xray.plot_histogram_equalization(img_filtered, img_equalized, save_dir)
        
        # Save histogram equalized image
        processor_xray.save_image(img_equalized, 'equalized_image.tif', save_dir)

    except Exception as e:
        print(f"An error occurred: {e}")