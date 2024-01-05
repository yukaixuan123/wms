<template>
  <div>
    <div id="adddss">
      <h3 style="margin-left: 35px; padding-top: 30px; display: inline-block">
        进货单号：{{ this.$route.query.buy_code }}
        <img
          src="../Images/fz.png"
          width="20px"
          height="20px"
          style="vertical-align: middle; margin-left: 120px"
          @click="fzcg"
        />
      </h3>

      <div style="float: right; padding-top: 30px; margin-right: 35px">
        <el-button id="tex3" @click="inserok()" icon="el-icon-plus"
          >入库</el-button
        >
        <!-- <el-button  id="tex4"  icon="el-icon-edit">修改</el-button> -->
        <el-button id="tex5" @click="delAll()" icon="el-icon-minus"
          >退货</el-button
        >
        <el-button id="tex6" icon="el-icon-close" @click="sgb">关闭</el-button>
      </div>

      <table
        style="
          width: 1100px;
          line-height: 55px;
          margin-left: 35px;
          padding-top: 20px;
        "
      >
        <tr>
          <td>
            制单人<i style="margin-left: 50px; color: #999999">{{ zdr }}</i>
          </td>
          <!-- <td>所在部门<i style="margin-left: 50px">123</i></td> -->
          <td>
            制单时间<i style="margin-left: 50px; color: #999999">{{
              filterTime(date)
            }}</i>
          </td>
          <td>
            进货人<i style="margin-left: 65px; color: #999999">{{ jhr }}</i>
          </td>

          <td>
            单据状态<i style="margin-left: 50px; font-weight: bold">{{
              zt(djzt)
            }}</i>
          </td>
        </tr>
        <tr>
          <td>
            供应商<i style="margin-left: 50px; color: #999999">{{ gys }}</i>
          </td>
          <td>
            进货日期<i style="margin-left: 50px; color: #999999">{{
              filterTime(date1)
            }}</i>
          </td>
          <!-- <td>进货部门<i style="margin-left: 50px">123</i></td> -->
          <td>
            联系方式<i style="margin-left: 50px; color: #999999">{{ fs }}</i>
          </td>
        </tr>
        <tr>
          <td>
            联系人<i style="margin-left: 50px; color: #999999">{{ lxr }}</i>
          </td>
          <td>
            备注<i style="margin-left: 65px; color: #999999">{{ bz }}</i>
          </td>
        </tr>
      </table>
    </div>
    <div id="addxx">
      <el-tabs id="menu" v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="进货明细" style="margin-top: -10px" name="first">
          <el-button id="tex9" icon="el-icon-download">导出</el-button>
          <el-table
            height="280"
            tooltip-effect="dark"
            @selection-change="handleSelectionChange"
            :data="tableData"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',
              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
          >
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column label="序号" type="index" width="50">
            </el-table-column>
            <el-table-column prop="item_name" label="货品名称" width="100">
            </el-table-column>
            <el-table-column prop="item_code" label="货品编号" width="100">
            </el-table-column>
            <el-table-column prop="model_code" label="规格型号" width="100">
            </el-table-column>
            <el-table-column prop="unit" label="单位" width="115px">
            </el-table-column>
            <el-table-column prop="item_type_name" label="货品类型" width="100">
            </el-table-column>
            <el-table-column prop="buy_num" label="货品数量" width="99">
            </el-table-column>
            <el-table-column prop="buy_goods_money" label="进货单价" width="90">
            </el-table-column>
            <el-table-column label="金额" width="90">
              <template slot-scope="scope">
                <span>{{ scope.row.buy_num * scope.row.buy_goods_money }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="inbill_num" label="已入库数量" width="90">
            </el-table-column>
            <el-table-column prop="treat_num" label="待入库数量" width="90">
            </el-table-column>
          </el-table>
          <div id="hj">
            <span style="line-height: 45px; font-size: 12px; margin-left: 25px"
              >合计</span
            >
            <p style="float: right">
              <span style="line-height: 45px; font-size: 12px"
                >已入库数量：</span
              >
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 12px;
                  margin-right: 35px;
                "
                >{{ yrksl }}</span
              >
              <span style="line-height: 45px; font-size: 12px"
                >待入库数量：</span
              >
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 12px;
                  margin-right: 35px;
                "
                >{{ drksl }}</span
              >
              <span style="line-height: 45px; font-size: 12px">货品数量：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 12px;
                  margin-right: 35px;
                "
                id="sumNumber"
                >{{ hpsl }}</span
              >
              <span style="line-height: 45px; font-size: 12px">总金额：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 12px;
                  margin-right: 30px;
                "
                id="sumSalary"
                >￥{{ zje }}</span
              >
            </p>
          </div></el-tab-pane
        >
        <el-tab-pane label="入库记录" style="margin-top: -10px" name="second">
          <el-button id="tex9" icon="el-icon-download">导出</el-button>
          <el-table
            height="280"
            tooltip-effect="dark"
            @selection-change="handleSelectionChange"
            :data="tableData1"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',
              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
          >
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column label="序号" type="index" width="50">
            </el-table-column>
            <el-table-column prop="inbill_bh" label="入库单号" width="100">
            </el-table-column>
            <el-table-column label="入库日期" width="130">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.inbll_date) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="ware_name" label="仓库名称" width="100">
            </el-table-column>
            <el-table-column
              prop="names"
              :show-overflow-tooltip="true"
              label="入库货品"
              width="120px"
            >
            </el-table-column>
            <el-table-column prop="total_buy_num" label="入库数量" width="94">
            </el-table-column>
            <el-table-column prop="total_price" label="入库金额" width="100">
            </el-table-column>
            <el-table-column prop="inbill_duty_man" label="经办人" width="100">
            </el-table-column>
            <el-table-column prop="create_by" label="制单人" width="100">
            </el-table-column>
            <el-table-column label="制单时间" width="130">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.create_time) }}</span>
              </template>
            </el-table-column>
          </el-table>
          <div id="hj">
            <span style="line-height: 45px; font-size: 12px; margin-left: 25px"
              >合计</span
            >
            <p style="float: right">
              <span style="line-height: 45px; font-size: 12px">入库数量：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 12px;
                  margin-right: 35px;
                "
                id="sumNumber"
                >{{ rksl }}</span
              >
              <span style="line-height: 45px; font-size: 12px">入库金额：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 12px;
                  margin-right: 30px;
                "
                id="sumSalary"
                >￥{{ rkje }}</span
              >
            </p>
          </div>
        </el-tab-pane>
        <el-tab-pane label="退货记录" style="margin-top: -10px" name="third">
          <el-button id="tex9" icon="el-icon-download">导出</el-button>
          <el-table
            height="280"
            tooltip-effect="dark"
            @selection-change="handleSelectionChange"
            :data="tableData2"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',
              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
          >
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column label="序号" type="index" width="50">
            </el-table-column>
            <el-table-column prop="returns_code" label="退货单号" width="150">
            </el-table-column>
            <el-table-column label="退货日期" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.sr_date) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="returns_num" label="退货数量" width="120">
            </el-table-column>
            <el-table-column prop="returns_money" label="退货金额" width="123">
            </el-table-column>
            <el-table-column
              prop="remark"
              :show-overflow-tooltip="true"
              label="退货原因"
              width="150"
            >
            </el-table-column>
            <el-table-column prop="create_by" label="制单人" width="130">
            </el-table-column>
            <el-table-column label="制单时间" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.create_time) }}</span>
              </template>
            </el-table-column>
          </el-table>
          <div id="hj">
            <span style="line-height: 45px; font-size: 12px; margin-left: 25px"
              >合计</span
            >
            <p style="float: right">
              <span style="line-height: 45px; font-size: 12px">退货数量：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 12px;
                  margin-right: 35px;
                "
                id="sumNumber"
                >{{ thsl }}</span
              >
              <span style="line-height: 45px; font-size: 12px">退货金额：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 12px;
                  margin-right: 30px;
                "
                id="sumSalary"
                >￥{{ thje }}</span
              >
            </p>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
    <div id="notification-container">
      <div id="dibu">
        <el-button id="bcccc" @click="gb()">关闭</el-button>
      </div>
    </div>
  </div>
