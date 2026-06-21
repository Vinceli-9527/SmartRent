export class DiscoverArticle {
  id: string = ''
  title: string = ''
  cover: string = ''
  summary: string = ''
  author: string = ''
  publishTime: string = ''
  viewCount: number = 0
  likeCount: number = 0
  tags: string[] = []
}

export class DiscoverData {
  articles: DiscoverArticle[] = []
  hotTags: string[] = []
}
