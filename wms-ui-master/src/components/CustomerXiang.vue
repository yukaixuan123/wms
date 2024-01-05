<template>
  <div>
    <div id="addss">
      <h3 style="margin-left: 35px; padding-top: 30px; display: inline-block">
        客户单号：{{ formInline.cust_code }}
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
            所属行业<i style="margin-left: 50px; color: #999999">{{
              formInline.line_type
            }}</i>
          </td>

          <td>
            客户来源<i style="margin-left: 50px; color: #999999">{{
              formInline.cust_from
            }}</i>
          </td>

          <td>
            联系人<i style="margin-left: 50px; color: #999999">{{
              formInline.link_man
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
            联系电话<i style="margin-left: 50px; color: #999999">{{
              formInline.link_tel
            }}</i>
          </td>
          <td>
            电子邮箱<i style="margin-left: 50px; color: #999999">{{
              formInline.e_mail
            }}</i>
          </td>
          <td>
            销售负责人<i style="margin-left: 50px; color: #999999">{{
              formInline.head_of_Sales
            }}</i>
          </td>
        </tr>
        <tr>
          <td>
            客户地址<i style="margin-left: 50px; color: #999999">{{
              formInline.cust_adr
            }}</i>
          </td>
        </tr>
        <tr>
          <td>
            备注<i style="margin-left: 65px; color: #999999">{{
              formInline.remark
            }}</i>
          </td>
        </tr>
      </table>
    </div>

    <div id="addxx">
      <el-tabs id="menu" v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="基本信息" style="margin-top: -10px" name="first">
          <h3
            style="margin-left: 35px; padding-top: 30px; display: inline-block"
          >
            财务信息
          </h3>
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
                账户名称<i style="margin-left: 50px; color: #999999">{{
                  formInline.finance_name
                }}</i>
              </td>

              <td>
                纳税人识别号<i style="margin-left: 50px; color: #999999">{{
                  formInline.tax_no
                }}</i>
              </td>
            </tr>
            <tr>
              <td>
                银行账户<i style="margin-left: 50px; color: #999999">{{
                  formInline.bank_no
                }}</i>
              </td>

              <td>
                开户银行<i style="margin-left: 50px; color: #999999">{{
                  formInline.open_bank
                }}</i>
              </td>
            </tr>
            <tr>
              <td>
                开户行地址<i style="margin-left: 50px; color: #999999">{{
                  formInline.open_adr
                }}</i>
              </td>
            </tr>
          </table>
        </el-tab-pane>
        <el-tab-pane label="销售记录" name="third">
          <el-button id="tex9" icon="el-icon-download">导出</el-button>
          <el-table
            ttooltip-effect="dark"
            :data="table1"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',
              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
            height="360px"
          >
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column
              fixed
              prop="sale_codeId"
              label="序号"
              type="index"
              width="50"
            >
            </el-table-column>
            <el-table-column
              fixed
              prop="sale_code"
              label="销售单号"
              width="100"
            >
            </el-table-column>
            <el-table-column
              fixed
              prop="sale_state"
              label="单据状态"
              width="100"
            >
              <template slot-scope="scope">
                <span
                  v-if="scope.row.sale_state == 0"
                  style="color: red; font-weight: 600; font-size: 13px"
                  >待审核</span
                >
                <span
                  v-if="scope.row.sale_state > 1"
                  style="color: blue; font-weight: 600; font-size: 13px"
                  >已完成</span
                >
              </template>
            </el-table-column>
            <el-table-column
              fixed
              prop="sale_date"
              label="销售日期"
              width="140"
            >
              <template slot-scope="scope">
                <span v-if="scope.row.sale_date != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.sale_date)
                }}</span>
                <span v-else></span>
              </template>
            </el-table-column>
            <el-table-column prop="link_man" label="联系人" width="100px">
            </el-table-column>
            <el-table-column prop="link_way" label="联系方式" width="120">
            </el-table-column>
            <el-table-column
              prop="sale_duty_man"
              label="销售负责人"
              width="100"
            >
            </el-table-column>
            <el-table-column prop="total_buy_num" label="销售数量" width="100">
            </el-table-column>
            <el-table-column prop="total_price" label="销售金额" width="100">
            </el-table-column>
            <el-table-column prop="names" label="销售货品" width="200">
            </el-table-column>
            <el-table-column prop="create_by" label="制单人" width="100">
            </el-table-column>
            <el-table-column prop="create_time" label="制单时间" width="140">
              <template slot-scope="scope">
                <span v-if="scope.row.create_time != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.create_time)
                }}</span>
                <span v-else></span>
              </template>
            </el-table-column>
            <el-table-column prop="sure_man" label="审核人" width="100">
            </el-table-column>
            <el-table-column prop="sure_date" label="审核时间" width="140">
              <template slot-scope="scope">
                <span v-if="scope.row.sure_date != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.sure_date)
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

        <el-tab-pane label="出库记录" name="third1">
          <el-button id="tex9" icon="el-icon-download">导出</el-button>
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
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column label="序号" type="index" width="70">
            </el-table-column>

            <el-table-column prop="outbill_code" label="出库单号" width="100">
            </el-table-column>
            <el-table-column prop="outbill_type" label="出库类型" width="100">
            </el-table-column>
            <el-table-column prop="outbill_date" label="出库日期" width="140">
              <template slot-scope="scope">
                <span v-if="scope.row.outbill_date != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.outbill_date)
                }}</span>
                <span v-else></span>
              </template>
            </el-table-column>
            <el-table-column prop="ware_code" label="仓库名称" width="100">
            </el-table-column>
            <el-table-column prop="outbill_num" label="出库总数" width="80">
            </el-table-column>
            <el-table-column prop="zong" label="销售总金额" width="100">
            </el-table-column>
            <el-table-column prop="duty_man" label="经办人" width="80">
            </el-table-column>
            <el-table-column prop="create_by" label="制单人" width="80">
            </el-table-column>
            <el-table-column prop="create_time" label="制单时间" width="140">
              <template slot-scope="scope">
                <span v-if="scope.row.create_time != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.create_time)
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

