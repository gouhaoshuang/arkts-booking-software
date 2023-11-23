import CommonConstants from '../common/constant/CommonConstants';
import { booking } from '../view/Booking'
import { home } from '../view/Home'
import { statistic } from '../view/Statistic'

@Entry
@Component
struct Index {
  private tabsController: TabsController = new TabsController();

  @State currentIndex :number = 0;


  @Builder TabBuilder(title: string,index:number ,img1_normal: Resource, img2_selected: Resource) {
    Column() {
      Image(this.currentIndex === index ? img2_selected : img1_normal)
        .width(25)
        .height(25)
      Text(title)
        .margin({top:4})
        .fontSize(10)
        .fontColor(this.currentIndex === index ? '#1698CE' : '#6B6B6B')
    }

  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      controller: this.tabsController
    }) {
      TabContent() {
        home();
      }
      .tabBar(this.TabBuilder(CommonConstants.HOME_TITLE,0,$r('app.media.home_normal'),$r('app.media.home_selected')))
      .backgroundColor($r('app.color.mainPage_backgroundColor'))

      TabContent() {
        booking();
      }
      .tabBar(this.TabBuilder(CommonConstants.BOOKING,1,$r('app.media.booking_normal'),$r('app.media.booking_selected')))
      .backgroundColor($r('app.color.mainPage_backgroundColor'))

      TabContent() {
        statistic();
      }
      .tabBar(this.TabBuilder(CommonConstants.STATISTIC,2,$r('app.media.statistic_normal'),$r('app.media.statistic_selected')))
      .backgroundColor($r('app.color.mainPage_backgroundColor'))

    }
    .vertical(false)
    .onChange((index:number)=>{
      this.currentIndex = index;
    })
  }
}


@Component
struct test {
  build() {

  }
}