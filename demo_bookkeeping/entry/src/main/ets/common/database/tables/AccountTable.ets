import relationalStore from '@ohos.data.relationalStore';
import AccountData from '../../../viewmodel/AccountData';
import CommonConstants from '../../constant/CommonConstants';
import Rdb from '../rdb';
import Logger from '../../utils/Logger';

export default class AccountTable {
  private accountTable = new Rdb(CommonConstants.ACCOUNT_TABLE.tableName, CommonConstants.ACCOUNT_TABLE.sqlCreate,
    CommonConstants.ACCOUNT_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.accountTable.getRdbStore(callback);
  }


  getRdbStore(callback: Function = () => {
  }) {
    this.accountTable.getRdbStore(callback);

  }

  insertData(account: AccountData , callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(account);
    console.log(JSON.stringify(valueBucket))
    this.accountTable.insertData(valueBucket, callback);
  }

  deleteData(account: AccountData, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.ACCOUNT_TABLE.tableName);
    predicates.equalTo('id', account.id);
    this.accountTable.deleteData(predicates, callback);
  }

  updateData(account: AccountData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(account);
    let predicates = new relationalStore.RdbPredicates(CommonConstants.ACCOUNT_TABLE.tableName);
    predicates.equalTo('id', account.id);
    this.accountTable.updateData(predicates, valueBucket, callback);
  }

  query(amount: number, callback: Function, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.ACCOUNT_TABLE.tableName);
    if (!isAll) {
      predicates.equalTo('amount', amount);
    }
    this.accountTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {

        callback([]);
      } else {

        resultSet.goToFirstRow();

        Logger.info(`测试查询数据 resultSet :  ${JSON.stringify(resultSet)}+ count:${count}` )

        const result: AccountData[] = [];
        for (let i = 0; i < count; i++) {
          let tmp: AccountData = {
            id: 0, accountType: 0, typeText: '', amount: 0,day:0,month:0,year:0,date_string:''
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.accountType = resultSet.getDouble(resultSet.getColumnIndex('accountType'));
          tmp.typeText = resultSet.getString(resultSet.getColumnIndex('typeText'));
          tmp.amount = resultSet.getDouble(resultSet.getColumnIndex('amount'));
          tmp.day = resultSet.getDouble(resultSet.getColumnIndex('day'));
          tmp.month = resultSet.getDouble(resultSet.getColumnIndex('month'));
          tmp.year = resultSet.getDouble(resultSet.getColumnIndex('year'));
          tmp.date_string = resultSet.getString(resultSet.getColumnIndex('date_string'));

          result[i] = tmp;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }
}

function generateBucket(account: AccountData ): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};

  obj.accountType = account.accountType;
  obj.typeText = account.typeText;
  obj.amount = account.amount;
  obj.month = account.month;
  obj.year = account.year;
  obj.date_string =account.date_string;
  obj.day = account.day;

  return obj;
}