var str = "1=1 and is_del=0";
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
        cust_code: "",
        cust_name: "",
        e_mail: "",
        link_tel: "",
        cust_adr: "",
        cust_from: "",
        link_man: "",
        line_type: "",
        head_of_Sales: "",
        remark: "",
        finance_name: "",
        tax_no: "",
        bank_no: "",
        open_bank: "",
        open_adr: "",
        zt: "",
      },
      tableData: [],
      tableData1: [],
      tableData2: [],
      table1: [],
      ii: "",

      currentPage: 1, //当前页
      pagesize: 4, //每页显示数
      rows: 0, //总行数
      multipleSelection: [],
      yrksl: 0,

      zje: 0,
      activeName: "first",
    };
  },
  methods: {
    zt(i) {
      if (i == 0) return "启用";
      if (i == 1) return "停用";
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
      str = "cust_code='" + this.$route.query.dh + "'";
      $http
        .get("http://localhost:5149/api/Wh_sale_h/Wh_sale_hFenYe", {
          params: {
            pageSize: t.pagesize,
            currentPage: t.currentPage,
            str,
          },
        })
        .then((res) => {
          console.log(res);
          t.table1 = res.list;
          t.rows = res.rows;
          console.log(str);
        })
        .catch((err) => {
          console.log(err);
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
    //根据id查进货订单
    Jia() {
      var t = this;
      var bh = this.$route.query.dh;

      $http
        .get("http://localhost:5149/api/CustomerView/SelectCode?id=" + bh)
        .then((res) => {
          t.formInline.cust_code = res.cust_code;
          t.formInline.cust_name = res.cust_name;
          t.formInline.link_man = res.link_man;
          t.formInline.link_tel = res.link_tel;
          t.formInline.e_mail = res.e_mail;
          t.formInline.cust_adr = res.cust_adr;
          t.formInline.zt = res.inbill_state;
          t.formInline.cust_from = res.cust_from;
          t.formInline.remark = res.remark;
          t.formInline.line_type = res.line_type;
          t.formInline.head_of_Sales = res.head_of_Sales;
          t.formInline.finance_name = res.finance_name;
          t.formInline.tax_no = res.tax_no;
          t.formInline.bank_no = res.bank_no;
          t.formInline.open_bank = res.open_bank;
          t.formInline.open_adr = res.open_adr;
          console.log(res);
        })
        .catch((err) => {
          console.log(err);
        });
    },

    //进货明细
    find() {
      var t = this;
      str = "cust_code='" + this.$route.query.dh + "'";
      $http
        .get("http://localhost:5149/api/CustomerView/FenYekhCK", {
          params: {
            pageSize: t.pagesize,
            currentPage: t.currentPage,
            str,
          },
        })
        .then((res) => {
          console.log(res);
          t.tableData2 = res.list;
          t.rows = res.rows;
          console.log(t.formInline.supply_name);
        })
        .catch((err) => {
          console.log(err);
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
  height: 600px;
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