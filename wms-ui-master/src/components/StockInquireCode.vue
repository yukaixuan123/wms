<template>
  <div id="kjjls">
    <div style="width: 1138px; height: 55px; border-bottom: 1px solid #eeeeee">
      <ul id="kcfb">
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
    <div id="sandd">
      <ul id="kcsll">
        <li>
          <span style="font-size: 27px; font-weight: 700; color: #9031aa">{{
            ff.dang
          }}</span>
        </li>
        <li>当前库存</li>
      </ul>
      <ul id="kcslll">
        <li>
          <span style="font-size: 27px; font-weight: 700; color: #9031aa">{{
            ff.ke
          }}</span>
        </li>
        <li>可用库存</li>
      </ul>
    </div>
    <div id="sandd">
      <ul id="kcsll">
        <li>
          <span style="font-size: 27px; font-weight: 700; color: #f3b23e">{{
            ff.cu
          }}</span>
        </li>
        <li>待出库</li>
      </ul>
      <ul id="kcslll">
        <li>
          <span style="font-size: 27px; font-weight: 700; color: #5fcb71">{{
            ff.ru
          }}</span>
        </li>
        <li>待入库</li>
      </ul>
    </div>
    <div style="margin-top: 50px; margin-left: 30px">
      <el-button id="lsdcc" @click="dcc()" icon="el-icon-download"
        >导出</el-button
      >
      <el-button id="lssxx" @click="sxx()" icon="el-icon-refresh"
        >刷新</el-button
      >
      <el-table
        height="300px"
        tooltip-effect="dark"
        v-loading="tableloading"
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
        id="kcfbbls"
      >
        <el-table-column type="selection" width="55"> </el-table-column>
        <el-table-column label="序号" type="index" width="125">
        </el-table-column>
        <el-table-column prop="item_name" label="货品名称" width="125">
        </el-table-column>
        <el-table-column prop="ware_code" label="仓库名称" width="125">
        </el-table-column>
        <el-table-column prop="area_code" label="仓位名称" width="125">
        </el-table-column>
        <el-table-column prop="inbill3_num" label="当前库存" width="125">
        </el-table-column>
        <el-table-column prop="ky" label="可用库存" width="134">
        </el-table-column>
        <el-table-column prop="ru" label="待入库" width="130">
        </el-table-column>
        <el-table-column prop="cu" label="待出库" width="130">
        </el-table-column>
      </el-table>
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
      multipleSelection: [],
      tableloading: false,
      tableData: [],
      ff: {
        name: "",
        bh: "",
        lx: "",
        gg: "",
        dw: "",
        dang: 0,
        ke: 0,
        ru: 0,
        cu: 0,
      },
    };
  },
  methods: {
    sxx() {
      this.tableloading = true;
      // 模拟获取接口数据
      setTimeout(() => {
        //调用find();
        this.find();
        this.tableloading = false;
      }, 1000);
    },
    //查询
    find() {
      var bh = this.$route.query.bh;
      $http
        .get("http://localhost:5149/api/Wh_transfer_h/KCXX?bh=" + bh)
        .then((res) => {
          this.tableData = res;
          for (let i = 0; i < res.length; i++) {
            this.ff.name = this.tableData[i].item_name;
            this.ff.bh = this.tableData[i].item_code;
            this.ff.lx = this.tableData[i].item_type_name;
            this.ff.dw = this.tableData[i].unit;
            this.ff.gg = this.tableData[i].model_code;
            this.ff.ru += this.tableData[i].ru;
            this.ff.cu += this.tableData[i].cu;
            this.ff.dang += this.tableData[i].inbill3_num;
            this.ff.ke += this.tableData[i].ky;
          }
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
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    //时间格式化
    filterTime(timestamp) {
      return formatDate(timestamp);
    },
  },
  mounted() {
    this.find();
  },
};
</script>

<style>
#kcfbbls {
  width: 1075px;
}
#lsdcc {
  width: 28px !important;
  color: #fff;
  background-color: #9c27b0;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 2px;
  position: relative;
  top: -25px;
}
#lssxx {
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
#sandd {
  width: 517px;
  height: 110px;
  margin-top: 25px;
  margin-left: 35px;
  box-shadow: 0px 0px 3px rgba(0, 0, 0, 0.2);
  display: inline-block;
}
#kcsll {
  width: 250px;
  height: 70px;
  text-align: center;
  display: inline-block;
  line-height: 30px;
  font-size: 13px;
  margin-top: 25px;
}
#kcslll {
  width: 250px;
  height: 70px;
  text-align: center;
  display: inline-block;
  line-height: 30px;
  font-size: 13px;
  margin-top: 25px;
}
#kcfb li {
  float: left;
  line-height: 55px;
  margin-left: 35px;
  font-size: 13px;
}
#kcfb li:nth-child(1) {
  font-size: 15px;
  font-weight: 700;
}
#kjjls {
  width: 1140px !important;
  height: 600px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
}
#kcfb li:nth-child(2) {
  font-size: 15px;
  font-weight: 700;
}
.lll {
  padding-left: 25px;
  font-size: 13px;
  color: #b6b6b6;
}
</style>