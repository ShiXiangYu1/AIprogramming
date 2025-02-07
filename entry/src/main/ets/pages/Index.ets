import { Language, LANGUAGES } from '../model/LanguageModel'
import { AIService } from '../services/AIService'
import { PathStage, PathTopic, LearningPathService } from '../model/LearningPathModel'
import { LearningPathStage } from '../components/LearningPathStage'
import { LearningPathViewModel } from '../viewmodel/LearningPathViewModel'

// 定义颜色常量
const DIFFICULTY_COLORS = {
  easy: {
    text: '#00796B',
    bg: '#E0F2F1'
  },
  medium: {
    text: '#F57C00',
    bg: '#FFF3E0'
  },
  hard: {
    text: '#D32F2F',
    bg: '#FFEBEE'
  }
}

@Entry
@Component
struct Index {
  // 状态变量
  @State currentIndex: number = 0
  @State isDarkMode: boolean = false
  @State languages: Language[] = LANGUAGES
  @State filteredLanguages: Language[] = LANGUAGES
  @State selectedDifficulty: string = '全部'
  @State searchKey: string = ''
  @State queryInput: string = ''
  @State queryResult: string = ''
  @State isQuerying: boolean = false
  @State quickStartPressed: boolean = false
  @State continueStudyPressed: boolean = false
  @State currentLanguage: string = 'Python'
  @State stages: PathStage[] = LearningPathService.getInstance().getLearningPath('Python')
  @State selectedLanguageIndex: number = 0
  private aiService: AIService = AIService.getInstance()
  private learningPathVM: LearningPathViewModel = new LearningPathViewModel()

