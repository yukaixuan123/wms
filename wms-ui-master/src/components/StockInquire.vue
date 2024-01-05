<template>
  <div id="kjj">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">统计报表</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>库存查询</el-breadcrumb-item>
    </el-breadcrumb>

    <div id="form">
      <el-form :inline="true" :model="formInline" class="demo-form-inline">
        <el-form-item label="货品" id="form_top">
          <el-input
            v-model="formInline.hpname"
            id="tex"
            placeholder="请输入货品名称/编号"
          ></el-input>
        </el-form-item>
        <el-form-item label="货品类型" id="form_top">
          <el-select
            v-model="formInline.hptype"
            clearable
            filterable
            placeholder="请选择货品类型"
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

        <el-form-item label="仓库名称" id="form_top">
          <el-select
            v-model="formInline.ckname"
            clearable
            filterable
            placeholder="仓库名称"
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
        <el-form-item label="单位" id="form_top">
          <el-select
            v-model="formInline.dw"
            clearable
            filterable
            placeholder="请选择单位"
            id="bddd"
          >
            <el-option
              v-for="item in countryList1"
              :key="item"
              :label="item"
              :value="item"
            ></el-option>
          </el-select>
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

    <div id="sand">
      <ul id="kcsl">
        <li>
          <span
            style="font-size: 27px; font-weight: 700; color: #9031aa"
            id="k"
          ></span>
        </li>
        <li>当前库存数量</li>
      </ul>
      <ul id="kcsl1">
        <li>
          <span
            style="font-size: 27px; font-weight: 700; color: #9031aa"
            id="k1"
          ></span>
        </li>
        <li>当前库存金额</li>
      </ul>
    </div>
    <div id="sand">
      <ul id="kcsl">
        <li>
          <span
            style="font-size: 27px; font-weight: 700; color: #5fcb71"
            id="k4"
          ></span>
        </li>
        <li>可用库存数量</li>
      </ul>
      <ul id="kcsl1">
        <li>
          <span
            style="font-size: 27px; font-weight: 700; color: #f3b23e"
            id="k5"
          ></span>
        </li>
        <li>可用库存金额</li>
      </ul>
    </div>
    <div id="sand">
      <ul id="kcsl">
        <li>
          <span
            style="font-size: 27px; font-weight: 700; color: #5fcb71"
            id="k2"
          ></span>
        </li>
        <li>待入库</li>
      </ul>
      <ul id="kcsl1">
        <li>
          <span
            style="font-size: 27px; font-weight: 700; color: #f3b23e"
            id="k3"
          ></span>
        </li>
        <li>待出库</li>
      </ul>
    </div>
    <div style="margin-top: 50px; margin-left: 30px">
      <el-button id="dcc" @click="dcc()" icon="el-icon-download"
        >导出</el-button
      >
      <el-button id="sxx" @click="sxx()" icon="el-icon-refresh">刷新</el-button>
      <el-table
        tooltip-effect="dark"
        v-loading="tableloading"
        height="350px"
        @selection-change="handleSelectionChange"
        element-loading-text="拼命加载中"
        element-loading-spinner="el-icon-loading"
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
        <el-table-column fixed prop="item_code" label="货品编号" width="90">
        </el-table-column>
        <el-table-column fixed prop="item_name" label="货品名称" width="80">
        </el-table-column>
        <el-table-column fixed prop="" label="状态" width="80">
          <template slot-scope="scope">
            <span>{{ zt(scope.row.inbill_state) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="item_type_name" label="货品类型" width="80">
        </el-table-column>
        <el-table-column prop="model_code" label="规格型号" width="80">
        </el-table-column>
        <el-table-column prop="unit" label="单位" width="80"> </el-table-column>

        <el-table-column prop="ware_code" label="仓库名称" width="80">
        </el-table-column>
        <el-table-column prop="area_code" label="仓位名称" width="80">
        </el-table-column>
        <el-table-column prop="inbill3_num" label="当前库存" width="80">
        </el-table-column>
        <el-table-column prop="jin" label="库存金额" width="80">
          <template slot-scope="scope">
            <span>{{ formatMoney(scope.row.jin) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="ru" label="待入库" width="80"> </el-table-column>
        <el-table-column prop="cu" label="待出库" width="80"> </el-table-column>
        <el-table-column prop="ky" label="可用库存" width="80">
        </el-table-column>
        <el-table-column prop="" label="可用库存金额" width="120">
          <template slot-scope="scope">
            <span>{{ formatMoney(scope.row.kyjin) }}</span>
          </template>
        </el-table-column>

        <el-table-column label="操作" fixed="right" width="160">
          <template slot-scope="scope">
            <a
              href="javascript:void(0)"
              style="font-size: 13px; color: #9031aa"
              @click="handlels(scope.row.item_code)"
              >出入库流水</a
            >
            <a
              href="javascript:void(0)"
              style="font-size: 13px; color: green; margin-left: 10px"
              @click="handlefb(scope.row.item_code)"
              >库存分布</a
            >
          </template>
        </el-table-column>
      </el-table>
      <div
        style="
          border: 1px solid #eeeeee;
          width: 1022px;
          height: 45px;
          display: inline-block;
          margin-left: 30px;
        "
      >
        <span style="line-height: 45px; font-size: 14px; margin-left: 25px"
          >合计</span
        >
        <p style="float: right">
          <span style="line-height: 45px; font-size: 14px">当前库存：</span>
          <span
            style="
              line-height: 45px;
              font-weight: bold;
              color: red;
              font-size: 14px;
              margin-right: 35px;
            "
            id="k6"
          ></span>
          <span style="line-height: 45px; font-size: 14px">库存金额：</span>
          <span
            style="
              line-height: 45px;
              font-weight: bold;
              color: red;
              font-size: 14px;
              margin-right: 35px;
            "
            id="k7"
          ></span>
          <span style="line-height: 45px; font-size: 14px">待入库：</span>
          <span
            style="
              line-height: 45px;
              font-weight: bold;
              color: red;
              font-size: 14px;
              margin-right: 35px;
            "
            id="k8"
          ></span>
          <span style="line-height: 45px; font-size: 14px">待出库：</span>
          <span
            style="
              line-height: 45px;
              font-weight: bold;
              color: red;
              font-size: 14px;
              margin-right: 35px;
            "
            id="k9"
          ></span>
          <span style="line-height: 45px; font-size: 14px">可用库存：</span>
          <span
            style="
              line-height: 45px;
              font-weight: bold;
              color: red;
              font-size: 14px;
              margin-right: 35px;
            "
            id="k10"
          ></span>
          <span style="line-height: 45px; font-size: 14px">可用库存金额：</span>
          <span
            style="
              line-height: 45px;
              font-weight: bold;
              color: red;
              font-size: 14px;
              margin-right: 30px;
            "
            id="k11"
            >￥</span
          >
        </p>
      </div>
      <!--分页-->
      <!-- <el-pagination
        id="fenyels"
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
  </div>
</template>

<script>
import $http from "../http/base.js";
export function formatDate(date) {
  let time = new Date(date);
  console.log(time);
  let year = time.getFullYear();
  console.log(year);
  let month = time.getMonth() + 1;
  month = month.toString().padStart(2, "0");
  let day = time.getDate().toString().padStart(2, "0");
  return year + "年" + month + "月" + day + "日";
}
export default {
  data() {
    return {
      formInline: {
        hpname: "",
        hptype: "",
        dw: "",
        ckname: "",
      },

      countryList1: [],
      countryList: [],
      countryList2: [],
      tableData: [],
      multipleSelection: [],
      tableloading: false, //加载
      str: "1=1",
      currentPage: 1, //当前页
      pagesize: 600, //每页显示数
      rows: 0, //总行数
    };
  },
  methods: {
    //保留两位小数好
    formatMoney(value) {
      return value.toFixed(2);
    },
    zt(i) {
      if (i == 0) return "开启";
      if (i == 1) return "禁用";
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
      var t = this;
      $http
        .get("http://localhost:5149/api/Wh_transfer_h/DW")
        .then((res) => {
          t.countryList1 = res;
        })
        .catch((err) => {
          alert(err);
        });
      $http
        .get("http://localhost:5149/api/Wh_transfer_h/LX")
        .then((res) => {
          t.countryList2 = res;
        })
        .catch((err) => {
          alert(err);
        });
    },
    //出入库流水
    handlels(idd) {
      this.$router.push("/StockInquireCode1?bh=" + idd);
    },
    //库存分布
    handlefb(idd) {
      this.$router.push("/StockInquireCode?bh=" + idd);
    },
    //每页显示数改变事件
    handleSizeChange(size) {
      this.pagesize = size;
      this.currentPage = 1;
      this.find();
    },
    //页码改变事件
    handleCurrentChange(page) {
      this.currentPage = page;
      this.find();
    },
    //查询
    find() {
      var t = this;

      $http
        .post(
          "http://localhost:5149/api/Wh_transfer_h/KuFen?page=" +
            t.pagesize +
            "&pageSize=" +
            t.currentPage +
            "&str=" +
            t.str
        )
        .then((res) => {
          t.tableData = res.list;
          t.rows = res.rows;
          var k = 0;
          var k1 = 0;
          var k2 = 0;
          var k3 = 0;
          var k4 = 0;
          var k5 = 0;
          for (let i = 0; i < this.tableData.length; i++) {
            k += this.tableData[i].inbill3_num;
            k1 += this.tableData[i].jin;
            k2 += this.tableData[i].ru;
            k3 += this.tableData[i].cu;
            k4 += this.tableData[i].ky;
            k5 += this.tableData[i].kyjin;
          }
          document.getElementById("k").innerHTML = k;
          document.getElementById("k1").innerHTML = k1;
          document.getElementById("k2").innerHTML = k2;
          document.getElementById("k3").innerHTML = k3;
          document.getElementById("k4").innerHTML = k4;
          document.getElementById("k5").innerHTML = k5;
          document.getElementById("k6").innerHTML = k;
          document.getElementById("k7").innerHTML = k1;
          document.getElementById("k8").innerHTML = k2;
          document.getElementById("k9").innerHTML = k3;
          document.getElementById("k10").innerHTML = k4;
          document.getElementById("k11").innerHTML = k5;
        })
        .catch((err) => {
          alert(err);
        });
    },

    sxx() {
      this.tableloading = true;
      // 模拟获取接口数据
      setTimeout(() => {
        //调用find();
        this.find();
        this.tableloading = false;
      }, 1000);
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    //搜索
    search() {
      this.str = "1=1";
      if (this.formInline.hpname != "") {
        this.str +=
          "and item_code like '%" +
          this.formtable1.hpname +
          "%' or item_name like '%" +
          this.formtable1.hpname +
          "%' ";
      }
      if (this.formInline.ckname != "") {
        this.str +=
          " AND ware_code like CONCAT('%','" +
          this.formInline.ckname +
          "','%') ";
      }
      if (this.formInline.hptype != "") {
        this.str +=
          " AND item_type_name like CONCAT('%','" +
          this.formInline.hptype +
          "','%') ";
      }
      if (this.formInline.dw != "") {
        this.str +=
          " AND unit like CONCAT('%','" + this.formInline.dw + "','%') ";
      }

      this.find();
    },
    //重置
    reset() {
      this.formInline = {
        hpname: "",
        hptype: "",
        dw: "",
        ckname: "",
      };
    },
  },
  mounted() {
    this.tableloading = true;
    // 模拟获取接口数据
    setTimeout(() => {
      //调用find();
      this.find();
      this.tableloading = false;
    }, 500);
    this.CK();
  },
};
</script>
<style scoped src="../CSS/public.css"></style>

<style>
* {
  margin: 0;
  padding: 0;
  text-decoration: none;
  list-style: none;
  outline: none;
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
</style>