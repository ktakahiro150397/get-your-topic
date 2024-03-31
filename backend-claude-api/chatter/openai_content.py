from abc import ABC, abstractmethod
import base64
import dataclasses
import os
from pathlib import Path
from typing import Optional




class OpenAIContentItemBase(ABC):
    role:str

    @abstractmethod
    def to_dict(self):
        pass


@dataclasses.dataclass
class OpenAIContentTextItem(OpenAIContentItemBase):
    text: str
    
    def to_dict(self):
        return {
            "type": "text",
            "text": self.text
        }

@dataclasses.dataclass
class OpenAIContentImageItem(OpenAIContentItemBase):
    file_name:Optional[Path]
    base64_file:str = ""
    
    def to_dict(self):
        if self.file_name != None:
            file_extension = self.file_name.suffix.replace(".", "")
            return {
                "type": "image_url",
                "image_url": {
                    "url":  self.encode_image_to_base64()
                }
            }
        else:
            return {
                "type": "image_url",
                "image_url": {
                    "url":  self.base64_file
                }
            }
    
    def encode_image_to_base64(self):
        with open(self.file_name, "rb") as image_file:
            encoded_string = base64.b64encode(image_file.read()).decode("utf-8")
            
        file_extension = self.file_name.suffix.replace(".", "")
        return f"data:image/{file_extension};base64,{encoded_string}"
    
@dataclasses.dataclass
class OpenAIContentMessageElement:
    role: str
    content: list[OpenAIContentItemBase]

@dataclasses.dataclass
class OpenAIContent:
    items:list[OpenAIContentMessageElement]

    def AddContent(self,role:str,text:str,file_name_list:list[Path]=[],base64_str:str="")->None:
        addItem = OpenAIContentMessageElement(role=role,content=[])

        if text != "":
            addItem.content.append(OpenAIContentTextItem(text=text))

        if base64_str != "":
            addItem.content.append(OpenAIContentImageItem(file_name=None,base64_file=base64_str))

        for file in file_name_list:
            addItem.content.append(OpenAIContentImageItem(file_name=file))
            
        
        self.items.append(addItem)
        
    def ClearItem(self)->None:
        self.items = []    
    
    def GetSendMessage(self):
        return [
            {
                "role": item.role,
                "content": [content.to_dict() for content in item.content]
            }
        for item in self.items
        ]
