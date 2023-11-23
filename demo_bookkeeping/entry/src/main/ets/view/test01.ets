// xxx.ets
@Entry
@Component
struct ListItemGroupExample {
  private timetable: any = [
    {
      title:'星期一',
      projects:['语文', '数学', '英语']
    },
    {
      title:'星期二',
      projects:['物理', '化学', '生物']
    },
    {
      title:'星期三',
      projects:['历史', '地理', '政治']
    },
    {
      title:'星期四',
      projects:['美术', '音乐', '体育']
    }
  ]

  @Builder itemHead(text:string) {
    Text(text)
      .fontSize(20)
      .backgroundColor(0xAABBCC)
      .width("100%")
      .padding(10)
  }

  @Builder itemFoot(num:number) {
    Text('共' + num + "节课")
      .fontSize(16)
      .backgroundColor(0xAABBCC)
      .width("100%")
      .padding(5)
  }

  build() {
    Column() {
      List({ space: 20 }) {
        ForEach(this.timetable, (item) => {
          ListItemGroup({ header:this.itemHead(item.title), footer:this.itemFoot(item.projects.length) }) {
            ForEach(item.projects, (project) => {
              ListItem() {
                Text(project)
                  .width("100%").height(100).fontSize(20)
                  .textAlign(TextAlign.Center).backgroundColor(0xFFFFFF)
              }
            }, item => item)
          }
          .borderRadius(20)
          .divider({ strokeWidth: 1, color: Color.Blue }) // 每行之间的分界线
        })
      }
      .width('90%')
      .sticky(StickyStyle.Header|StickyStyle.Footer)
    }.width('100%').height('100%').backgroundColor(0xDCDCDC).padding({ top: 5 })
  }
}