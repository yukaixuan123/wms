<template>
  <div>
    <div id="addss">
      <h3 style="margin-left: 35px; padding-top: 30px; display: inline-block">
        盘点单号：{{ formInline.dh }}
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
            盘点类型<i style="margin-left: 50px; color: #999999">{{
              formInline.lx
            }}</i>
          </td>

          <td>
            盘点开始时间<i style="margin-left: 50px; color: #999999">{{
              filterTime(formInline.datek)
            }}</i>
          </td>

          <td>
            仓库名称<i style="margin-left: 50px; color: #999999">{{
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
            盘点结束时间<i style="margin-left: 50px; color: #999999">{{
              filterTime(formInline.date)
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

            <el-table-column label="账面库存" width="80">
              <template slot-scope="scope">
                <span :id="'ku' + (scope.$index + 1)">{{
                  scope.row.account_num
                }}</span>
              </template>
            </el-table-column>
            <el-table-column label="账面金额" width="140">
              <template slot-scope="scope">
                <span :id="'jin' + (scope.$index + 1)">{{
                  scope.row.inbill_price * scope.row.account_num
                }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="area_code" label="盘点仓位" width="140px">
            </el-table-column>
            <el-table-column prop="inventory_num" label="盘点数量" width="140">
            </el-table-column>
            <el-table-column label="盈亏数量" width="140">
              <template slot-scope="scope">
                <span
                  v-if="scope.row.break_even_num > 0"
                  style="color: green"
                  :id="'weiSum' + (scope.$index + 1)"
                  >{{ scope.row.break_even_num }}</span
                >
                <span
                  v-if="scope.row.break_even_num < 0"
                  style="color: red"
                  :id="'weiSum' + (scope.$index + 1)"
                  >{{ scope.row.break_even_num }}</span
                >
                <span
                  v-if="scope.row.break_even_num == 0"
                  style="color: black"
                  :id="'weiSum' + (scope.$index + 1)"
                  >{{ scope.row.break_even_num }}</span
                >
              </template>
            </el-table-column>
            <el-table-column label="盘点状态" width="140">
              <template slot-scope="scope">
                <el-tag
                  :id="'elTag' + (scope.$index + 1)"
                  v-if="scope.row.inventory_state == 0"
                  class="el-tag el-tag--light el-tag--primary"
                  disable-transitions
                  >未盈亏</el-tag
                >
                <el-tag
                  :id="'elTag' + (scope.$index + 1)"
                  v-if="scope.row.inventory_state == 1"
                  class="el-tag el-tag--light el-tag--danger"
                  disable-transitions
                  >盘亏</el-tag
                >
                <el-tag
                  :id="'elTag' + (scope.$index + 1)"
                  v-if="scope.row.inventory_state == 2"
                  class="el-tag el-tag--light el-tag--success"
                  disable-transitions
                  >盘盈</el-tag
                >
              </template>
            </el-table-column>

            <el-table-column label="盘点金额" width="140">
              <template slot-scope="scope">
                <span
                  v-if="scope.row.break_even_num > 0"
                  style="color: green"
                  >{{ scope.row.break_even_num * scope.row.inbill_price }}</span
                >
                <span v-if="scope.row.break_even_num < 0" style="color: red">{{
                  scope.row.break_even_num * scope.row.inbill_price
                }}</span>
                <span
                  v-if="scope.row.break_even_num == 0"
                  style="color: black"
                  >{{ scope.row.break_even_num * scope.row.inbill_price }}</span
                >
              </template>
            </el-table-column>

            <el-table-column label="入库单价" width="100">
              <template slot-scope="scope">
                <span :id="'saleSum' + (scope.$index + 1)">{{
                  scope.row.inbill_price
                }}</span>
              </template>
            </el-table-column>
            <el-table-column label="入库金额" width="100">
              <template slot-scope="scope">
                <i :id="'totalsum' + (scope.$index + 1)" style="color: red">{{
                  scope.row.inbill_price * scope.row.inventory_num
                }}</i>
              </template>
            </el-table-column>

            <el-table-column prop="remark" label="备注" width="300">
            </el-table-column>
          </el-table>
          <div id="hj">
            <span style="line-height: 45px; font-size: 12px; margin-left: 25px"
              >合计</span
            >
            <p style="float: right">
              <span style="line-height: 45px; font-size: 14px">账面库存：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 25px;
                "
                id="sumKu"
                >0</span
              >
              <span style="line-height: 45px; font-size: 14px">账面金额：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 25px;
                "
                id="sumJin"
                >￥0.00</span
              >
              <span style="line-height: 45px; font-size: 14px">盘点数量：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 25px;
                "
                id="sumNumber"
                >0</span
              >
              <span style="line-height: 45px; font-size: 14px">盘点金额：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 25px;
                "
                id="sumSalary"
                >￥0.00</span
              >
              <span style="line-height: 45px; font-size: 14px">盘盈数量：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 25px;
                "
                id="sumNumbery"
                >0</span
              >
              <span style="line-height: 45px; font-size: 14px">盘亏数量：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 25px;
                "
                id="sumNumberk"
                >0</span
              >
              <span style="line-height: 45px; font-size: 14px">盘盈金额：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 25px;
                "
                id="sumSalaryy"
                >￥0.00</span
              >
              <span style="line-height: 45px; font-size: 14px">盘亏金额：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 25px;
                "
                id="sumSalaryk"
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
        datek: "",
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
      if (i == 0) return "无盈亏";
      if (i == 1) return "有盈亏";
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
          "  http://localhost:5149/api/Wh_inventory_h/Wh_inventory_hMH?bh=" + bh
        )
        .then((res) => {
          this.formInline.dh = res.inventory_code;

          this.formInline.lx = res.inventory_type;
          this.formInline.mc = res.ware_code;
          this.formInline.date = res.end_date;
          this.formInline.datek = res.begin_date;
          this.formInline.bei = res.remark;
          this.formInline.zt = res.zt;
          this.formInline.jbr = res.sure_man;
        })
        .catch((err) => {
          alert(err);
        });
    },
    //明细
    find() {
      var bh = this.$route.query.dh;

      var s1 = 0; //账面库存
      var s2 = 0; //盘点数量
      var s3 = 0; //盘盈数量
      var s4 = 0; //盘亏数量
      var s5 = 0; //账面金额
      var s6 = 0; //盘点金额
      var s7 = 0; //盘盈金额
      var s8 = 0; //盘亏金额

      $http
        .get(
          "  http://localhost:5149/api/Wh_inventory_h/Wh_inventory_dMH?bh=" + bh
        )
        .then((res) => {
          this.tableData = res;
          for (let i = 0; i < this.tableData.length; i++) {
            s1 += this.tableData[i].account_num;
            s2 += this.tableData[i].inventory_num;
            s5 +=
              this.tableData[i].account_num * this.tableData[i].inbill_price;
            s6 +=
              this.tableData[i].inventory_num * this.tableData[i].inbill_price;
            if (this.tableData[i].break_even_num > 0) {
              s3 += this.tableData[i].break_even_num;
              s7 +=
                this.tableData[i].break_even_num *
                this.tableData[i].inbill_price;
            }
            if (this.tableData[i].break_even_num < 0) {
              s4 += this.tableData[i].break_even_num;
              s8 +=
                this.tableData[i].break_even_num *
                this.tableData[i].inbill_price;
            }
          }
          document.getElementById("sumNumber").innerHTML = s2; //盘点数量
          document.getElementById("sumKu").innerHTML = s1; //账面库存
          document.getElementById("sumJin").innerHTML = s5; //账面金额
          document.getElementById("sumSalary").innerHTML = s6; //盘点金额
          document.getElementById("sumNumbery").innerHTML = s3; //盘盈数量
          document.getElementById("sumNumberk").innerHTML = s4; //盘亏数量
          document.getElementById("sumSalaryy").innerHTML = s7; //盘盈金额
          document.getElementById("sumSalaryk").innerHTML = s8; //盘亏金额
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
    this.find();
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