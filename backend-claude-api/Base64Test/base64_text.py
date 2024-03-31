import base64
from pathlib import Path
from PIL import Image

class Base64Text:
    def resize_image(file_name:Path):
        with Image.open(file_name) as image:
            # オリジナル画像のサイズを取得
            width, height = image.size

            # 短辺を256ピクセルになるようにリサイズ
            if width < height:
                aspect_ratio = 256 / width
                new_width = 256
                new_height = int(height * aspect_ratio)
            else:
                aspect_ratio = 256 / height
                new_width = int(width * aspect_ratio)
                new_height = 256

            resized_image = image.resize((new_width, new_height))

            # リサイズした画像を保存
            resized_image.save("Base64Test/resized_image.jpg")
      
    
    def getTestBase64():
        file_name = Path("Base64Test/d2663-1169-349d5248bc5915b3c06c-0.jpg")
        
        Base64Text.resize_image(file_name)
        
        resized_image = Path("Base64Test/resized_image.jpg")
        
        with open(resized_image, "rb") as image_file:
            encoded_string = base64.b64encode(image_file.read()).decode("utf-8")
            
        file_extension = resized_image.suffix.replace(".", "")
        return f"data:image/{file_extension};{encoded_string}"
    
    
    def getPictureUrl():
        return "https://img.freepik.com/free-photo/beautiful-landscape-of-mountain-fuji_74190-3065.jpg?w=1380&t=st=1711867702~exp=1711868302~hmac=04eb0c3e333222f15f2869a3c1ccca29f09266b23dd17bd3f594a9ec39c52497"