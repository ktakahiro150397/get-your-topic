
from pathlib import Path
from typing import Dict, List

from anthropic import AsyncMessageStream
from chatter.chat_interface import chat_interface
import os
from openai import OpenAI

from chatter.claude_content import ClaudeContent
from chatter.openai_content import OpenAIContent

class OpenAIChatter(chat_interface):
    def __init__(self,api_key:str,
                 model:str="gpt-4-vision-preview",
                 max_tokens:int=1024,
                 temperature:int=0,
                 system_role:str="")->None:
        self.clients:Dict[str,OpenAI] = {}
        self.contents:Dict[str,OpenAIContent] = {}
        
        self.max_tokens = max_tokens
        self.api_key = api_key
        self.model = model
        self.temperature = temperature
        self.system_role = system_role


    def __add_client(self,memory_id:str)->None:
        if memory_id not in self.clients:
            self.clients[memory_id] = OpenAI(api_key=self.api_key)
        if memory_id not in self.contents:
            self.contents[memory_id] = OpenAIContent(items=[])

    async def chat(self,memory_id:str,message:str,base64_str:str="")->str:
        self.__add_client(memory_id)
        
        # メッセージ追加
        self.contents[memory_id].AddContent(role="system",text=self.system_role)
        self.contents[memory_id].AddContent(role="user",text=message,base64_str=base64_str)
        
        # ChatGPTから返答を取得
        messages = self.contents[memory_id].GetSendMessage()
        
        message = self.clients[memory_id].chat.completions.create(
            model=self.model,
            messages=messages,
            max_tokens=self.max_tokens,
            temperature=self.temperature,
        )
        
        # メッセージ履歴をクリア
        self.clear_history(memory_id)
        
        return message.choices[0].message.content
        
        # 返答を追加
        #self.contents[memory_id].AddTextContent(role="assistant",content=message.content[0].text)
        
    
    async def chat_stream(self,memory_id:str,message:str,files:List[Path]=[])->AsyncMessageStream:
        self.__add_client(memory_id)

        # メッセージ追加
        self.contents[memory_id].AddContent(role="user",text=message,file_name_list=files)

        message = self.contents[memory_id].GetSendMessage()

        stream = await self.clients[memory_id].messages.stream(
            max_tokens=self.max_tokens,
            temperature=self.temperature,
            messages=message,
            model="claude-3-opus-20240229",
            system=self.system_role,
        ).__aenter__()

        return stream
    
    def add_history(self,memory_id:str,role:str,message:str)->None:
        self.__add_client(memory_id)
        self.contents[memory_id].AddContent(role=role,text=message)
    
    async def clear_history(self,memory_id:str)->str:
        self.__add_client(memory_id)
        self.contents[memory_id].ClearItem()
        
        return "チャット履歴をクリアしました。"
    