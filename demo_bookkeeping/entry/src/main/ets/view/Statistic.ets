
import dataStorage from '@ohos.data.storage';
import featureAbility from '@ohos.ability.featureAbility'; // 用于获取文件存储路径
import { DialogComponent } from './DialogComponent';
import AccountData from '../viewmodel/AccountData';
import AccountTable from '../common/database/tables/AccountTable';
import Logger from '../common/utils/Logger';
import { ImageList } from '../viewmodel/AccountList';
import { CommonUtils } from '../common/utils/CommonUtils'
import CommonConstants from '../common/constant/CommonConstants';
import { LiteChart } from 'lite_chart'
import LinsChart from './test02';


@Entry
@Component
export struct statistic {

  @State message: string = 'Hello World'
  private time_temp = new Date();
  @State time: string = this.time_temp.getFullYear()+"年"+(this.time_temp.getMonth()+1)+"月"+this.time_temp.getDate()+"日"
  @State date: string = "2023年6月17日"
  @State week: string = "星期二"
  //
  @State dailyWorkOrderData: {}[] = [
    { "t": "订单数量", "n": "130" },
    { "t": "成交总金额", "n": "50" },
    { "t": "成交中位价", "n": "20" },
    { "t": "成交平均价", "n": "52" },
  ]
  @State info: object[] = [
    { name: "负责人", "message": "Spider-Man" },
    { "name": "值班人", "message": "洪金宝" }
  ]



  build() {

    Column() {
      //顶部
      Row() {
        // 左部文字
        Row() {
          Text(this.time)
            .fontColor(Color.White)
            .fontSize(20)
          Column() {
            Text(this.date).fontColor(Color.White)
            Text(this.week).fontColor(Color.White)
          }
          .alignItems(HorizontalAlign.Start)
        }.width(0)
        .flexGrow(1)
        .alignItems(VerticalAlign.Top)
        // .backgroundColor(Color.Yellow)

        Text("收入支出一览表")
          .fontColor(Color.White)
          .fontSize(30)
          .margin({top:20})
          .align(Alignment.Center | Alignment.Top)

        // 右边留白
        Row() {
        }.width(0)
        .flexGrow(1)

      }.width("100%")


      //中间
      Row() {
        // 中间左部
        Column() {
          Row() {
            Column() {
              Column() {
                Text("今日工单量统计")
                  .fontColor($r("app.color.text_h2"))
                  .width("100%")

                Row() {
                  ForEach(this.dailyWorkOrderData, (item) => {
                    Column() {
                      Text(item.t)
                        .fontSize(12)
                        .fontColor($r("app.color.text_h3"))
                      Text(item.n)
                        .fontColor($r("app.color.text_value"))
                    }
                    .width(0)
                    .flexGrow(1)
                    .alignItems(HorizontalAlign.Center)
                  })

                }
                .width("100%")

              }
              .width("100%")

              Column() {
                Text("单笔订单成交金额分布情况")
                  .fontColor($r("app.color.text_h2"))
                  .width("100%")
              }
              .height(0)
              .width("100%")
              .flexGrow(1)
            }
            .width(0)
            .height("100%")
            .flexGrow(3)


            Column() {
              Text("交易成交分布情况")
                .fontColor($r("app.color.text_h2"))
              Row() {
                Row() {
                  Image($r("app.media.map"))
                    .width("100%")

                }
                .alignItems(VerticalAlign.Center)
                .width(0)
                .height("100%")
                .flexGrow(1)

                LinsChart({
                  barChartStyle: "#2478F2"
                })
                  .width(0)
                  .height("100%")
                  .flexGrow(1)

              }.width("100%")
              .height(0)
              .flexGrow(1)

            }
            .width(0)
            .height("100%")
            .flexGrow(3)

          }.width("100%")
          .height(0)
          .flexGrow(2)

          Column() {
            Text("全年成交金额变化情况")
              .width("100%")
              .fontColor($r("app.color.text_h2"))
            SomeGraph({})

          }.width("100%")
          .height(0)
          .flexGrow(1)
          .padding(3)

        }
        .width(0)
        .height("100%")
        .flexGrow(2)

        // 中间右部分
        Column() {
          Column() {
            Text("成交排行TOP5")
              .fontColor($r("app.color.text_h2"))
              .width("100%")
            LinsChart({
              barChartStyle: "#2478F2"
            })
              .height(0)
              .width("100%")
              .flexGrow(1)

          }
          .width("100%")
          .height(0)

          Column() {
            Text("六日人流变化表")
              .fontColor($r("app.color.text_h2"))
              .width("100%")
            LinsChart({
              // 左边距
              margin_start: 20,
              axisWidth: 2,
              // 折线图
              linesWidth: 3,
              linesStyle: "#94C2EA",
              // 柱状图
              histogramStyle: "#D97559",
              histogramWidth: 0.6,
            })

          }
          .width("100%")
          .height(0)
          .flexGrow(1)
        }
        .width(0)
        .height("100%")
        .flexGrow(1)
        // .backgroundColor("#3300ff00")

      }.height(0)
      .width("100%")
      .flexGrow(0.7)

      //底部
      Row() {
        Column() {
          Text("月度工单完成量统计")
            .fontColor($r("app.color.text_h2"))
            .width("100%")
          LinsChart({
            // 左边距
            margin_start: 20,
            axisStyle: "#33ffffff",
            axisWidth: 2,
            // 折线图
            linesWidth: 3,
            linesStyle: "#94C2EA",
            // 柱状图
            histogramStyle: "#D97559",
            histogramWidth: 0.6,
          })


        }.height("100%")
        .width(0)
        .flexGrow(1)
        .padding(1)


        Column() {
          Text("责任信息")
            .fontColor($r("app.color.text_h2"))
            .width("100%")
          Row() {

            ForEach(this.info, (item: any, index: number) => {
              Column() {
                Text(item.name)
                  .fontColor(Color.White)
                Text(item.message)
                  .fontColor(Color.White)
              }.flexGrow(1)
              .height("100%")
              // .backgroundColor(Color.Red)
              // .width("100%")
            })
          }.width("100%")
          .flexGrow(1)
          // .backgroundColor(Color.Red)

        }
        .width(0)
        .height("100%")
        .flexGrow(1)
        .margin(1)

      }.width("100%")
      .height(80)

    }
    .backgroundColor("#09022C")
    .height('100%')
    .padding(10)
  }
}


@Component
struct SomeGraph {
  public values: number [][] = [
    [15, 88, 2, 77, 10, 10,],
    [93, 50, 94, 32, 67, 26,],
    [8, 97, 27, 55, 16, 63,],
    [28, 89, 27, 75, 36, 61,],
  ]
  /**
   * 线条颜色
   */
  public lineColor: string[] = [
    "#ff0000",
    "#00ff00",
    "#0000ff",
    "#ffff00",
  ]
  private cc: string = "#ffff00";

  build() {
    Stack() {
      ForEach(this.lineColor, (item, index) => {
        LinsChart({
          margin_start: 20,
          // 左边距
          axisStyle: "#33ffffff",
          axisWidth: 2,
          // 绘制曲线图
          graphStyle: item,
          values: this.values[index],
          maximum: 100

        })
      });
    }
  }
}