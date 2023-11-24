@Entry
@Component
struct CanvasExample1 {
  //用来配置CanvasRenderingContext2D对象的参数，包括是否开启抗锯齿，true表明开启抗锯齿。
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  //用来创建CanvasRenderingContext2D对象，通过在canvas中调用CanvasRenderingContext2D对象来绘制。
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      //在canvas中调用CanvasRenderingContext2D对象。
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor('#F5DC62')
        .onReady(() => {
          //可以在这里绘制内容。
          this.context.strokeRect(50, 50, 200, 150);
        })
    }
    .width('100%')
    .height('100%')
  }
}

