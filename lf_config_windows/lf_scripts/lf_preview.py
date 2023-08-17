import sys
import mimetypes
import pathlib
import os


def get_mimetype(path):
    return mimetypes.guess_type(path)[0]


def handle_text(path):
    with open(path, "r") as f:
        print(f.read())


def print_divider():
    print("-" * 80)


def handle_pdf(path):
    try:
        import fitz

        doc = fitz.open(path)
        num_pages = doc.page_count
        text = clean_text(doc.get_page_text(0))
        doc.close()
        print(f"Pages: {num_pages}")
        print(text)
    except ImportError:
        print("Install pymupdf for PDF previews")


def handle_audio(path):
    try:
        from pydub import AudioSegment
        audio = AudioSegment.from_file(path)
        duration = len(audio) / 1000  # 音频时长（秒）
        channels = audio.channels  # 音频通道数
        sample_width = audio.sample_width  # 音频采样宽度（字节）
        sample_rate = audio.frame_rate  # 音频采样率（Hz）

        print(path)

        print(f"Duration: {duration} seconds")
        print(f"Channels: {channels}")
        print(f"Sample Width: {sample_width} bytes")
        print(f"Sample Rate: {sample_rate} Hz")
    except ImportError:
        print("Install pydub for audio previews")


def clean_text(text):
    # remove all non-ascii characters
    return "".join(c for c in text if ord(c) < 128)


def handle_image(path):
    try:
        from PIL import Image

        img = Image.open(path)
        width, height = img.size
        print(f"Size: {width}*{height}")
    except ImportError:
        print("Install Pillow for image previews")


def format_time_t(time_t):
    # convert time-t to date
    from datetime import datetime

    return datetime.fromtimestamp(time_t).strftime("%Y-%m-%d %H:%M:%S")


def format_file_size(size_in_bytes):
    if size_in_bytes < 1024:
        return f"{size_in_bytes} B"
    elif size_in_bytes < 1024 * 1024:
        return f"{size_in_bytes / 1024:.2f} KB"
    elif size_in_bytes < 1024 * 1024 * 1024:
        return f"{size_in_bytes / 1024 / 1024:.2f} MB"
    else:
        return f"{size_in_bytes / 1024 / 1024 / 1024:.2f} GB"


if __name__ == "__main__":
    file_path = sys.argv[2]
    mimetype = get_mimetype(file_path)

    if mimetype is None:
        mimetype = "none"

    try:
        path = pathlib.Path(file_path)
        size = path.stat().st_size
        print("File Size: {}".format(format_file_size(size)))
        print("Modify Time: {}".format(
            format_time_t(os.path.getmtime(file_path))))

        if mimetype == "none":
            # if file size is less 100kb
            if size < 1024 * 100:
                print_divider()
                handle_text(file_path)
        if mimetype.startswith("text"):
            print_divider()
            handle_text(file_path)
        if mimetype.startswith("application/pdf"):
            print_divider()
            handle_pdf(file_path)
        if mimetype.startswith("image"):
            print_divider()
            handle_image(file_path)
        if mimetype.startswith("audio"):
            print_divider()
            handle_audio(file_path)

    except Exception as e:
        print(e)
