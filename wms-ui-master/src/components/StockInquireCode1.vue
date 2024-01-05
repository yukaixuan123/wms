<template>
  <div id="kjj">
    <!--头部-->
    <div style="width: 1138px; height: 55px; border-bottom: 1px solid #eeeeee">
      <ul id="kcfbb">
        <li>{{ ff.name }}</li>
        <li>{{ ff.bh }}</li>
        <li>
          货品类型<span class="lll">{{ ff.lx }}</span>
        </li>
        <li>
          规格型号<span class="lll">{{ ff.gg }}</span>
        </li>
        <li>
          单位<span class="lll">{{ ff.dw }}</span>
        </li>
      </ul>
    </div>
    <div id="form">
      <el-form :inline="true" :model="formInline" class="demo-form-inline">
        <el-form-item label="出入库单号" id="form_top">
          <el-input
            v-model="formInline.hpname"
            id="tex"
            placeholder="请输入出库单号/入库单号"
          ></el-input>
        </el-form-item>
        <el-form-item label="业务类型" id="form_top">
          <el-select
            v-model="formInline.hptype"
            clearable
            filterable
            placeholder="请选择单位"
            id="bddd"
          >
            <el-option label="入库" value="入库"></el-option>
            <el-option label="出库" value="出库"></el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="仓库名称" id="form_top">
          <el-select
            v-model="formInline.ckname"
            clearable
            filterable
            placeholder="请选择仓库名称"
            id="bddd"
          >
            <el-option
              v-for="item in countryList"
              :key="item.warehouse_id"
              :label="item.ware_name"
              :value="item.ware_name"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="出入库类型" id="form_top">
          <el-select
            v-model="formInline.lx"
            clearable
            filterable
            placeholder="请选择出入库类型"
            id="bddd"
          >
            <el-option
              v-for="item in countryList2"
              :key="item"
              :label="item"
              :value="item"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="制单日期">
          <el-date-picker
            v-model="formInline.rq"
            id="bddd"
            type="datetime"
            placeholder="制单日期"
            value-format="yyyy-MM-dd HH:mm:ss"
          ></el-date-picker>
        </el-form-item>
        <el-form-item id="w">
          <el-button
            @click="search()"
            type="primary"
            id="tex1"
            icon="el-icon-search"
            >搜索</el-button
          >
          <el-button @click="reset()" id="tex2" icon="el-icon-refresh"
            >重置</el-button
          >
          <!-- <el-button type="primary" @click="search">高级搜索</el-button> -->
        </el-form-item>
      </el-form>
    </div>

    <div id="sandd1">
      <ul id="kcsll1">
        <li>
          <span
            style="font-size: 27px; font-weight: 700; color: #9031aa"
            id="ru"
          ></span>
        </li>
        <li>入库数量</li>
      </ul>
      <ul id="kcslll1">
        <li>
          <span
            style="font-size: 27px; font-weight: 700; color: #9031aa"
            id="rujin"
          ></span>
        </li>
        <li>入库金额</li>
      </ul>
    </div>
    <div id="sandd1">
      <ul id="kcsll1">
        <li>
          <span
            style="font-size: 27px; font-weight: 700; color: #538ff7"
            id="cu"
          ></span>
        </li>
        <li>出库数量</li>
      </ul>
      <ul id="kcslll1">
        <li>
          <span
            style="font-size: 27px; font-weight: 700; color: #538ff7"
            id="cujin"
          ></span>
        </li>
        <li>出库金额</li>
      </ul>
    </div>
    <div style="margin-top: 50px; margin-left: 30px">
      <el-button id="dcc" @click="dcc()" icon="el-icon-download"
        >导出</el-button
      >
      <el-button id="sxx" @click="sxx()" icon="el-icon-refresh">刷新</el-button>
      <el-table
        tooltip-effect="dark"
        @selection-change="handleSelectionChange"
        height="300px"
        :data="tableData"
        :header-cell-style="{
          background: '#F8F8F9',
          color: '#606266',
          'text-align': 'center',
        }"
        :cell-style="{ 'text-align': 'center' }"
        id="kct"
      >
        <el-table-column type="selection" width="55"> </el-table-column>
        <el-table-column fixed label="序号" type="index" width="50">
        </el-table-column>
        <el-table-column fixed prop="inbill_bh" label="出入库单号" width="100">
        </el-table-column>
        <el-table-column fixed prop="" label="出入库日期" width="150">
          <template slot-scope="scope">
            <span>{{ filterTime(scope.row.inbll_date) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="业务类型" width="100">
          <template slot-scope="scope">
            <span v-if="scope.row.out1 == 0">入库</span>
            <span v-else>出库</span>
          </template>
        </el-table-column>
        <el-table-column prop="inbill_type" label="出入库类型" width="100">
        </el-table-column>
        <el-table-column prop="ware_name" label="仓库名称" width="100">
        </el-table-column>
        <el-table-column prop="inbill_num" label="入库数量" width="100">
        </el-table-column>
        <el-table-column prop="outbill_num" label="出库数量" width="100">
        </el-table-column>
        <el-table-column prop="zong" label="入库金额" width="100">
        </el-table-column>
        <el-table-column prop="czong" label="出库金额" width="100">
        </el-table-column>
        <el-table-column prop="inbill_duty_man" label="经办人" width="100">
        </el-table-column>
        <el-table-column prop="create_by" label="制单人" width="100">
        </el-table-column>
        <el-table-column prop="" label="制单时间" width="150">
          <template slot-scope="scope">
            <span>{{ filterTime(scope.row.create_time) }}</span>
          </template>
        </el-table-column>
      </el-table>

      <!--分页-->
      <!-- <el-pagination
        id="fenyels1"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-sizes="[6, 12, 18, 24]"
        :page-size="pagesize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="rows"
      >
      </el-pagination> -->
    </div>
    <div id="notification-container">
      <div id="dibu">
        <el-button id="bcccc" @click="gb()">关闭</el-button>
      </div>
    </div>
  </div>
</template>

<script>
import $http from "../http/base.js";
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
      countryList: [],
      countryList2: [],
      formInline: {
        hpname: "",
        hptype: "",
        lx: "",
        ckname: "",
        rq: "",
      },
      ff: {
        name: "",
        bh: "",
        lx: "",
        gg: "",
        dw: "",
      },
      tableData: [],

      multipleSelection: [],
      str: "1=1",

      currentPage: 1, //当前页
      pagesize: 600, //每页显示数
      rows: 0, //总行数
    };
  },
  methods: {
    gb() {
      this.$router.go(-1);
    },
    //保留两位小数好
    formatMoney(value) {
      return value.toFixed(2);
    },
    //仓库下拉框
    CK() {
      var t = this;
      $http
        .get("http://localhost:5149/api/Bs_warehouse/Bs_warehouseSelect1")
        .then((res) => {
          t.countryList = res;
        })
        .catch((err) => {
          alert(err);
        });
      $http
        .get("http://localhost:5149/api/Wh_transfer_h/CRLX")
        .then((res) => {
          t.countryList2 = res;
        })
        .catch((err) => {
          alert(err);
        });
    },
    //查询
    find() {
      var bh = this.$route.query.bh;
      $http
        .get("http://localhost:5149/api/Wh_transfer_h/KCX?bh=" + bh)
        .then((res) => {
          this.ff.name = res.item_name;
          this.ff.bh = res.item_code;
          this.ff.lx = res.item_type_name;
          this.ff.dw = res.unit;
          this.ff.gg = res.model_code;
        })
        .catch((err) => {
          alert(err);
        });
    },
    //每页显示数改变事件
    handleSizeChange(size) {
      this.pagesize = size;
      this.currentPage = 1;
      this.find1();
    },
    //页码改变事件
    handleCurrentChange(page) {
      this.currentPage = page;
      this.find1();
    },
    find1() {
      var bh = this.$route.query.bh;
      this.str += "and item_code='" + bh + "'";
      $http
        .post(
          "http://localhost:5149/api/Wh_transfer_h/LiuFen?page=" +
            this.pagesize +
            "&pageSize=" +
            this.currentPage +
            "&str=" +
            this.str
        )
        .then((res) => {
          this.tableData = res.list;
          this.rows = res.rows;
          var ru = 0;
          var rujin = 0;
          var cu = 0;
          var cujin = 0;
          for (let i = 0; i < this.tableData.length; i++) {
            ru += this.tableData[i].inbill_num;
            rujin += this.tableData[i].zong;
            cu += this.tableData[i].outbill_num;
            cujin += this.tableData[i].czong;
          }
          document.getElementById("ru").innerHTML = ru;
          document.getElementById("rujin").innerHTML = rujin;
          document.getElementById("cu").innerHTML = cu;
          document.getElementById("cujin").innerHTML = cujin;
        })
        .catch((err) => {
          alert(err);
        });
    },

    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    //搜索
    search() {
      this.str = "item_code='" + this.ff.bh + "'";
      if (this.formInline.hpname != "") {
        this.str += "and inbill_bh = '" + this.formtable1.hpname + "'";
      }
      if (this.formInline.ckname != "") {
        this.str +=
          " AND ware_name like CONCAT('%','" +
          this.formInline.ckname +
          "','%') ";
      }
      if (this.formInline.hptype != "") {
        if (this.formInline.hptype == "入库") {
          this.str += " AND out1 is NULL ";
        }
        if (this.formInline.hptype == "出库") {
          this.str += " AND inbill_code is NULL ";
        }
      }
      if (this.formInline.lx != "") {
        this.str += " AND inbill_type =  '" + this.formInline.lx + "'";
      }
      if (this.formInline.rq != "" && this.formInline.rq != null) {
        const yearMonthDay = this.formInline.rq.substring(0, 10);
        this.str +=
          "and convert(varchar(50),create_time,120) LIKE  '" +
          yearMonthDay +
          "%'";
      }
      this.find1();
    },
    filterTime(timestamp) {
      return formatDate(timestamp);
    },

    //重置
    reset() {
      this.formInline = {
        hpname: "",
        hptype: "",
        dw: "",
        ckname: "",
        rq: "",
      };
    },
  },
  mounted() {
    this.find1();
    this.find();
    this.CK();
  },
};
</script>
<style scoped src="../CSS/public.css"></style>

