<template>
  <div>
    <div id="addss">
      <h3 style="margin-left: 35px; padding-top: 30px; display: inline-block">
        调拨单号：{{ formInline.dh }}
        <img
          src="../Images/fz.png"
          width="20px"
          height="20px"
          style="vertical-align: middle; margin-left: 120px"
          @click="fzcg"
        />
      </h3>

      <div style="float: right; padding-top: 30px; margin-right: 35px">
        <!-- <el-button id="tex3" @click="inserok()" icon="el-icon-plus">编辑</el-button> -->
        <!-- <el-button  id="tex4"  icon="el-icon-edit">修改</el-button> -->
        <el-button id="tex5" @click="delAll()" icon="el-icon-delete"
          >撤销</el-button
        >
        <el-button id="tex6" icon="el-icon-download">打印</el-button>
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
            调拨类型<i style="margin-left: 50px; color: #999999">{{
              formInline.lx
            }}</i>
          </td>

          <td>
            调入仓库<i style="margin-left: 50px; color: #999999">{{
              formInline.mc1
            }}</i>
          </td>

          <td>
            调出仓库<i style="margin-left: 50px; color: #999999">{{
              formInline.mc
            }}</i>
          </td>

          <td>
            状态<i style="margin-left: 50px; font-weight: bold">{{
              zt(formInline.zt)
            }}</i>
          </td>
        </tr>
        <tr>
          <td>
            经办人<i style="margin-left: 50px; color: #999999">{{
              formInline.jbr
            }}</i>
          </td>
          <td>
            调拨申请日期<i style="margin-left: 50px; color: #999999">{{
              filterTime(formInline.date)
            }}</i>
          </td>
        </tr>
        <tr>
          <td>
            制单人<i style="margin-left: 50px; color: #999999">{{
              formInline.zdr
            }}</i>
          </td>
          <td>
            制单时间<i style="margin-left: 50px; color: #999999">{{
              filterTime(formInline.date1)
            }}</i>
          </td>
        </tr>

        <tr>
          <td>
            备注<i style="margin-left: 65px; color: #999999">{{
              formInline.bei
            }}</i>
          </td>
        </tr>
      </table>
    </div>

    <div id="addxx">
      <el-tabs id="menu" v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="盘点明细" name="first">
          <el-button id="tex9" icon="el-icon-download">导出</el-button>
          <el-table
            tooltip-effect="dark"
            :data="tableData"
            height="300"
            :row-style="{ height: 70 + 'px' }"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',
              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="ttt"
            @selection-change="handleSelectionChange"
          >
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column label="序号" fixed type="index" width="50">
            </el-table-column>
            <el-table-column prop="buy_code" label="货品编号" v-if="false">
            </el-table-column>

            <el-table-column
              fixed
              prop="item_name"
              label="货品名称"
              width="100"
            >
            </el-table-column>
            <el-table-column fixed label="货品编号" width="100">
              <template slot-scope="scope">
                <span :id="'hp' + (scope.$index + 1)">{{
                  scope.row.item_code
                }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="item_type_name" label="货品类型" width="80">
            </el-table-column>
            <el-table-column prop="model_code" label="规格型号" width="80">
            </el-table-column>
            <el-table-column prop="unit" label="单位" width="80">
            </el-table-column>

            <el-table-column label="调出仓库当前库存" width="160">
              <template slot-scope="scope">
                <span :id="'ku' + (scope.$index + 1)"></span>
              </template>
            </el-table-column>

            <el-table-column prop="outarea_code" label="调出仓位" width="140px">
              <template slot-scope="scope">
                <select
                  v-model="scope.row.outarea_code"
                  placeholder="请选择"
                  :disabled="true"
                  @change="kuwei(scope.row.outarea_code, scope.$index + 1)"
                  style="
                    width: 120px;
                    height: 25px;
                    border: 1px solid rgb(211 211 217);
                  "
                >
                  <!-- <option v-for="item in countryList1" :key="item.ware_area_id" :label="item.area_name"
                                        :value="item.area_name"></option> -->
                  <option>{{ scope.row.outarea_code }}</option>
                </select>
              </template>
            </el-table-column>
            <el-table-column label="调入仓库当前库存" width="160">
              <template slot-scope="scope">
                <span :id="'ku1' + (scope.$index + 1)"></span>
              </template>
            </el-table-column>
            <el-table-column prop="inarea_code" label="调入仓位" width="140px">
              <template slot-scope="scope">
                <select
                  v-model="scope.row.inarea_code"
                  placeholder="请选择"
                  :disabled="true"
                  @change="kuwei1(scope.row.inarea_code, scope.$index + 1)"
                  style="
                    width: 120px;
                    height: 25px;
                    border: 1px solid rgb(211 211 217);
                  "
                >
                  <!-- <option v-for="item in countryList4" :key="item.ware_area_id" :label="item.area_name"
                                    :value="item.area_name"></option> -->
                  <option>{{ scope.row.inarea_code }}</option>
                </select>
              </template>
            </el-table-column>
            <el-table-column prop="out_num" label="调拨数量" width="140">
              <template slot-scope="scope">
                <span>{{ scope.row.out_num }}</span>
              </template>
            </el-table-column>

            <el-table-column label="调拨单价" width="100">
              <template slot-scope="scope">
                <span :id="'saleSum' + (scope.$index + 1)">{{
                  scope.row.inbill_price
                }}</span>
              </template>
            </el-table-column>
            <el-table-column label="调拨金额" width="100">
              <template slot-scope="scope">
                <i :id="'totalsum' + (scope.$index + 1)" style="color: red">{{
                  scope.row.inbill_price * scope.row.out_num
                }}</i>
              </template>
            </el-table-column>

            <el-table-column prop="remark" label="备注" width="300">
              <template slot-scope="scope">
                <!-- <input v-model="scope.row.remark"
                                    style="width: 260px;height: 25px;border: 1px solid rgb(211 211 217);"> -->
                <span>{{ scope.row.remark }}</span>
              </template>
            </el-table-column>
          </el-table>
          <div
            style="
              border: 1px solid #eeeeee;
              width: 1080px;
              height: 45px;
              display: inline-block;
            "
          >
            <span style="line-height: 45px; font-size: 14px; margin-left: 25px"
              >合计</span
            >
            <p style="float: right">
              <span style="line-height: 45px; font-size: 14px">调拨数量：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 35px;
                "
                id="sumNumber"
                >0</span
              >
              <span style="line-height: 45px; font-size: 14px"
                >调拨总金额：</span
              >
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 30px;
                "
                id="sumSalary"
                >￥0.00</span
              >
            </p>
          </div>
        </el-tab-pane>
        <el-tab-pane label="入库记录" name="second">
          <el-button id="tex9" icon="el-icon-download">导出</el-button>

          <el-table
            tooltip-effect="dark"
            :data="tableData1"
            height="300"
            :row-style="{ height: 70 + 'px' }"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',
              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="ttt"
            @selection-change="handleSelectionChange"
          >
            <el-table-column type="selection" width="55"> </el-table-column>

            <el-table-column
              fixed
              prop="inbill_bh"
              label="入库单号"
              width="150"
            >
            </el-table-column>
            <el-table-column
              fixed
              prop="inbill_type"
              label="入库类型"
              width="120"
            >
            </el-table-column>

            <el-table-column fixed label="入库日期" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.inbll_date) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="ware_name" label="仓库名称" width="120">
            </el-table-column>

            <el-table-column prop="names" label="入库货品" width="180">
              <template slot-scope="scope">
                <el-popover placement="top" trigger="hover">
                  <p>{{ scope.row.names }}</p>
                  <div slot="reference">
                    {{ truncateString(scope.row.names, 10) }}
                  </div>
                </el-popover>
              </template>
            </el-table-column>
            <el-table-column prop="inbill_duty_man" label="经办人" width="120">
            </el-table-column>
            <el-table-column prop="total_buy_num" label="入库数量" width="120">
            </el-table-column>
            <el-table-column prop="total_price" label="入库金额" width="120">
            </el-table-column>
            <el-table-column prop="create_by" label="制单人" width="120">
            </el-table-column>
            <el-table-column label="制单时间" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.create_time) }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="出库记录" name="third1">
          <el-button id="tex9" icon="el-icon-download">导出</el-button>

          <el-table
            tooltip-effect="dark"
            :data="tableData3"
            height="300"
            :row-style="{ height: 70 + 'px' }"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',
              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="ttt"
            @selection-change="handleSelectionChange"
          >
            <el-table-column type="selection" width="55"> </el-table-column>

            <el-table-column
              fixed
              prop="outbill_code"
              label="出库单号"
              width="150"
            >
            </el-table-column>
            <el-table-column
              fixed
              prop="outbill_type"
              label="出库类型"
              width="120"
            >
            </el-table-column>

            <el-table-column fixed label="出库日期" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.outbill_date) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="ware_code" label="仓库名称" width="120">
            </el-table-column>

            <el-table-column prop="names" label="出库货品" width="180">
              <template slot-scope="scope">
                <el-popover placement="top" trigger="hover">
                  <p>{{ scope.row.names }}</p>
                  <div slot="reference">
                    {{ truncateString(scope.row.names, 10) }}
                  </div>
                </el-popover>
              </template>
            </el-table-column>

            <el-table-column prop="total_buy_num" label="出库数量" width="120">
            </el-table-column>
            <el-table-column prop="total_price" label="出库金额" width="120">
            </el-table-column>
            <el-table-column prop="duty_man" label="经办人" width="120">
            </el-table-column>
            <el-table-column prop="create_by" label="制单人" width="120">
            </el-table-column>
            <el-table-column label="制单时间" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.create_time) }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="审核记录" name="third">
          <el-table
            tooltip-effect="dark"
            :data="tableData2"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',
              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
            height="300px"
          >
            <el-table-column label="序号" type="index" width="70">
            </el-table-column>

            <el-table-column label="审核结果" width="300">
              <template slot-scope="scope">
                <span
                  v-if="scope.row.auditResults == 0"
                  style="font-weight: 600; font-size: 13px"
                  >提交</span
                >
                <span
                  v-if="scope.row.auditResults == 1"
                  style="color: red; font-weight: 600; font-size: 13px"
                  >驳回</span
                >
                <span
                  v-if="scope.row.auditResults == 2"
                  style="color: green; font-weight: 600; font-size: 13px"
                  >已完成</span
                >
                <span
                  v-if="scope.row.auditResults == 3"
                  style="font-weight: 600; font-size: 13px"
                  >撤销</span
                >
              </template>
            </el-table-column>
            <el-table-column prop="opinions" label="审核意见" width="200">
            </el-table-column>
            <el-table-column prop="auditUser" label="操作人" width="200">
            </el-table-column>

            <el-table-column label="操作时间" width="300">
              <template slot-scope="scope">
                <span v-if="scope.row.auditTime != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.auditTime)
                }}</span>
                <span v-else></span>
              </template>
            </el-table-column>
          </el-table>

          <!-- 分页 -->
          <el-pagination
            id="fenye"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="currentPage"
            :page-sizes="[4, 8, 12, 16]"
            :page-size="pagesize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="rows"
          >
          </el-pagination>
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

  let year = time.getFullYear();

  let month = time.getMonth() + 1;
  month = month.toString().padStart(2, "0");
  let day = time.getDate().toString().padStart(2, "0");
  return year + "年" + month + "月" + day + "日";
}
export default {
  data() {
    return {
      activeIndex: "1",

      formInline: {
        dh: "",
        lx: "",
        mc: "",
        date: "",
        bei: "",
        jbr: "",
        zt: "",
        mc1: "",
        zdr: "",
        date1: "",
      },
      tableData: [],
      tableData1: [],
      tableData2: [],
      tableData3: [],
      ii: "",
      currentPage: 1, //当前页
      pagesize: 4, //每页显示数
      rows: 0, //总行数
      str: "1=1",
      multipleSelection: [],
      yrksl: 0,

      zje: 0,
      activeName: "first",
    };
  },
  methods: {
    truncateString(str, length) {
      return str.length > length ? str.slice(0, length) + "..." : str;
    },
    zt(i) {
      if (i == 0) return "待审核";
      if (i == 1) return "已完成";
    },
    //每页显示数改变事件
    handleSizeChange(size) {
      this.pagesize = size;
      this.currentPage = 1;
      this.FenYe();
    },
    //页码改变事件
    handleCurrentChange(page) {
      this.currentPage = page;
      this.FenYe();
    },
    FenYe() {
      var t = this;
      t.str = "AuditDH='" + this.$route.query.dh + "'";
      $http
        .post(
          "http://localhost:5149/api/Wh_inbill_h/FenAudit?page=" +
            t.pagesize +
            "&pageSize=" +
            t.currentPage +
            "&str=" +
            t.str
        )
        .then((res) => {
          t.tableData2 = res.list;
          t.rows = res.rows;
          console.log(this.tableData2);
        })
        .catch((err) => {
          alert(err);
        });
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
    Jia() {
      var bh = this.$route.query.dh;

      $http
        .get(
          "  http://localhost:5149/api/Wh_transfer_h/Wh_transfer_hMH?bh=" + bh
        )
        .then((res) => {
          this.formInline.dh = res.transfer_code;

          this.formInline.lx = res.transfer_type;
          this.formInline.mc = res.out_warecode;
          this.formInline.mc1 = res.in_warecode;
          this.formInline.date = res.transfer_date;

          this.formInline.bei = res.remark;
          this.formInline.zt = res.sure_state;
          this.formInline.jbr = res.sure_man;
          this.formInline.zdr = res.create_by;
          this.formInline.date1 = res.create_time;
        })
        .catch((err) => {
          alert(err);
        });
    },
    //明细
    find2() {
      var bh = this.$route.query.dh;

      var s2 = 0; //盘点数量

      var s6 = 0; //盘点金额

      $http
        .get(
          "  http://localhost:5149/api/Wh_transfer_h/Wh_transfer_dMH?bh=" + bh
        )
        .then((res) => {
          this.tableData = res;
          console.log(res);
          for (let i = 0; i < this.tableData.length; i++) {
            s2 += this.tableData[i].out_num;

            s6 += this.tableData[i].out_num * this.tableData[i].inbill_price;
            $http
              .get(
                " http://localhost:5149/api/Wh_outbill_h/Num?hp=" +
                  this.tableData[i].item_code +
                  "&kw=" +
                  this.tableData[i].inarea_code +
                  ""
              )
              .then((res) => {
                if (res == "") {
                  document.getElementById("ku1" + (i + 1)).innerHTML = "0";
                } else {
                  document.getElementById("ku1" + (i + 1)).innerHTML =
                    res.inbill3_num - res.plan_outnum;
                }
              })
              .catch((err) => {
                alert(err);
              });

            $http
              .get(
                " http://localhost:5149/api/Wh_outbill_h/Num?hp=" +
                  this.tableData[i].item_code +
                  "&kw=" +
                  this.tableData[i].outarea_code +
                  ""
              )
              .then((res) => {
                if (res == "") {
                  document.getElementById("ku" + (i + 1)).innerHTML = "0";
                } else {
                  document.getElementById("ku" + (i + 1)).innerHTML =
                    res.inbill3_num - res.plan_outnum;
                }
              })
              .catch((err) => {
                alert(err);
              });
          }
          document.getElementById("sumNumber").innerHTML = s2; //盘点数量

          document.getElementById("sumSalary").innerHTML = s6; //盘点金额
        })
        .catch((err) => {
          alert(err);
        });
      $http
        .post(
          "http://localhost:5149/api/Wh_inbill_h/Fen?page=4&pageSize=1&str=inbill_bh='" +
            bh +
            "'"
        )
        .then((res) => {
          this.tableData1 = res.list;
        })
        .catch((err) => {
          alert(err);
        });

      $http
        .post(
          "http://localhost:5149/api/Wh_outbill_h/Fen?page=4&pageSize=1&str=outbill_code='" +
            bh +
            "'"
        )
        .then((res) => {
          this.tableData3 = res.list;
        })
        .catch((err) => {
          alert(err);
        });
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
    this.Jia();
    this.find2();
    this.FenYe();
  },
};
</script>

<style scoped>
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

#addss {
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 330px;
}

#addxx {
  margin-top: 20px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 580px;
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