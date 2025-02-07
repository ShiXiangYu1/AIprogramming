// 学习路径阶段类型定义
export interface PathStage {
  id: number
  title: string
  description: string
  duration: string // 预计学习时长
  status: 'locked' | 'unlocked' | 'completed' // 阶段状态
  topics: PathTopic[] // 包含的学习主题
}

// 学习主题类型定义
export interface PathTopic {
  id: number
  title: string
  description: string
  type: 'video' | 'article' | 'quiz' | 'project' // 内容类型
  completed: boolean
  duration: string // 预计完成时间
  content?: string // 内容链接或富文本
}

// 学习进度类型定义
export interface LearningProgress {
  userId: string
  languageId: number
  stageId: number
  topicId: number
  completed: boolean
  lastStudyTime: Date
}

// 学习路径服务类
export class LearningPathService {
  private static instance: LearningPathService
  private learningPaths: Map<string, PathStage[]> = new Map()
  private userProgress: LearningProgress[] = []

  private constructor() {
    // 初始化学习路径数据
    this.initLearningPaths()
  }

  public static getInstance(): LearningPathService {
    if (!LearningPathService.instance) {
      LearningPathService.instance = new LearningPathService()
    }
    return LearningPathService.instance
  }

  // 初始化学习路径数据
  private initLearningPaths() {
    // Python学习路径
    this.learningPaths.set('Python', [
      {
        id: 1,
        title: 'Python基础入门',
        description: '学习Python的基本语法和编程概念',
        duration: '2周',
        status: 'unlocked',
        topics: [
          {
            id: 101,
            title: 'Python环境搭建',
            description: '安装Python解释器和开发环境',
            type: 'video',
            completed: false,
            duration: '30分钟'
          },
          {
            id: 102,
            title: '变量和数据类型',
            description: '学习Python中的基本数据类型和变量使用',
            type: 'article',
            completed: false,
            duration: '1小时'
          }
        ]
      }
    ])

    // JavaScript学习路径
    this.learningPaths.set('JavaScript', [
      {
        id: 1,
        title: 'JavaScript基础',
        description: '学习JavaScript的基本语法和DOM操作',
        duration: '2周',
        status: 'unlocked',
        topics: [
          {
            id: 101,
            title: 'JavaScript简介',
            description: '了解JavaScript的历史和应用场景',
            type: 'video',
            completed: false,
            duration: '30分钟'
          }
        ]
      }
    ])
  }

  // 获取指定语言的学习路径
  public getLearningPath(language: string): PathStage[] {
    return this.learningPaths.get(language) || []
  }

  // 获取所有支持的编程语言
  public getSupportedLanguages(): string[] {
    return Array.from(this.learningPaths.keys())
  }

  // 更新主题完成状态
  public updateTopicStatus(language: string, stageId: number, topicId: number, completed: boolean) {
    const stages = this.learningPaths.get(language)
    if (stages) {
      const stage = stages.find(s => s.id === stageId)
      if (stage) {
        const topic = stage.topics.find(t => t.id === topicId)
        if (topic) {
          topic.completed = completed
          // TODO: 保存到持久化存储
        }
      }
    }
  }

  // 检查阶段是否已完成
  public isStageCompleted(stage: PathStage): boolean {
    return stage.topics.every(topic => topic.completed)
  }

  // 获取学习进度统计
  public getProgressStats(language: string): { completed: number, total: number } {
    const stages = this.learningPaths.get(language)
    if (!stages) {
      return { completed: 0, total: 0 }
    }

    let completed = 0
    let total = 0

    stages.forEach(stage => {
      stage.topics.forEach(topic => {
        total++
        if (topic.completed) {
          completed++
        }
      })
    })

    return { completed, total }
  }
} 