<style>
#sandd1 {
  width: 477px;
  height: 110px;
  margin-top: 25px;
  margin-left: 65px;
  box-shadow: 0px 0px 3px rgba(0, 0, 0, 0.2);
  display: inline-block;
}
#kcsll1 {
  width: 220px;
  height: 70px;
  text-align: center;
  display: inline-block;
  line-height: 30px;
  font-size: 13px;
  margin-top: 25px;
}
#kcslll1 {
  width: 220px;
  height: 70px;
  text-align: center;
  display: inline-block;
  line-height: 30px;
  font-size: 13px;
  margin-top: 25px;
}

#kcfbb li {
  float: left;
  line-height: 55px;
  margin-left: 35px;
  font-size: 13px;
  position: relative;
  left: 30px;
}
#kcfbb li:nth-child(1) {
  font-size: 15px;
  font-weight: 700;
}
#kcfbb li:nth-child(2) {
  font-size: 15px;
  font-weight: 700;
}
#kcsl {
  width: 146px;
  height: 70px;
  text-align: center;
  display: inline-block;
  line-height: 30px;
  font-size: 13px;
  margin-top: 25px;
}
#kcsl1 {
  width: 146px;
  height: 70px;
  text-align: center;
  display: inline-block;
  line-height: 30px;
  font-size: 13px;
  margin-top: 25px;
}
#dcc {
  width: 28px !important;
  color: #fff;
  background-color: #9c27b0;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 30px;
  position: relative;
  top: -25px;
}
#kct {
  margin-left: 30px;
  width: 1025px;
}
#sxx {
  border: 1px solid #f9dcdc;
  color: #f29895;
  background-color: #fceeed;
  width: 28px !important;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
  position: relative;
  top: -25px;
}
#kjj {
  width: 1140px !important;
  height: 850px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
}
#sand {
  width: 296px;
  height: 110px;
  margin-top: 25px;
  margin-left: 65px;
  box-shadow: 0px 0px 3px rgba(0, 0, 0, 0.2);
  display: inline-block;
}
#form {
  margin-top: 15px;
  width: 1020px;
  box-shadow: 0px 1px 0px rgba(0, 0, 0, 0.2);
  margin-left: 65px;
}
#form_top {
  margin-right: 25px !important;
  margin-bottom: 12px;
}
.el-col-2 {
  width: 30px;
  text-align: center;
}
.el-form--inline .el-form-item__label {
  float: none;
  display: inline-block;
  font-weight: bold;
  font-size: 13px;
}
#fenyels {
  margin-top: 20px;
  text-align: center;
}
#fenyels1 {
  text-align: center;
  margin-top: 10px;
}
</style>