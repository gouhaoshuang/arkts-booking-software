import prompt from '@ohos.promptAction';
import AccountData from '../viewmodel/AccountData';
import CommonUtils from '../common/utils/CommonUtils';
import AccountItem from '../viewmodel/AccountItem';
import CommonConstants from '../common/constant/CommonConstants';
import { PayList, EarnList } from '../viewmodel/AccountList';
import TextCommonWidget from './TextCommonWidget'



@CustomDialog
export struct DialogComponent {
  controller?: CustomDialogController;

  @Link date_content: string;
  @Link newAccount: AccountData;
  @Link date_value: DatePickerResult;
  @Link isInsert: boolean ;

  confirm?: (isInsert: boolean, newAccount: AccountData) => void;
  selectedDate: Date = new Date("2010-1-1")
  private inputAmount = '';
  private scroller: Scroller = new Scroller();
  @State curIndex: number = 0; //0:支付，1:收入
  @State curType: string = ''; //目前的种类：食物。。// 。


  selectAccount(item: AccountItem) {
    this.newAccount.accountType = item.accountType;
    this.newAccount.typeText = item.typeText;
    this.curType = item.typeText;
  }

  aboutToAppear() {
    this.inputAmount = this.newAccount.amount.toString();
    this.curIndex = this.newAccount.accountType;
    this.curType = this.newAccount.typeText;
  }

  @Builder
  TabBuilder(index: number) {
    Column() {
      Text(index === 0 ? '支付' : '收入')
        .fontSize(16)
        .fontColor(this.curIndex === index ? Color.Blue : Color.Gray)
    }
    .width(48)
    .padding({ top: $r('app.float.edge_size_LM'), bottom: $r('app.float.edge_size_S') })
    .margin({ bottom: $r('app.float.edge_size_S') })
    .border(this.curIndex === index ? {
                                        width: { bottom: 2 },
                                        color: Color.Blue
                                      } : { color: Color.White })

  }

  build() {
    Column() {
      Image($rawfile('half.png'))
        .width(64)
        .height(24)
        .onClick(() => {
          this.controller?.close();
        })
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          Scroll(this.scroller) {
            Row() {
              ForEach(PayList, (item: AccountItem) => {
                Column() {
                  Image(this.curType === item.typeText ? item.iconSelected : item.icon)
                    .width(40)
                    .aspectRatio(1)

                  Text(item.typeText)
                    .fontSize(12)
                    .fontColor(this.curType === item.typeText ? Color.White : Color.Blue)
                    .margin({ top: 8 })
                }
                .width(86)
                .aspectRatio(1)
                .padding({ top: 12 })
                .margin({ top: $r('app.float.edge_size_MP'), left: $r('app.float.edge_size_M') })
                .align(Alignment.TopStart)
                .backgroundColor(this.curType === item.typeText ? Color.Blue : $r('app.color.background_color'))
                .borderRadius($r('app.float.radius_size_S'))
                .onClick(() => {
                  this.selectAccount(item);
                })
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
        .tabBar(this.TabBuilder(0))
        .margin({ bottom: 36 })

        TabContent() {
          Scroll(this.scroller) {
            Row() {
              ForEach(EarnList, (item: AccountItem) => {
                Column() {
                  Image(this.curType === item.typeText ? item.iconSelected : item.icon)
                    .width($r('app.float.image_size'))
                    .aspectRatio(CommonConstants.FULL_SIZE)

                  Text(item.typeText)
                    .fontSize($r('app.float.font_size_S'))
                    .fontColor(this.curType === item.typeText ? Color.White : $r('app.color.main_color'))
                    .margin({ top: $r('app.float.edge_size_S') })
                }
                .width($r('app.float.component_size_LP'))
                .aspectRatio(CommonConstants.FULL_SIZE)
                .padding({ top: $r('app.float.edge_size_M') })
                .margin({ top: $r('app.float.edge_size_MP'), left: $r('app.float.edge_size_M') })
                .align(Alignment.TopStart)
                .backgroundColor(this.curType === item.typeText ? $r('app.color.main_color') : $r('app.color.background_color'))
                .borderRadius($r('app.float.radius_size_S'))
                .onClick(() => {
                  this.selectAccount(item);
                })
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
        .tabBar(this.TabBuilder(1))
        .margin({ bottom: $r('app.float.edge_size_LP') })
      }
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.TABS_HEIGHT)
      .vertical(false)
      .barMode(BarMode.Fixed)
      .onChange((index) => {
        this.curIndex = index;
      })

      TextCommonWidget({
        textImage: $r('app.media.date_01'),
        title: '选择时间',
        content: $date_content,
        onItemClick: () => {
          CommonUtils.datePickerDialog((date_content_string: string, date_value: DatePickerResult) => {
            this.date_content = date_content_string;
            this.date_value = date_value;
            this.newAccount.date_string = date_content_string;
          });
        }
      })

      Column() {
        TextInput({
          placeholder: '请输入金额',
        })
          .borderRadius(12)
          .backgroundColor(Color.White)
          .type(InputType.Number)
          .backgroundColor('#fff1e94f')
          .onChange((value: string) => {
            this.inputAmount = value;
          })
      }
      .margin({top:12})
      .borderRadius($r('app.float.row_radius'))
      .backgroundColor('#fff1e94f')
      .justifyContent(FlexAlign.Center)
      .width('93.3%')
      .height(60)

      Column() {
        Button() {
          Text('确定')
            .fontSize($r('app.float.font_size_M'))
            .fontColor(Color.Green)
        }
        .width('93.33%')
        .backgroundColor('#fff1e94f')
        .height($r('app.float.component_size_M'))
        .onClick(() => {
          if (this.newAccount.typeText === '' || this.curIndex !== this.newAccount.accountType) {
            prompt.showToast({ message: CommonConstants.TOAST_TEXT_1, bottom: CommonConstants.PROMPT_BOTTOM });
          } else {
            let regex: RegExp = new RegExp('[1-9][0-9]*');
            let matchValue: Array<string> | null = this.inputAmount.match(regex);
            if (matchValue !== null && matchValue[0] === this.inputAmount) {
              this.newAccount.amount = Number(this.inputAmount);

              this.confirm && this.confirm(this.isInsert, this.newAccount);
              this.controller?.close();
            } else {
              prompt.showToast({ message: CommonConstants.TOAST_TEXT_2, bottom: CommonConstants.PROMPT_BOTTOM });
            }
          }
        })
      }
      .margin({top:12})
      .justifyContent(FlexAlign.End)



    }
    .width('100%')
    .height('55%')
    .borderRadius({ topLeft: 24, topRight: 24 })
    .backgroundColor(Color.White)
    .align(Alignment.BottomEnd)

  }
}



