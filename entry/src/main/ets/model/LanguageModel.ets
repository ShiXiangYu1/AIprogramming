// 编程语言类型定义
export interface Language {
  id: number
  name: string
  icon: Resource
  description: string
  features: string[]
  difficulty: 'easy' | 'medium' | 'hard'
}

// 编程语言数据
export const LANGUAGES: Language[] = [
  {
    id: 1,
    name: 'Python',
    icon: $r('app.media.python'),
    description: '简单易学的全能型编程语言，适合初学者',
    features: ['Web开发', '人工智能', '数据科学', '自动化脚本'],
    difficulty: 'easy'
  },
  {
    id: 2,
    name: 'JavaScript/TypeScript',
    icon: $r('app.media.javascript'),
    description: '前端开发必备语言，支持全栈开发',
    features: ['前端开发', 'Node.js后端', '跨平台应用'],
    difficulty: 'medium'
  },
  {
    id: 3,
    name: 'Java',
    icon: $r('app.media.java'),
    description: '企业级应用首选语言，Android开发必备',
    features: ['Android开发', '企业应用', '微服务'],
    difficulty: 'medium'
  },
  {
    id: 4,
    name: 'Go',
    icon: $r('app.media.golang'),
    description: '高性能服务器开发语言，云原生首选',
    features: ['云原生', '高性能服务器', '微服务'],
    difficulty: 'medium'
  },
  {
    id: 5,
    name: 'Rust',
    icon: $r('app.media.rust'),
    description: '系统级编程语言，注重性能与安全',
    features: ['系统编程', 'WebAssembly', '高性能计算'],
    difficulty: 'hard'
  }
] 