  // 搜索和筛选方法
  filterLanguages() {
    this.filteredLanguages = this.languages.filter(lang => {
      const matchSearch = this.searchKey === '' || 
        lang.name.toLowerCase().includes(this.searchKey.toLowerCase()) ||
        lang.description.toLowerCase().includes(this.searchKey.toLowerCase()) ||
        lang.features.some(f => f.toLowerCase().includes(this.searchKey.toLowerCase()))
      
      const matchDifficulty = this.selectedDifficulty === '全部' ||
        (this.selectedDifficulty === '入门' && lang.difficulty === 'easy') ||
        (this.selectedDifficulty === '进阶' && lang.difficulty === 'medium') ||
        (this.selectedDifficulty === '高级' && lang.difficulty === 'hard')
      
      return matchSearch && matchDifficulty
    })
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('AI编程学习助手')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.isDarkMode })
          .onChange((isOn: boolean) => {
            this.isDarkMode = isOn
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.primary_background'))

      // 主要内容区域
      Row() {
        // 左侧菜单
        Column() {
          Button('首页')
            .width('100%')
            .margin({ top: 8 })
            .onClick(() => this.currentIndex = 0)
          Button('编程语言')
            .width('100%')
            .margin({ top: 8 })
            .onClick(() => this.currentIndex = 1)
          Button('学习路径')
            .width('100%')
            .margin({ top: 8 })
            .onClick(() => this.currentIndex = 2)
          Button('练习项目')
            .width('100%')
            .margin({ top: 8 })
            .onClick(() => this.currentIndex = 3)
        }
        .width('20%')
        .height('100%')
        .padding(8)
        .backgroundColor($r('app.color.secondary_background'))

        // 右侧内容区
        Column() {
          if (this.currentIndex === 0) {
            this.HomeContent()
          } else if (this.currentIndex === 1) {
            this.LanguagesContent()
          } else if (this.currentIndex === 2) {
            this.LearningPathContent()
          } else {
            this.ProjectsContent()
          }
        }
        .width('80%')
        .height('100%')
        .padding(16)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  HomeContent() {
    Scroll() {
      Column() {
        Text('欢迎使用AI编程学习助手')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 16 })
        
        Text('开始您的编程学习之旅')
          .fontSize(16)
          .margin({ bottom: 24 })

        // AI查询部分
        Column() {
          Text('AI编程知识查询')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 16 })

          Row() {
            TextArea({ placeholder: '请输入您的编程问题...', text: this.queryInput })
              .height(120)
              .layoutWeight(1)
              .margin({ right: 16 })
              .onChange((value: string) => {
                this.queryInput = value
              })

            Button('查询')
              .height(40)
              .enabled(!this.isQuerying)
              .onClick(async () => {
                if (this.queryInput.trim()) {
                  try {
                    this.isQuerying = true
                    this.queryResult = await this.aiService.queryKnowledge(this.queryInput)
                  } catch (error) {
                    this.queryResult = '查询失败，请稍后重试'
                  } finally {
                    this.isQuerying = false
                  }
                }
              })
          }
          .width('100%')
          .margin({ bottom: 16 })

          if (this.isQuerying) {
            LoadingProgress()
              .width(30)
              .height(30)
              .margin({ bottom: 16 })
          }

          if (this.queryResult) {
            Column() {
              Text('AI回答：')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 8 })
              
              Text(this.queryResult)
                .fontSize(14)
                .fontColor($r('app.color.secondary_text'))
            }
            .width('100%')
            .padding(16)
            .backgroundColor($r('app.color.secondary_background'))
            .borderRadius(8)
          }
        }
        .width('100%')
        .margin({ bottom: 32 })

        // 快速入口卡片
        Row() {
          Column() {
            Text('快速开始')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
            Text('选择编程语言开始学习')
              .fontSize(14)
              .margin({ top: 8 })
          }
          .width('30%')
          .padding(16)
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(8)
          .margin({ right: 16 })
          .onClick(() => {
            this.currentIndex = 1  // 切换到编程语言页面
          })
          .opacity(this.quickStartPressed ? 0.7 : 1)
          .scale({
            x: this.quickStartPressed ? 0.98 : 1,
            y: this.quickStartPressed ? 0.98 : 1
          })
          .animation({
            duration: 250,
            curve: Curve.EaseInOut
          })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.quickStartPressed = true
            } else if (event.type === TouchType.Up) {
              this.quickStartPressed = false
            }
          })

          Column() {
            Text('继续学习')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
            Text('上次学习：Python基础')
              .fontSize(14)
              .margin({ top: 8 })
          }
          .width('30%')
          .padding(16)
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(8)
          .onClick(() => {
            // 获取最近学习的语言ID
            const pythonLanguage = this.languages.find(lang => lang.name === 'Python')
            if (pythonLanguage) {
              // TODO: 跳转到Python详情页
              this.currentIndex = 1  // 暂时先切换到编程语言页面
            }
          })
          .opacity(this.continueStudyPressed ? 0.7 : 1)
          .scale({
            x: this.continueStudyPressed ? 0.98 : 1,
            y: this.continueStudyPressed ? 0.98 : 1
          })
          .animation({
            duration: 250,
            curve: Curve.EaseInOut
          })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.continueStudyPressed = true
            } else if (event.type === TouchType.Up) {
              this.continueStudyPressed = false
            }
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .padding(16)
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
  }

  @Builder
  LanguageCard(language: Language) {
    Column() {
      Row() {
        Image(language.icon)
          .width(40)
          .height(40)
          .margin({ right: 16 })
        Column() {
          Text(language.name)
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
          Text(language.description)
            .fontSize(14)
            .fontColor($r('app.color.secondary_text'))
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        
        Text(language.difficulty)
          .fontSize(14)
          .fontColor(this.getDifficultyColor(language.difficulty))
          .backgroundColor(this.getDifficultyBgColor(language.difficulty))
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(4)
      }
      .width('100%')
      .padding(16)

      Row() {
        ForEach(language.features, (feature: string) => {
          Text(feature)
            .fontSize(12)
            .fontColor($r('app.color.secondary_text'))
            .backgroundColor($r('app.color.secondary_background'))
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(4)
            .margin({ right: 8 })
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 16 })
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(8)
    .margin({ bottom: 16 })
    .onClick(() => {
      // TODO: 跳转到语言详情页
    })
  }

  getDifficultyColor(difficulty: string): string {
    switch (difficulty) {
      case 'easy':
        return DIFFICULTY_COLORS.easy.text
      case 'medium':
        return DIFFICULTY_COLORS.medium.text
      case 'hard':
        return DIFFICULTY_COLORS.hard.text
      default:
        return '#000000'
    }
  }

  getDifficultyBgColor(difficulty: string): string {
    switch (difficulty) {
      case 'easy':
        return DIFFICULTY_COLORS.easy.bg
      case 'medium':
        return DIFFICULTY_COLORS.medium.bg
      case 'hard':
        return DIFFICULTY_COLORS.hard.bg
      default:
        return '#F5F5F5'
    }
  }

  @Builder
  LanguagesContent() {
    Column() {
      Text('编程语言')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 24 })

      // 搜索栏
      TextInput({ placeholder: '搜索编程语言...', text: this.searchKey })
        .width('100%')
        .height(40)
        .margin({ bottom: 16 })
        .onChange((value: string) => {
          this.searchKey = value
          this.filterLanguages()
        })

      // 难度过滤按钮组
      Row() {
        ForEach(['全部', '入门', '进阶', '高级'], (difficulty: string) => {
          Button({ type: this.selectedDifficulty === difficulty ? ButtonType.Normal : ButtonType.Capsule, stateEffect: true }) {
            Text(difficulty)
              .fontSize(14)
              .fontColor(this.selectedDifficulty === difficulty ? Color.White : '#666666')
          }
          .margin({ right: 8 })
          .backgroundColor(this.selectedDifficulty === difficulty ? '#2196F3' : '#F5F5F5')
          .onClick(() => {
            this.selectedDifficulty = difficulty
            this.filterLanguages()
          })
        })
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 语言列表
      List() {
        ForEach(this.filteredLanguages, (language: Language) => {
          ListItem() {
            this.LanguageCard(language)
          }
        }, language => language.id.toString())
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }

  @Builder
  LearningPathContent() {
    Column() {
      // 顶部标题
      Text('学习路径')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 24 })

      // 选择语言下拉框
      Row() {
        Text('选择编程语言：')
          .fontSize(16)
          .margin({ right: 8 })
        
        Select(this.learningPathVM.getSupportedLanguages().map(lang => ({
          value: lang,
          text: lang
        })))
          .selected(this.learningPathVM.selectedLanguageIndex)
          .value(this.learningPathVM.currentLanguage)
          .width(200)
          .onSelect((index: number) => {
            this.learningPathVM.updateLanguage(index)
          })
      }
      .margin({ bottom: 24 })

      // 学习进度
      Row() {
        Progress({
          value: this.learningPathVM.getProgressValue(),
          total: 100,
          type: ProgressType.Ring
        })
          .width(60)
          .height(60)
          .margin({ right: 16 })

        Column() {
          Text('学习进度')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          Text(`${this.learningPathVM.getProgressValue()}% 完成`)
            .fontSize(14)
            .fontColor($r('app.color.secondary_text'))
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
      }
      .margin({ bottom: 24 })

      // 学习路径列表
      List() {
        ForEach(this.learningPathVM.stages, (stage) => {
          ListItem() {
            LearningPathStage({ stageVM: stage })
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }

  @Builder
  ProjectsContent() {
    Column() {
      Text('练习项目')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
      // 待实现：项目列表
    }
  }
}