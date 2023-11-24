import dataStorage from '@ohos.data.storage';
import featureAbility from '@ohos.ability.featureAbility'; // 用于获取文件存储路径
import { DialogComponent } from './DialogComponent';
import AccountData from '../viewmodel/AccountData';
import AccountTable from '../common/database/tables/AccountTable';
import Logger from '../common/utils/Logger';
import { ImageList } from '../viewmodel/AccountList';
import { CommonUtils } from '../common/utils/CommonUtils'
import CommonConstants from '../common/constant/CommonConstants';

@Entry
@Component
export struct home {
  @State accounts: Array<AccountData> = []; //展示在主页的数据

  @State dataDisplayTable: {title:string , week:string, dateValue:number ,projects:AccountData[]}[] = [];
  @State index: number = -1; //现在选中的选项
  @State newAccount: AccountData = {
    id: 0,
    accountType: 0,
    typeText: '',
    amount: 0,
    day: 0,
    month: 0,
    year: 0,
    date_string: ''
  };
  @State isInsert: boolean = false;
  @State date_value: DatePickerResult = {};
  private AccountTable = new AccountTable(() => {});
  @State date_content: string = '';
  @State isjizhang: boolean = false; //是否记账，点击记账按钮触发
  scroller: Scroller = new Scroller()
  @State isEdit: boolean = false;
  private deleteList: Array<AccountData> = [];
  private count: number = 0;
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DialogComponent({
      isInsert: $isInsert,
      date_content: $date_content,
      date_value: $date_value,
      newAccount: $newAccount,
      confirm: (isInsert: boolean, newAccount: AccountData) => this.accept(isInsert, newAccount)
    }),
    customStyle: true,
    alignment: DialogAlignment.Bottom
  });

  accept(isInsert: boolean, newAccount: AccountData): void {
    newAccount.day = this.date_value.day;
    newAccount.month = Number(this.date_value.month) + 1;
    newAccount.year = this.date_value.year;
    if (isInsert) {
      this.AccountTable.insertData(newAccount, (id: number) => {
        newAccount.id = id;
        this.accounts.push(newAccount);
        this.getDataDisplay(this.accounts);
      });
    } else {
      this.AccountTable.updateData(newAccount, () => {
        this.queryDataBase();
      });
    }
  }

  aboutToAppear() {
    let task = [];
    let flag:boolean = false;
       this.AccountTable.getRdbStore(() => {
         this.queryDataBase();
         if(!this.accounts.length){
           for (let i = 0;i < CommonConstants.InitData.length; i++) {
             let AcountData_new: AccountData = CommonConstants.InitData[i];
             let p = new Promise((resolve, reject)=>{
               this.AccountTable.insertData(AcountData_new, (id: number) => {resolve(id)});
             })
             task.push(p);
             if(task.length === CommonConstants.InitData.length ){
               Promise.all(task).then((values)=>{
                 this.queryDataBase();
               })
             }
           }
         }
       });

  }

  deleteListItem() {

    for (let i = 0; i < this.deleteList.length; i++) {
      let index = this.accounts.indexOf(this.deleteList[i]);
      this.accounts.splice(index, 1);
      this.AccountTable.deleteData(this.deleteList[i], () => {
      });
    }
    this.deleteList = [];
    this.isEdit = false;
  }

  getDateWeek(day:number , month:number, year:number){
    let temparray = ['星期一','星期二','星期三','星期四','星期五','星期六','星期日'];
    let tempweek = new Date(year,month,day).getDay()
    return temparray[tempweek];
  }
  getDateValue(day:number , month:number, year:number){
    let temp = year * 10000 + month * 100 + day;
    return temp;
  }

  getDataDisplay(data:AccountData[] ){

    this.dataDisplayTable = [];
    for(let i = 0;i < data.length;i++){
      let flag:number = 0;
      let j:number = 0;
      for(j = 0;j < this.dataDisplayTable.length;j++){
        if(this.dataDisplayTable[j].title === data[i].date_string ){

          this.dataDisplayTable[j].projects.push(data[i]);
          this.dataDisplayTable[j].week = this.getDateWeek(data[i].day,data[i].month,data[i].year);
          this.dataDisplayTable[j].dateValue = this.getDateValue(data[i].day,data[i].month,data[i].year);
          flag = 1;
          break;
        }
      }
      if(flag === 0 ){
        this.dataDisplayTable[j] = {title: data[i].date_string ,week:'',dateValue:0, projects:[] } ;
        this.dataDisplayTable[j].projects.push(data[i]);
        this.dataDisplayTable[j].week = this.getDateWeek(data[i].day,data[i].month,data[i].year);
        this.dataDisplayTable[j].dateValue = this.getDateValue(data[i].day,data[i].month,data[i].year);
      }

    }
  }

  queryDataBase(){
    this.AccountTable.query(0,(result: AccountData[])=>{
      result.sort((a,b)=>{
        let a1 = a.year*10000+ a.month*100 + a.day;
        let b1 = b.year*10000+ b.month*100 + b.day;
        return a1-b1;
      })
      this.accounts = result;

      if(result.length){
          this.getDataDisplay(result );
        }
    },true)

  }

  @Builder itemHead(text: string) {
    Row(){
      Text(text)
        .fontSize(15)
        .backgroundColor('#fff3edd0')
        .width("100%")
        .padding(3)
    }
  }

  @Builder itemFoot(num: number) {
    Row(){
      Text('共' + num + "条记录")
        .fontSize(12)
        .backgroundColor('#fff3edd0')
        .width("100%")
        .padding(3)
        .margin({right:30})
    }
    .justifyContent(FlexAlign.Start)
  }


  selectListItem(item: AccountData) {
    this.isInsert = false;
    this.index = this.accounts.indexOf(item);
    this.newAccount = {
      id: item.id,
      accountType: item.accountType,
      typeText: item.typeText,
      day: item.day,
      year: item.year,
      month: item.month,
      date_string:item.date_string,
      amount: item.amount
    };
  }


  build() {
    Column() {
      Column() {
        Column() {
          Row() {
            Image($r('app.media.shark_logo'))
              .height('40')
              .width('40')
              .margin({ left: 10, right: 60 })
            Text('鲨鱼记账')
              .fontSize(28)
          }
          .width('100%')
          .height('30%')
          Row() {
            Row() {
              Column() {
                Text('2023年')
                  .fontSize(20)
                Text('11月')
                  .fontSize(15)
                  .margin({ top: 10 })
              }
              .height('100%')
              .width('70')
              .alignItems(HorizontalAlign.Center)

              Divider()
                .margin({ left: 10 })
                .vertical(true)
                .color(Color.Black)
                .strokeWidth(1)
            }

            Column() {
              Text('收入')
                .fontSize(20)
              Text('11月')
                .fontSize(15)
                .margin({ top: 10 })
            }
            .width('20%')
            .height('100%')

            Column() {
              Text('支出')
                .fontSize(20)
              Text('11月')
                .fontSize(15)
                .margin({ top: 10 })
            }
            .width('20%')
            .height('100%')
          }
          .margin({ top: 10 })
          .justifyContent(FlexAlign.SpaceAround)
          .height(50)
          .width('100%')

          Row() {
            this.imageButton1('账单', $r('app.media.zhangdan'))
            this.imageButton1('预算', $r('app.media.yusuan'))
            this.imageButton1('记账', $r('app.media.jizhang_0'))

            this.imageButton1('资产', $r('app.media.zichan'))
            this.imageButton1('更多', $r('app.media.more'))


          }
          .margin({ top: 10 })
          .justifyContent(FlexAlign.SpaceAround)
          .height('70')
          .backgroundColor($r('app.color.start_window_background'))
          .width('95%')
          .borderWidth(1)
          .borderColor('#ffd4b7b7')
          .borderRadius(12)
          .shadow({ radius: 10, color: '#ffd4b7b7', offsetX: 5, offsetY: 5 })

        }
        .backgroundColor($r('app.color.main_yellow_background'))
        .justifyContent(FlexAlign.Start)
        .height('100%')
        .width('100%')
        .padding({ top: 15, right: 10, bottom: 10 })

      }
      .height('27%')


      Column() {
        List({ space: 20 }) {
          ForEach(this.dataDisplayTable, (item) => {
            ListItemGroup({ header:this.itemHead(item.title), footer:this.itemFoot(item.projects.length) }) {
              ForEach(item.projects, (project) => {
                ListItem() {
                  Row() {
                    Image(ImageList[project.typeText])
                      .width($r('app.float.component_size_M'))
                      .aspectRatio(CommonConstants.FULL_SIZE)
                      .margin({ right: $r('app.float.edge_size_MP') })

                    Text(project.typeText)
                      .height($r('app.float.component_size_SM'))
                      .fontSize($r('app.float.font_size_M'))

                    Blank()
                      .layoutWeight(1)

                    if (!this.isEdit) {
                      Text(project.accountType === 0 ? '-' + project.amount.toString() : '+' + project.amount.toString())
                        .fontSize($r('app.float.font_size_M'))
                        .fontColor(project.accountType === 0 ? '#ffdb3535' : $r('app.color.main_color'))
                        .align(Alignment.End)
                        .flexGrow(CommonConstants.FULL_SIZE)
                    }else {
                      Row() {
                        Toggle({ type: ToggleType.Checkbox })
                          .onChange((isOn) => {
                            if (isOn) {
                              this.deleteList.push(project);
                            } else {
                              let index = this.deleteList.indexOf(project);
                              this.deleteList.splice(index, 1);
                            }
                          })
                      }
                      .align(Alignment.End)
                      .flexGrow(CommonConstants.FULL_SIZE)
                      .justifyContent(FlexAlign.End)
                    }



                  }
                  .width(CommonConstants.FULL_WIDTH)
                  .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M') })
                }
                .width(CommonConstants.FULL_WIDTH)
                .backgroundColor('#fff8f1bd')
                .height($r('app.float.component_size_LM'))
                .onClick(() => {
                  this.selectListItem(project);
                  this.dialogController.open();
                })



              },(item)=>JSON.stringify(item))
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

  @Builder
  imageButton1(title: string, img: Resource) {
    Column() {
      Image(img).width(27).height(27)
      Text(title).fontSize(13).fontColor('#ff756565').margin({ top: 5 })
    }
    .onClick(() => {
      if (title === '记账') {
        //开启记账弹窗
        this.isInsert = true;
        this.dialogController.open();
        //....
      }
    })
  }
}

