<template>
  <div>
    <div id="addss">
      <h3 style="margin-left: 35px; padding-top: 30px; display: inline-block">
        仓库单号：{{ formInline.ware_code }}
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
            提交人<i style="margin-left: 50px; color: #999999">{{
              formInline.create_by
            }}</i>
          </td>

          <td>
            操作时间<i style="margin-left: 50px; color: #999999">{{
              formInline.create_time
            }}</i>
          </td>

          <td>
            更新时间<i style="margin-left: 50px; color: #999999">{{
              formInline.update_time
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
            仓库编号<i style="margin-left: 50px; color: #999999">{{
              formInline.ware_code
            }}</i>
          </td>
          <td>
            仓库名称<i style="margin-left: 50px; color: #999999">{{
              formInline.ware_name
            }}</i>
          </td>
          <td>
            仓库容量/立方<i style="margin-left: 50px; color: #999999">{{
              formInline.ware_cap
            }}</i>
          </td>

          <td>
            库位数量<i style="margin-left: 50px; font-weight: bold">{{
              formInline.sum
            }}</i>
          </td>
        </tr>
        <tr>
          <td>
            仓库主管<i style="margin-left: 50px; color: #999999">{{
              formInline.ware_duty_man
            }}</i>
          </td>
          <td>
            联系电话<i style="margin-left: 50px; color: #999999">{{
              formInline.dh
            }}</i>
          </td>

          <td>
            仓库地址<i style="margin-left: 65px; color: #999999">{{
              formInline.ware_adr
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
        <el-tab-pane label="库位信息" name="first">
          <el-button id="tex9" icon="el-icon-download">导出</el-button>
          <el-button
            id="oo"
            @click="qi()"
            :disabled="multipleSelection.length == 0"
            icon="el-icon-switch-button"
            >启用</el-button
          >
          <el-button
            id="qq"
            @click="ting()"
            :disabled="multipleSelection.length == 0"
            icon="el-icon-close"
            >停用</el-button
          >
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
            height="330px"
            @selection-change="handleSelectionChange"
          >
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column
              fixed
              prop="ware_area_id"
              label="序号"
              type="index"
              width="100"
            >
            </el-table-column>
            <el-table-column
              fixed
              prop="area_code"
              label="库位编号"
              width="120"
            >
            </el-table-column>
            <el-table-column
              fixed
              prop="area_name"
              label="库位名称"
              width="120"
            >
            </el-table-column>
            <el-table-column
              fixed
              prop="area_cap"
              label="仓库容量/立方"
              width="140"
            >
            </el-table-column>
            <el-table-column
              prop="area_duty_man"
              label="仓位主管"
              width="120px"
            >
            </el-table-column>
            <el-table-column prop="sort_code" label="排序" width="120">
            </el-table-column>
            <el-table-column prop="area_state" label="库位状态" width="120">
              <template slot-scope="scope">
                <span
                  v-if="scope.row.area_state == 0"
                  style="color: blue; font-weight: 600; font-size: 13px"
                  >启用</span
                >
                <span
                  v-if="scope.row.area_state == 1"
                  style="color: red; font-weight: 600; font-size: 13px"
                  >停用</span
                >
              </template>
            </el-table-column>
            <el-table-column prop="remark" label="备注" width="190">
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
        ware_code: "",
        ware_name: "",
        ware_cap: "",
        ware_adr: "",
        ware_duty_man: "",
        create_by: "",
        create_time: "",
        sum: "",
        update_time: "",
        update_by: "",
        dh: "",
        remark: "",
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
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    FenYe() {
      var t = this;
      str = "warehouse_id='" + this.$route.query.dh + "'";
      $http
        .post(
          "http://localhost:5149/api/Bs_ware_area/FenYeWareArea?currentPage=" +
            t.currentPage +
            "&pageSize=" +
            t.pagesize +
            "&str=" +
            str +
            ""
        )
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

    czr() {
      $http
        .post("http://localhost:5149/api/SupplyView/Czr")
        .then((res) => {
          this.List = res;
          console.log(res);
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
      var t = this;
      var bh = this.$route.query.dh;

      $http
        .get("http://localhost:5149/api/Bs_warehouse/SelectCode?id=" + bh)
        .then((res) => {
          t.formInline.ware_code = res.ware_code;
          t.formInline.ware_name = res.ware_name;
          t.formInline.ware_cap = res.ware_cap;
          t.formInline.ware_adr = res.ware_adr;
          t.formInline.ware_duty_man = res.ware_duty_man;
          t.formInline.dh = res.dh;
          t.formInline.create_by = res.create_by;
          t.formInline.zt = res.ware_state;
          t.formInline.create_time = res.create_time;
          t.formInline.sum = res.sum;
          t.formInline.update_time = res.update_time;
          t.formInline.dh = res.dh;
          t.formInline.remark = res.remark;
          console.log(res);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    ting() {
      this.$confirm("此操作将停用该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          const length = this.multipleSelection.length;
          var ss = [];
          for (let i = 0; i < this.multipleSelection.length; i++) {
            ss.push(this.multipleSelection[i].ware_area_id);
          }
          console.log("lo" + length);
          $http
            .put("http://localhost:5149/api/Bs_warehouse/PLTingHouse", ss)
            .then((res) => {
              if (res) {
                this.$message({
                  message: "停用成功！",
                  type: "success",
                });
                this.FenYe();
              }
            })
            .catch((err) => {
              console.log(err);
            });
        })
        .catch(() => {
          this.$message({
            type: "error",
            message: "已取消停用",
          });
        });
    },
    qi() {
      this.$confirm("此操作将启用该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          const length = this.multipleSelection.length;
          var ss = [];
          for (let i = 0; i < this.multipleSelection.length; i++) {
            ss.push(this.multipleSelection[i].ware_area_id);
          }
          console.log("lo" + length);
          $http
            .put("http://localhost:5149/api/Bs_warehouse/PLQiHouse", ss)
            .then((res) => {
              if (res) {
                this.$message({
                  message: "启用成功！",
                  type: "success",
                });
                this.FenYe();
              }
            })
            .catch((err) => {
              console.log(err);
            });
        })
        .catch(() => {
          this.$message({
            type: "error",
            message: "已取消启用",
          });
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
    this.FenYe();
    this.czr();
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
#oo {
  border: 1px solid #69cee0;
  color: #66d4d4;
  background-color: #c5e9ee;
  width: 28px !important;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
  margin-top: 25px;
}
#oo:hover {
  background-color: #6ea9c5;
  color: rgb(230, 240, 238);
}
#qq {
  border: 1px solid #9369e0;
  color: #9a8cd8;
  background-color: #d8c5ee;
  width: 28px !important;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
  margin-top: 25px;
}
#qq:hover {
  background-color: #886ec5;
  color: rgb(231, 230, 240);
}
#tex9:hover {
  background-color: #f5bd41;
  color: #fff;
}
</style>