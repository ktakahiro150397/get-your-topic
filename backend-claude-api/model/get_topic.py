from typing import Optional
from pydantic import BaseModel,Field


class GetTopicRequestItem(BaseModel):
    apikey: str = Field(title="API Key",
                        description="レスポンスを取得するためのAPIキー。")
    prompt: str = Field(title="Topic Prompt", 
                        description="話題が欲しい状況を説明するプロンプト。", 
                        example="上司と2人きりで繁華街を歩いています。周りは賑やかで様々な店がありますが、特に話題がありません。")
    picture_base64: Optional[str] = Field(default="", title="Base64 Encoded Picture",
                                          description="話題が欲しい状況の画像をBase64エンコードした文字列。",)
    dry_run: Optional[bool] = Field(default=False, title="Dry Run",
                                    description="Trueの場合、実際にAPIを呼び出さず、テスト用のレスポンスを返します。")