import { PathStage, PathTopic, LearningPathService } from '../model/LearningPathModel'

@Observed
export class PathStageViewModel {
  private stageData: PathStage
  isExpanded: boolean = false

  constructor(stage: PathStage) {
    this.stageData = stage
  }

  get id(): number {
    return this.stageData.id
  }

  get title(): string {
    return this.stageData.title
  }

  get description(): string {
    return this.stageData.description
  }

  get duration(): string {
    return this.stageData.duration
  }

  get status(): 'locked' | 'unlocked' | 'completed' {
    return this.stageData.status
  }

  get topics(): PathTopic[] {
    return this.stageData.topics
  }
}

@Observed
export class LearningPathViewModel {
  private learningPathService: LearningPathService = LearningPathService.getInstance()
  stages: PathStageViewModel[] = []
  currentLanguage: string = 'Python'
  selectedLanguageIndex: number = 0

  constructor() {
    this.loadStages(this.currentLanguage)
  }

  loadStages(language: string) {
    const stagesData = this.learningPathService.getLearningPath(language)
    this.stages = stagesData.map(stage => new PathStageViewModel(stage))
  }

  getSupportedLanguages(): string[] {
    return this.learningPathService.getSupportedLanguages()
  }

  getProgressStats(): { completed: number, total: number } {
    return this.learningPathService.getProgressStats(this.currentLanguage)
  }

  getProgressValue(): number {
    const stats = this.getProgressStats()
    return stats.total > 0 ? Math.round((stats.completed / stats.total) * 100) : 0
  }

  updateLanguage(index: number) {
    const languages = this.getSupportedLanguages()
    if (index >= 0 && index < languages.length) {
      this.selectedLanguageIndex = index
      this.currentLanguage = languages[index]
      this.loadStages(this.currentLanguage)
    }
  }
} 