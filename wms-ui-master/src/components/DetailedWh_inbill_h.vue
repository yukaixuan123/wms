<template>
  <div>
    <div id="addss">
      <h3 style="margin-left: 35px; padding-top: 30px; display: inline-block">
        入库单号：{{ formInline.dh }}
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
            入库类型<i style="margin-left: 50px; color: #999999">{{
              formInline.lx
            }}</i>
          </td>

          <td>
            制单时间<i style="margin-left: 50px; color: #999999">{{
              filterTime(formInline.sj)
            }}</i>
          </td>

          <td>
            供应商<i style="margin-left: 50px; color: #999999">{{
              formInline.gys
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
            仓库名称<i style="margin-left: 50px; color: #999999">{{
              formInline.mc
            }}</i>
          </td>
          <td>
            进货日期<i style="margin-left: 50px; color: #999999">{{
              filterTime(formInline.date)
            }}</i>
          </td>
          <td>
            联系人<i style="margin-left: 50px; color: #999999">{{
              formInline.lxr
            }}</i>
          </td>
        </tr>
        <tr>
          <td>
            关联单号<i style="margin-left: 50px; color: #999999">{{
              formInline.gldh
            }}</i>
          </td>
          <td>
            联系方式<i style="margin-left: 50px; color: #999999">{{
              formInline.fs
            }}</i>
          </td>
          <td>
            经办人<i style="margin-left: 50px; color: #999999">{{
              formInline.jbr
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
        <el-tab-pane label="入库明细" style="margin-top: -10px" name="first">
          <el-button id="tex9" icon="el-icon-download">导出</el-button>
          <el-table
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
            height="300px"
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
            <el-table-column prop="area_code" label="入库仓位" width="100">
            </el-table-column>
            <el-table-column prop="buy_price" label="入库单价" width="100">
            </el-table-column>
            <el-table-column prop="inbill_num" label="入库数量" width="100">
            </el-table-column>
            <el-table-column prop="zong" label="入库金额" width="100">
            </el-table-column>
            <el-table-column prop="batch_no" label="批次号" width="100">
            </el-table-column>
            <el-table-column prop="remark" label="备注" width="180">
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
                >{{ yrksl }}</span
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
                >￥{{ zje }}</span
              >
            </p>
          </div>
        </el-tab-pane>
        <!-- <el-tab-pane label="操作记录" name="second">
                    <el-button id="tex9" icon="el-icon-download">导出</el-button>
                  
                 
                </el-tab-pane> -->
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
        lxr: "",
        fs: "",
        gldh: "",
        gys: "",
        sj: "",
        zt: "",
      },
      tableData: [],
      tableData1: [],
      tableData2: [],
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
    zt(i) {
      if (i == 0) return "待审核";
      if (i == 1) return "驳回";
      if (i == 2) return "已完成";
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
    //根据id查进货订单
    Jia() {
      var bh = this.$route.query.dh;

      $http
        .get("  http://localhost:5149/api/Wh_inbill_h/Wh_inbill_hMH?bh=" + bh)
        .then((res) => {
          this.formInline.dh = res.inbill_bh;
          this.formInline.gldh = res.buy_code;
          this.formInline.lx = res.inbill_type;
          this.formInline.mc = res.ware_name;
          this.formInline.date = res.inbll_date;
          this.formInline.bei = res.remark;
          this.formInline.lxr = res.link_man;
          this.formInline.fs = res.link_way;
          this.formInline.gys = res.supply_code;
          this.formInline.jbr = res.inbill_duty_man;
          this.formInline.sj = res.create_time;
          this.formInline.zt = res.inbill_state;
          this.ii = res.inbill_id;
        })
        .catch((err) => {
          alert(err);
        });
    },

    //进货明细
    find() {
      var bh = this.$route.query.dh;
      $http
        .get("  http://localhost:5149/api/Wh_inbill_h/Wh_inbill_dMH?bh=" + bh)
        .then((res) => {
          this.tableData = res;
          for (let i = 0; i < this.tableData.length; i++) {
            this.yrksl += this.tableData[i].inbill_num;
            this.zje += this.tableData[i].zong;
          }
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