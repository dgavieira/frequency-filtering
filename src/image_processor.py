import os
import numpy as np
import cv2
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

class ImageProcessor:
    def __init__(self, image_path):
        self.image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
        if self.image is None:
            raise FileNotFoundError(f"Image not found at path: {image_path}")
        if len(self.image.shape) != 2:
            raise ValueError("Image should be grayscale.")
        print(f"Image loaded with shape: {self.image.shape}")

        self.image_fft = np.fft.fft2(self.image)
        self.image_fft_shifted = np.fft.fftshift(self.image_fft)
        self.rows, self.cols = self.image.shape

    def butterworth_filter(self, cutoff, order, filter_type='low'):
        P, Q = self.image.shape
        u = np.arange(P) - P / 2
        v = np.arange(Q) - Q / 2
        U, V = np.meshgrid(v, u)
        D = np.sqrt(U ** 2 + V ** 2)
        if filter_type == 'low':
            H = 1 / (1 + (D / cutoff) ** (2 * order))
        elif filter_type == 'high':
            H = 1 / (1 + (cutoff / D) ** (2 * order))
        else:
            raise ValueError("Filter type must be 'low' or 'high'")
        
        # Center the filter
        H = np.fft.fftshift(H)
        return H

    def apply_filter(self, filter_type, cutoff, order):
        H = self.butterworth_filter(cutoff, order, filter_type)
        # Resize filter to match image dimensions
        H_padded = np.zeros_like(self.image, dtype=np.float64)
        H_padded[:H.shape[0], :H.shape[1]] = H
        fshift_filtered = self.image_fft_shifted * H_padded
        f_filtered = np.fft.ifftshift(fshift_filtered)
        img_filtered = np.fft.ifft2(f_filtered)
        img_filtered = np.abs(img_filtered)
        self.plot_filter(H_padded, f'{filter_type.capitalize()} Filter', 'generated_images')
        return img_filtered, H_padded

    def high_emphasis_filter(self, a, b, cutoff, order, filter_type, show=False):
        HHP = self.butterworth_filter(cutoff, order, filter_type)
        # Resize filter to match image dimensions
        HHP_padded = np.zeros_like(self.image, dtype=np.float64)
        HHP_padded[:HHP.shape[0], :HHP.shape[1]] = HHP
        HHFE = a + b * HHP_padded
        if show:
            self.plot_filter(HHFE, 'High-Emphasis Filter', 'generated_images')
        return HHFE

    def plot_filter(self, H, title, save_dir):
        plt.figure()
        plt.imshow(H, cmap='gray')
        plt.title(f'2D Visualization of {title}')
        plt.savefig(os.path.join(save_dir, f'{title}_2d.png'))  # Save as PNG
        plt.close()

        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        X = np.arange(H.shape[0])
        Y = np.arange(H.shape[1])
        X, Y = np.meshgrid(Y, X)
        ax.plot_surface(X, Y, H, cmap='viridis')
        plt.title(f'3D Visualization of {title}')
        plt.savefig(os.path.join(save_dir, f'{title}_3d.png'))  # Save as PNG
        plt.close()

    def save_image(self, img, filename, save_dir):
        img_uint8 = np.uint8(img)  # Convert to uint8 for saving
        cv2.imwrite(os.path.join(save_dir, filename), img_uint8)

    def plot_results(self, img_lowpass, img_highpass, H_lowpass, H_highpass, save_dir):
        plt.figure(figsize=(12, 6))
        plt.subplot(131), plt.imshow(self.image, cmap='gray'), plt.title('Original Image')
        plt.subplot(132), plt.imshow(img_lowpass, cmap='gray'), plt.title('Lowpass Filtered Image')
        plt.subplot(133), plt.imshow(img_highpass, cmap='gray'), plt.title('Highpass Filtered Image')
        plt.savefig(os.path.join(save_dir, 'filter_results.png'))  # Save as PNG
        plt.close()

        plt.figure(figsize=(12, 6))
        plt.subplot(121), plt.imshow(H_lowpass, cmap='gray'), plt.title('2D Lowpass Filter')
        plt.subplot(122), plt.imshow(H_highpass, cmap='gray'), plt.title('2D Highpass Filter')
        plt.savefig(os.path.join(save_dir, 'filter_2d.png'))  # Save as PNG
        plt.close()

        fig = plt.figure(figsize=(12, 6))
        ax = fig.add_subplot(121, projection='3d')
        X = np.arange(H_lowpass.shape[0])
        Y = np.arange(H_lowpass.shape[1])
        X, Y = np.meshgrid(Y, X)
        ax.plot_surface(X, Y, H_lowpass, cmap='viridis')
        plt.title('3D Lowpass Filter')
        ax = fig.add_subplot(122, projection='3d')
        ax.plot_surface(X, Y, H_highpass, cmap='viridis')
        plt.title('3D Highpass Filter')
        plt.savefig(os.path.join(save_dir, 'filter_3d.png'))  # Save as PNG
        plt.close()

    def histogram_equalization(self, image):
        equalized_image = cv2.equalizeHist(image.astype(np.uint8))
        return equalized_image

    def plot_histogram_equalization(self, original_image, equalized_image, save_dir):
        plt.figure(figsize=(12, 6))
        plt.subplot(121), plt.imshow(original_image, cmap='gray'), plt.title('Original Image')
        plt.subplot(122), plt.imshow(equalized_image, cmap='gray'), plt.title('Equalized Image')
        plt.savefig(os.path.join(save_dir, 'histogram_equalization.png'))  # Save as PNG
        plt.close()
