export class ResourceConstants {
  static readonly TOPIC_ICONS = {
    video: $r('app.media.ic_video'),
    article: $r('app.media.ic_article'),
    quiz: $r('app.media.ic_quiz'),
    project: $r('app.media.ic_project')
  }

  static readonly STATUS_COLORS = {
    locked: '#999999',
    completed: '#4CAF50',
    inProgress: '#2196F3'
  }

  static getTopicIcon(type: string): Resource {
    return this.TOPIC_ICONS[type] || this.TOPIC_ICONS.article
  }
} 