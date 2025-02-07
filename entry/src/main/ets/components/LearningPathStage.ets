import { PathTopic } from '../model/LearningPathModel'
import { PathStageViewModel } from '../viewmodel/LearningPathViewModel'
import { ResourceConstants } from '../constants/ResourceConstants'

@Component
export struct LearningPathStage {
  @ObjectLink stageVM: PathStageViewModel

  @Builder
  TopicItem(topic: PathTopic) {
    Row() {
      // 主题类型图标
      Image(ResourceConstants.getTopicIcon(topic.type))
        .width(24)
        .height(24)
        .margin({ right: 12 })
        .fillColor(topic.completed ? ResourceConstants.STATUS_COLORS.completed : '#666666')

      // 主题内容
      Column() {
        Text(topic.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
        Text(topic.description)
          .fontSize(14)
          .fontColor($r('app.color.secondary_text'))
          .margin({ top: 4 })
      }
      .layoutWeight(1)

      // 完成状态和时长
      Column() {
        Text(topic.completed ? '已完成' : '未完成')
          .fontSize(12)
          .fontColor(topic.completed ? ResourceConstants.STATUS_COLORS.completed : '#999999')
        Text(`预计${topic.duration}`)
          .fontSize(12)
          .fontColor($r('app.color.secondary_text'))
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .margin({ top: 8 })
    .onClick(() => {
      // TODO: 跳转到具体的学习内容
    })
  }

  build() {
    Column() {
      // 阶段标题栏
      Row() {
        Column() {
          Text(this.stageVM.title)
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
          Text(this.stageVM.description)
            .fontSize(14)
            .fontColor($r('app.color.secondary_text'))
            .margin({ top: 4 })
        }
        .layoutWeight(1)

        Column() {
          Text(`预计时长：${this.stageVM.duration}`)
            .fontSize(14)
            .fontColor($r('app.color.secondary_text'))
          Row() {
            Text(this.stageVM.status === 'locked' ? '未解锁' : 
                 this.stageVM.status === 'completed' ? '已完成' : '进行中')
              .fontSize(12)
              .fontColor(this.stageVM.status === 'locked' ? ResourceConstants.STATUS_COLORS.locked : 
                        this.stageVM.status === 'completed' ? ResourceConstants.STATUS_COLORS.completed : 
                        ResourceConstants.STATUS_COLORS.inProgress)
          }
          .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')
      .padding(16)
      .backgroundColor($r('app.color.card_background'))
      .borderRadius(8)
      .onClick(() => {
        if (this.stageVM.status !== 'locked') {
          this.stageVM.isExpanded = !this.stageVM.isExpanded
        }
      })

      // 学习主题列表
      if (this.stageVM.status !== 'locked' && this.stageVM.isExpanded) {
        Column() {
          ForEach(this.stageVM.topics, (topic: PathTopic) => {
            this.TopicItem(topic)
          })
        }
        .margin({ top: 8 })
      }
    }
    .margin({ bottom: 16 })
  }
} 