</template>

<script>
import $http from "@/http/base";
export function formatDate(date) {
  let time = new Date(date);
  console.log(time);
  let year = time.getFullYear();
  console.log(year);
  let month = time.getMonth() + 1;
  month = month.toString().padStart(2, "0");
  let day = time.getDate().toString().padStart(2, "0");
  return year + "-" + month + "-" + day + "";
}
export default {
  data() {
    return {
      activeIndex: "1",
      zdr: "",
      date: "",
      djzt: "",
      gys: "",
      date1: "",
      lxr: "",
      fs: "",
      jhr: "",
      bz: "",
      tableData: [],
      tableData1: [],
      tableData2: [],
      multipleSelection: [],
      yrksl: 0,
      drksl: 0,
      hpsl: 0,
      zje: 0,

      rksl: 0,
      rkje: 0,

      thsl: 0,
      thje: 0,
      activeName: "first",
    };
  },
  methods: {
    sgb() {
      this.$router.go(-1);
    },
    //关闭
    gb() {
      this.$router.go(-1);
    },
    fzcg() {
      this.$message({
        message: "复制成功",
        type: "success",
      });
    },
    //下标
    handleSelect(key, keyPath) {
      console.log(key, keyPath);
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    //根据id查进货订单
    findId() {
      $http
        .get(
          "http://localhost:5149/api/Wh_buy_order_h/Wh_buy_order_h_CodeAsyunc?buy_code=" +
            this.$route.query.buy_code +
            ""
        )
        .then((res) => {
          this.zdr = res.create_by;
          this.date = res.create_time;
          this.djzt = res.sale_state;
          this.gys = res.supply_code;
          this.date1 = res.buy_date;
          this.lxr = res.link_man;
          this.fs = res.link_way;
          this.jhr = res.buy_man;
          this.bz = res.remark;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    //进货明细
    find() {
      $http
        .get(
          "http://localhost:5149/api/Wh_buy_order_h/Wh_buy_order_h_Code1Asyunc?buy_code=" +
            this.$route.query.buy_code +
            ""
        )
        .then((res) => {
          console.log(res);
          this.tableData = res;
          for (let i = 0; i < this.tableData.length; i++) {
            this.yrksl += this.tableData[i].inbill_num;
            this.drksl += this.tableData[i].treat_num;
            this.hpsl += this.tableData[i].buy_num;
            this.zje +=
              this.tableData[i].buy_num * this.tableData[i].buy_goods_money;
          }
        })
        .catch((err) => {
          console.log(err);
        });
    },
    //入库记录
    findrk() {
      $http
        .get(
          "http://localhost:5149/api/Wh_buy_order_h/Wh_buy_order_h_Code2Asyunc?buy_code=" +
            this.$route.query.buy_code +
            ""
        )
        .then((res) => {
          console.log(res);
          this.tableData1 = res;
          for (let i = 0; i < this.tableData1.length; i++) {
            this.rksl += this.tableData1[i].total_buy_num;
            this.rkje += this.tableData1[i].total_price;
          }
        })
        .catch((err) => {
          console.log(err);
        });
    },
    //退货记录
    findtkjl() {
      $http
        .get(
          "http://localhost:5149/api/Wh_return_supply_h/Wh_return_supply_h_thjlAsyunc?buy_code=" +
            this.$route.query.buy_code +
            ""
        )
        .then((res) => {
          console.log(res);
          this.tableData2 = res;
          for (let i = 0; i < this.tableData2.length; i++) {
            this.thsl += this.tableData2[i].returns_num;
            this.thje += this.tableData2[i].returns_money;
          }
        })
        .catch((err) => {
          console.log(err);
        });
    },
    zt(ztt) {
      if (ztt == 0) {
        return "待审核";
      }
      if (ztt == 1) {
        return "驳回";
      }
      if (ztt >= 2) {
        return "通过";
      }
    },
    //时间格式化
    filterTime(timestamp) {
      return formatDate(timestamp);
    },
    handleClick(tab, event) {
      console.log(tab, event);
    },
  },
  mounted() {
    this.findtkjl();
    this.findrk();
    this.findId();
    this.find();
  },
};
</script>

<style>
#hj {
  border: 1px solid #eeeeee;
  width: 1080px;
  height: 45px;
  margin-left: 2px;
  display: inline-block;
}
.el-tabs__item {
  padding: 0 20px;
  height: 50px !important;
  box-sizing: border-box;
  line-height: 50px !important;
  display: inline-block;
  list-style: none;
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  position: relative;
}
#menu {
  position: relative;
  left: 30px;
  width: 1085px;
}
#jhmx {
  width: 1080px !important;
  margin-top: 25px;
  margin-left: 2px;
}
#notification-container {
  position: fixed;
  bottom: 0;
  width: 100%;
  box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
  background-color: #fff;
  height: 60px;
  z-index: 999;
}
#bcccc {
  width: 28px !important;
  color: #fff;
  background-color: #9c27b0;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 115px;
}
#adddss {
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 290px;
}
#addxx {
  margin-top: 20px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 530px;
}
#tex9 {
  border: 1px solid #fae4a2;
  color: #f8c341;
  background-color: #fef8e8;
  width: 28px !important;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 2px;
  margin-top: 25px;
}
#tex9:hover {
  background-color: #f5bd41;
  color: #fff;
}
</style>