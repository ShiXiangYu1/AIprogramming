import http from '@ohos.net.http';

export class AIService {
  private static instance: AIService;
  private readonly apiKey: string = 'sk-0183ba485c32434b9b3f9a852fe7bd6e';
  private readonly baseUrl: string = 'https://api.deepseek.com/v1';

  private constructor() {}

  public static getInstance(): AIService {
    if (!AIService.instance) {
      AIService.instance = new AIService();
    }
    return AIService.instance;
  }

  // 查询编程知识
  async queryKnowledge(query: string): Promise<string> {
    try {
      let httpRequest = http.createHttp();
      let response = await httpRequest.request(
        this.baseUrl + '/chat/completions',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.apiKey}`
          },
          extraData: JSON.stringify({
            model: 'deepseek-chat',
            messages: [
              {
                role: 'system',
                content: '你是一个专业的编程导师，请用简洁专业的方式回答编程相关问题。'
              },
              {
                role: 'user',
                content: query
              }
            ],
            temperature: 0.7,
            max_tokens: 1000
          })
        }
      );

      if (response.responseCode === 200) {
        let result = JSON.parse(response.result.toString());
        return result.choices[0].message.content;
      } else {
        throw new Error('API请求失败：' + response.responseCode);
      }
    } catch (error) {
      console.error('查询失败：', error);
      throw error;
    }
  }
} 