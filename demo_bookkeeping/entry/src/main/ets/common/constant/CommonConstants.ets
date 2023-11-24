import relationalStore from '@ohos.data.relationalStore'
import { AccountTable } from '../../viewmodel/ConstantsInterface';
import AccountData from '../../viewmodel/AccountData'


export default class CommonConstants {

  static readonly  HOME_TITLE = '首页'
  static readonly  BOOKING = '记账'
  static readonly  STATISTIC = '统计'

  /**
   * 数据库配置
   */
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'database.db',
    securityLevel:relationalStore.SecurityLevel.S1
  }
  /**
   * Account 表配置
   */
  static readonly ACCOUNT_TABLE:AccountTable = {
    tableName: 'accountTable',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS accountTable(id INTEGER PRIMARY KEY AUTOINCREMENT, accountType INTEGER, ' +
    'typeText TEXT, amount INTEGER, day INTEGER, month INTEGER, year INTEGER, date_string TEXT)',
    columns: ['id', 'accountType', 'typeText', 'amount','day','month','year','date_string']
  }

  /**
   * 搜索组件的搜索文本
   */
  static readonly SEARCH_TEXT = '搜索';

  /**
   * toast text of prompt component.
   */
  static readonly TOAST_TEXT_1 = '账目类型不能为空';
  static readonly TOAST_TEXT_2 = '账目金额不为正整数';

  /**
   * Component size.
   */
  static readonly FULL_WIDTH = '100%';
  static readonly FULL_HEIGHT = '100%';
  static readonly DIALOG_HEIGHT = '55%';
  static readonly TABS_HEIGHT = '45%';
  static readonly MINIMUM_SIZE = 0;
  static readonly FULL_SIZE = 1;
  static readonly PROMPT_BOTTOM = '70vp';
  /**
   * Component location.
   */
  static readonly EDIT_POSITION_X = '80%';
  static readonly EDIT_POSITION_Y = '90%';
  static readonly DELETE_POSITION_X = '50%';
  static readonly DELETE_POSITION_Y = '90%';
  /**
   * Log tag.
   */
  static readonly RDB_TAG = '[Debug.Rdb]';
  static readonly TABLE_TAG = '[Debug.AccountTable]';
  static readonly INDEX_TAG = '[Debug.Index]';

  /**
   * The entry ability tag.
   */
  static readonly TAG_ABILITY: string = 'EntryAbility';

  /**
   * The home page tag.
   */
  static readonly TAG_HOME: string = 'HomePage';

  /**
   * The Common utils tag.
   */
  static readonly TAG_COMMON_UTILS: string = 'CommonUtils';

  /**
   * Custom dialog widget tag.
   */
  static readonly TAG_CUSTOM: string = 'CustomDialogWidget';

  /**
   * Date year
   */
  static readonly DATE_YEAR: string = '年';

  /**
   * Date month
   */
  static readonly DATE_MONTH: string = '月';

  /**
   * Date day
   */
  static readonly DATE_DAY: string = '日';

  /**
   * Date dialog start time.
   */
  static readonly START_TIME: string = '1900-1-1';

  /**
   * Date dialog select time.
   */
  static readonly SELECT_TIME: string = '1990-1-1';

  /**
   * Image back margin left of the 7.2.
   */
  static readonly BACK_MARGIN_LEFT: string = '7.2%';

  /**
   * Image avatar margin top of the 5.5.
   */
  static readonly AVATAR_MARGIN_TOP: string = '5.5%';

  /**
   * Text personal margin top of the 2.1.
   */
  static readonly PERSONAL_MARGIN_TOP: string = '2.1%';

  /**
   * Common dialog width of the 93.3.
   */
  static readonly COMMON_DIALOG_WIDTH: string = '93.3%';

  /**
   * Join comma
   */
  static readonly COMMA: string = '，';

  /**
   * Image back margin top of the 19.
   */
  static readonly BACK_MARGIN_TOP: number = 19;

  /**
   * Font weight of the 500.
   */
  static readonly BIGGER: number = 500;

  /**
   * Dialog y-axis offset distance of the 20.
   */
  static readonly DY_OFFSET: number = -20;

  /**
   * Current month plus one.
   */
  static readonly PLUS_ONE: number = 1;

  /**
   * Layout weight size of the 1.
   */
  static readonly WEIGHT_ONE: number = 1;

  /**
   * Text common max lines of the 1.
   */
  static readonly ONE_LINES: number = 1;

  static readonly  InitData:AccountData[] = [
    { id: 0, accountType: 0, typeText: '吃饭', amount: 34 ,day:7,month:11,year:2023 ,date_string:'2023年11月7日'},
    { id: 0, accountType: 0, typeText: '吃饭', amount: 34 ,day:23,month:11,year:2023 ,date_string:'2023年11月23日'},
    { id: 0, accountType: 0, typeText: '吃饭', amount: 34 ,day:3,month:11,year:2023 ,date_string:'2023年11月3日'},
    { id: 0, accountType: 0, typeText: '吃饭', amount: 34 ,day:3,month:11,year:2023 ,date_string:'2023年11月3日'},
    { id: 0, accountType: 0, typeText: '吃饭', amount: 34 ,day:3,month:11,year:2023 ,date_string:'2023年11月3日'},
    { id: 0, accountType: 0, typeText: '吃饭', amount: 34 ,day:7,month:11,year:2023 ,date_string:'2023年11月7日'},
    { id: 0, accountType: 0, typeText: '吃饭', amount: 34 ,day:7,month:11,year:2023 ,date_string:'2023年11月7日'},
    { id: 0, accountType: 0, typeText: '吃饭', amount: 34 ,day:7,month:11,year:2023 ,date_string:'2023年11月7日'},
    { id: 2, accountType: 0, typeText: '吃饭', amount: 3234 ,day:5,month:11,year:2023 ,date_string:'2023年11月5日'},
    { id: 4, accountType: 0, typeText: '吃饭', amount: 23 ,day:4,month:11,year:2023 ,date_string:'2023年11月4日'}
  ]

}