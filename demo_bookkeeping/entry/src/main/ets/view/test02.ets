
@Component
export default struct LinsChart {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  // 底部边距
  public margin_bottom: number = 0.15
  // 开始位置边距
  public margin_start: number = 0.1

  /**
   * # 线条类型
   * - 'butt'：线端点以方形结束。
   * - 'round'：线端点以圆形结束。
   * - 'square'：线端点以方形结束，
   */
  public lineCap: CanvasLineCap = 'round'

  //所绘制的数据
  public values: number[] = [40, 50, 0, 100, 10]

  /**
   * 最大端点数
   */
  public pointMax: number = 5
  /**
   * 所需要绘制的最大值
   */
  public maximum: number = 100
  // 绘制线条的宽度
  public linesWidth: number = 6

  // 绘制坐标轴的线条宽度
  public axisWidth: number = 6
  // 绘制坐标轴的样式
  public axisStyle: string | CanvasGradient | CanvasPattern = undefined

  // 折线图颜色
  public linesStyle: string | CanvasGradient | CanvasPattern = undefined

  // 绘制矩形的颜色
  public histogramStyle: string | CanvasGradient | CanvasPattern = undefined
  // 柱状图的宽度
  public histogramWidth: number = 0.3


  // 曲线图所用样式
  public graphStyle: string | CanvasGradient | CanvasPattern = undefined

  // 条形图样式
  public barChartStyle: string | CanvasGradient | CanvasPattern = undefined
  // 条形图的宽度
  public barWidth: number = 0.7;

  build() {
    Stack() {

      Canvas(this.context)
        .width('100%')
        .height('100%')
        .onReady(this.onDraw)

    }
    .width("100%")
    .height("100%")
  }

  private onDraw = () => {
    this.context.lineCap = this.lineCap;
    //可供绘图的区域参数
    let width = this.context.width;
    let height = this.context.height;

    //用来绘制图表的矩形参数
    let top = 0
    let bottom = height - (this.margin_bottom * height);
    let left = this.margin_start >= 1 ? this.margin_start : (this.margin_start * width);

    let right = width
    let rectW = right - left;
    let rectH = bottom - top;


    // 绘制坐标轴
    if (this.axisStyle != undefined) {
      this.context.beginPath();
      // 设置绘制坐标轴的线条宽度
      this.context.lineWidth = this.axisWidth;
      // 设置绘制坐标轴的颜色
      this.context.strokeStyle = this.axisStyle;
      // 绘制y轴
      this.context.moveTo(left, 0);
      this.context.lineTo(left, height);
      // 绘制x轴
      this.context.moveTo(0, bottom);
      this.context.lineTo(width, bottom);
      // 结束绘制
      this.context.stroke();
    }


    // X轴所需绘制点的横向间隔
    let xInterval = rectW / this.pointMax;

    //用于在图表中计算y值的函数
    let gety = (d: number) => {
      return rectH * (1 - d / this.maximum)
      // return 10;
    };
    //用于在图标中计算x值的函数
    let getx: (i: number) => number = (i) => {
      //向右偏移  量
      let p: number = xInterval / 2;
      return left + p + xInterval * i
    };


    //绘制柱状图
    if (this.histogramStyle != undefined) {

      this.context.fillStyle = this.histogramStyle;
      // 开始绘制图标主题
      this.context.beginPath();
      this.values.forEach((value: number, index: number) => {
        //如果没有超过绘制的最大数目
        if (index < this.pointMax) {

          let w = xInterval / 2 * this.histogramWidth;
          let x = getx(index) - w / 2;
          let y = gety(value);

          this.context.fillRect(x, y, w, bottom - y);
          this.context.fillRect(x, y, w, bottom - y);
        }
      });
      // 结束绘制
      this.context.stroke();
    }

    //绘制折线图
    if (this.linesStyle != undefined) {
      // 设置绘制线条的宽度
      this.context.lineWidth = this.linesWidth;
      // 设置折线图颜色
      this.context.strokeStyle = this.linesStyle;
      // 开始绘制图标
      this.context.beginPath();
      this.values.forEach((value: number, index: number) => {
        //如果没有超过绘制的最大数目
        if (index < this.pointMax) {
          let x = getx(index);
          let y = gety(value);
          if (index == 0)
            this.context.moveTo(x, y);
          else
            this.context.lineTo(x, y)
        }
      });
      // 结束绘制折线图
      this.context.stroke();
    }


    // 绘制曲线图
    if (this.graphStyle != undefined) {
      // 设置绘制曲线图的颜色
      this.context.strokeStyle = this.graphStyle;
      // 开始绘制图标主题
      this.context.beginPath();
      let lastY = 0;
      this.values.forEach((value: number, index: number) => {
        //如果没有超过绘制的最大数目
        if (index < this.pointMax) {
          let x = getx(index);
          let y = gety(value);
          let x1 = x - xInterval / 2;
          let y1 = lastY;
          let x2 = x + -xInterval / 2;
          let y2 = y;
          if (index == 0)
            this.context.moveTo(x, y);
          else
            this.context.bezierCurveTo(x1, y1, x2, y2, x, y)
          lastY = y
        }
      });
      // 结束绘制折线图
      this.context.stroke();
    }

    // 绘制条形图 , PS条形图的X、Y与其他图不一样，所以需要单独维护
    if (this.barChartStyle != undefined) {
      this.context.fillStyle = this.barChartStyle
      // "#33ff0000"
      this.values.forEach((value: number, index: number) => {
        if (index < this.pointMax) {
          let x: number = rectW * (value / this.maximum);
          let yInterval = bottom / (this.pointMax + 1);
          let y: number = yInterval / 2 + yInterval * index;
          let yw = this.barWidth > 1 ? this.barWidth : yInterval * this.barWidth;
          y += 0.5 * yw
          this.context.fillRect(left, y, x, yw)
        }
      })
    }



  }
}

