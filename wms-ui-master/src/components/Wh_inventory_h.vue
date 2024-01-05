<template>
  <div id="kj">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">出入库管理</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>库存盘点</el-breadcrumb-item>
    </el-breadcrumb>
    <!--搜索-->

    <transition-group name="lyric">
      <div id="form" v-if="showDefaultAttr" key="1">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="盘点单号">
            <el-input
              v-model="formInline.dh"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="盘点类型">
            <el-select
              v-model="formInline.lx"
              id="tex"
              clearable
              filterable
              placeholder="请选择"
            >
              <el-option label="期初盘点" value="期初盘点"></el-option>
              <el-option label="存货盘点" value="存货盘点"></el-option>
              <el-option label="期末盘点" value="期末盘点"></el-option>
            </el-select>
          </el-form-item>

          <el-form-item label="盘点结果">
            <el-select
              v-model="formInline.ztai"
              id="tex"
              clearable
              filterable
              placeholder="请选择"
            >
              <el-option label="无盈亏" value="0"></el-option>
              <el-option label="有盈亏" value="1"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="仓库名称">
            <el-select
              v-model="formInline.mc"
              id="tex"
              clearable
              filterable
              placeholder="请选择"
            >
              <el-option
                v-for="item in countryList"
                :key="item.warehouse_id"
                :label="item.ware_name"
                :value="item.ware_name"
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
    </transition-group>

    <!--按钮-->
    <div id="an">
      <el-button id="tex3" icon="el-icon-plus" @click="insert()"
        >新增</el-button
      >
      <!-- <el-button  id="tex4"  icon="el-icon-edit">修改</el-button> -->
      <el-button
        id="tex5"
        @click="delAll()"
        icon="el-icon-delete"
        :disabled="multipleSelection.length == 0"
        >删除</el-button
      >
      <el-button
        id="tex7"
        :disabled="multipleSelection.length > 1"
        @click="sh()"
        icon="el-icon-setting"
        >审核</el-button
      >
    </div>

    <!--隐藏-->
    <div id="an1">
      <el-button
        icon="el-icon-upload"
        circle
        @click="daoru"
        title="导入"
      ></el-button>
      <el-button
        icon="el-icon-download"
        circle
        @click="daochu"
        title="导出"
      ></el-button>

      <el-button
        icon="el-icon-search"
        circle
        @click="showDefaultAttr = !showDefaultAttr"
        title="展开"
      ></el-button>
      <el-button
        icon="el-icon-refresh"
        circle
        @click="flushed"
        title="刷新"
      ></el-button>
    </div>
    <!-- 表单 -->
    <el-table
      height="450px"
      tooltip-effect="dark"
      v-loading="tableloading"
      @selection-change="handleSelectionChange"
      :data="tableData"
      :header-cell-style="{ background: '#F8F8F9', color: '#606266' }"
      id="tableMain"
      element-loading-text="拼命加载中"
      element-loading-spinner="el-icon-loading"
    >
      <el-table-column type="selection" width="55"> </el-table-column>

      <el-table-column fixed prop="outbill_code" label="盘点单号" width="120">
        <template slot-scope="{ row }">
          <router-link
            :to="{
              name: 'DetaileWh_inventory_h',
              query: { dh: row.inventory_code },
            }"
            style="color: #9c27b0"
            >{{ row.inventory_code }}</router-link
          >
        </template>
      </el-table-column>
      <el-table-column fixed label="盘点结果" width="100">
        <template slot-scope="scope">
          <span>{{ zt(scope.row.zt) }}</span>
        </template>
      </el-table-column>
      <el-table-column fixed label="状态" width="100">
        <template slot-scope="scope">
          <span
            v-if="scope.row.sure_state == 0"
            style="color: blue; font-weight: 600; font-size: 13px"
            >待审核</span
          >
          <span
            v-if="scope.row.sure_state == 1"
            style="color: red; font-weight: 600; font-size: 13px"
            >驳回</span
          >
          <span
            v-if="scope.row.sure_state == 2"
            style="color: green; font-weight: 600; font-size: 13px"
            >已完成</span
          >
        </template>
      </el-table-column>
      <el-table-column prop="ware_code" label="仓库名称" width="120">
      </el-table-column>
      <el-table-column prop="inventory_type" label="盘点类型" width="120">
      </el-table-column>
      <el-table-column label="盘点开始时间" width="180">
        <template slot-scope="scope">
          <span>{{ filterTime(scope.row.begin_date) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="盘点结束时间" width="180">
        <template slot-scope="scope">
          <span>{{ filterTime(scope.row.end_date) }}</span>
        </template>
      </el-table-column>

      <el-table-column prop="names" label="盘点货品" width="180">
        <template slot-scope="scope">
          <el-popover placement="top" trigger="hover">
            <p>{{ scope.row.names }}</p>
            <div slot="reference">
              {{ truncateString(scope.row.names, 10) }}
            </div>
          </el-popover>
        </template>
      </el-table-column>

      <el-table-column prop="total_buy_num" label="盘点数量" width="120">
      </el-table-column>
      <el-table-column label="盘盈数量" width="120">
        <template slot-scope="scope">
          <span style="color: green">{{ scope.row.total_y_num }}</span>
        </template>
      </el-table-column>
      <el-table-column label="盘亏数量" width="120">
        <template slot-scope="scope">
          <span style="color: red">{{ scope.row.total_k_num }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="total_price" label="盘点金额" width="120">
      </el-table-column>
      <el-table-column label="盘盈金额" width="120">
        <template slot-scope="scope">
          <span style="color: green">{{ scope.row.total_y_price }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="" label="盘亏金额" width="120">
        <template slot-scope="scope">
          <span style="color: red">{{ scope.row.total_k_price }}</span>
        </template>
      </el-table-column>

      <el-table-column prop="create_by" label="制单人" width="120">
      </el-table-column>
      <el-table-column label="制单时间" width="170">
        <template slot-scope="scope">
          <span>{{ filterTime(scope.row.create_time) }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="sure_man" label="经办人" width="120">
      </el-table-column>

      <el-table-column label="审核时间" width="170">
        <template slot-scope="scope">
          <span v-if="scope.row.sure_date != '0001-01-01T00:00:00'">{{
            filterTime(scope.row.sure_date)
          }}</span>
          <span v-else></span>
        </template>
      </el-table-column>

      <el-table-column label="操作" fixed="right" width="100">
        <template slot-scope="scope">
          <img
            src="../Images/bianji1.png"
            title="编辑"
            width="25px"
            height="25px"
            @click="handleEdit(scope.row)"
          />
          <img
            src="../Images/shanchu.png"
            width="28px"
            height="28px"
            style="margin-left: 5px"
            title="删除"
            @click="handleDelete(scope.row)"
          />
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <el-pagination
      id="fenye"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="currentPage"
      :page-sizes="[10, 20, 30, 40]"
      :page-size="pagesize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="rows"
    >
    </el-pagination>

    <!-- 审核 -->
    <el-dialog
      title="审核"
      :visible.sync="dialogFormVisible"
      width="430px"
      id="tjshh"
    >
      <el-form style="height: 225px">
        <el-form-item label="审核结果">
          <el-radio-group v-model="resource" id="dx" @change="updateTextBox">
            <el-radio v-model="resource" label="2" value="2">通过</el-radio>
            <el-radio label="1" value="1">驳回</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审核意见">
          <el-input type="textarea" id="yj" v-model="desc"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button id="gb1" @click="qx()">取 消</el-button>
        <el-button
          id="bc12"
          style="background-color: #9c27b0; color: #fff"
          @click="qd()"
          >确 定</el-button
        >
      </div>
    </el-dialog>
  </div>
</template>

<script>
import $http from "../http/base.js";
export default {
  data() {
    return {
      dialogFormVisible: false,
      desc: "",
      resource: "",
      str: "1=1",
      tableloading: false, //加载
      showDefaultAttr: true,
      multipleSelection: [], // 选中的行数据
      formInline: {
        dh: "",
        lx: "",
        ztai: "",
        mc: "",
      },
      countryList: [],
      tableData: [],
      currentPage: 1, //当前页
      pagesize: 10, //每页显示数
      rows: 0, //总行数
      id: 0,
      ii: "",
    };
  },
  methods: {
    updateTextBox(i) {
      this.desc = i === "2" ? "通过" : "驳回";
    },
    //导出
    daochu() {},
    //导入
    daoru() {},
    //取消审核
    qx() {
      this.dialogFormVisible = false;

      this.resource = "";
      this.desc = "";
    },
    //确定审核
    qd() {
      var user = localStorage.getItem("name");
      $http
        .put(
          "http://localhost:5149/api/Wh_inventory_h/Wh_inventory_hSH?name=" +
            user +
            "&zt=" +
            this.resource +
            "&desc=" +
            this.desc +
            "&ii=" +
            this.ii
        )
        .then((res) => {
          if (res) {
            this.$message({
              message: "审核成功！",
              type: "success",
            });
            this.dialogFormVisible = false;
            this.resource = "";
            this.desc = "";
            this.FenYe();
          }
        })
        .catch((err) => {
          alert(err);
        });
    },
    //审核
    sh() {
      if (this.multipleSelection.length == 0) {
        this.$notify.error({
          title: "错误",
          message: "请选择要进行审核的数据",
        });
        return;
      }

      for (let i = 0; i < this.multipleSelection.length; i++) {
        var zt = this.multipleSelection[i].sure_state;
        var ii = this.multipleSelection[i].inventory_code;
      }

      this.ii = ii;
      if (zt == 0) {
        this.dialogFormVisible = true;
      } else if (zt == 1) {
        this.$message({
          message: "无法执行该操作",
          type: "warning",
        });
        return;
      } else if (zt == 2) {
        this.$message({
          message: "无法执行该操作",
          type: "warning",
        });
        return;
      }
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
    },
    //新增
    insert() {
      this.$router.push("/AddWh_inventory_h");
    },
    //编辑
    handleEdit(i) {
      if (i.sure_state != 0) {
        this.$message({
          message: "无权限操作",
          type: "warning",
        });
        return;
      }
      this.$router.push("/UpdateWh_inventory_h?dh=" + i.inventory_code);
    },
    truncateString(str, length) {
      return str.length > length ? str.slice(0, length) + "..." : str;
    },

    //查询方法
    FenYe() {
      var t = this;
      $http
        .post(
          "http://localhost:5149/api/Wh_inventory_h/Fen?page=" +
            t.pagesize +
            "&pageSize=" +
            t.currentPage +
            "&str=" +
            t.str
        )
        .then((res) => {
          t.tableData = res.list;
          t.rows = res.rows;
        })
        .catch((err) => {
          alert(err);
        });
    },
    filterTime(timestamp) {
      return formatDate(timestamp);
    },
    zt(i) {
      if (i == 0) return "无盈亏";
      if (i == 1) return "有盈亏";
    },
    //重置
    reset() {
      this.formInline = {
        dh: "",
        ztai: "",
        mc: "",
        lx: "",
      };
    },

    //搜索
    search() {
      this.currentPage = 1;

      this.str = "1=1";
      if (this.formInline.dh != "") {
        this.str +=
          " AND inventory_code like CONCAT('%','" +
          this.formInline.dh +
          "','%') ";
      }
      if (this.formInline.lx != "") {
        this.str +=
          " AND inventory_type like CONCAT('%','" +
          this.formInline.lx +
          "','%') ";
      }
      if (this.formInline.ztai != "") {
        this.str +=
          " AND zt like CONCAT('%','" + this.formInline.ztai + "','%') ";
      }
      if (this.formInline.mc != "") {
        this.str +=
          " AND ware_code like CONCAT('%','" + this.formInline.mc + "','%') ";
      }

      this.FenYe();
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    //删除
    handleDelete(i) {
      if (i.sure_state == 2) {
        this.$message({
          message: "无权限操作",
          type: "warning",
        });
        return;
      }
      this.$confirm("此操作将永久删除该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          $http
            .put(
              "   http://localhost:5149/api/Wh_inventory_h/Wh_inventory_hDelete?addStudenDto=" +
                i.inventory_code
            )
            .then((res) => {
              if (res) {
                this.$message({
                  message: "删除成功！",
                  type: "success",
                });
                this.FenYe();
              }
            })
            .catch((err) => {
              alert(err);
            });
        })
        .catch(() => {
          this.$message({
            type: "error",
            message: "已取消删除",
          });
        });
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
    //刷新table
    flushed() {
      this.tableloading = true;
      // 模拟获取接口数据
      setTimeout(() => {
        //调用find();this.find();
        this.tableloading = false;
      }, 1000);
      //直接this.查询方法();
    },
    //批量删除
    delAll() {
      var strs = [];
      for (let i = 0; i < this.multipleSelection.length; i++) {
        strs.push(this.multipleSelection[i].inventory_h_id);
        if (this.multipleSelection[i].sure_state == 2) {
          this.$message({
            message: "请选择正确的记录",
            type: "warning",
          });
          return;
        }
      }
      console.log(this.multipleSelection);
      $http
        .put(
          " http://localhost:5149/api/Wh_inventory_h/Wh_inventory_hDeleteS/route",
          strs
        )
        .then((res) => {
          if (res) {
            this.$message({
              message: "删除成功！",
              type: "success",
            });
            this.FenYe();
          }
        })
        .catch((err) => {
          alert(err);
        });
    },
  },
  mounted() {
    this.tableloading = true;
    // 模拟获取接口数据
    setTimeout(() => {
      this.FenYe();
      this.tableloading = false;
    }, 500);

    this.CK();
  },
};
export function formatDate(date) {
  let time = new Date(date);

  let year = time.getFullYear();

  let month = time.getMonth() + 1;
  month = month.toString().padStart(2, "0");
  let day = time.getDate().toString().padStart(2, "0");
  let hours = time.getHours().toString().padStart(2, "0");
  let minutes = time.getMinutes().toString().padStart(2, "0");
  let seconds = time.getSeconds().toString().padStart(2, "0");
  return (
    year +
    "/" +
    month +
    "/" +
    day +
    "/" +
    " " +
    hours +
    ":" +
    minutes +
    ":" +
    seconds
  );
}
</script>
<style scoped src="../CSS/public.css"></style>
<style src="../CSS/tableys.css"></style>

<style>
#w {
  margin-left: 20px;
}

#card {
  height: 35px;
  line-height: 35px;
  margin-left: 20px;
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

#tex {
  width: 240px;
  height: 32px;
}

#tex1 {
  width: 28px !important;
  color: #fff;
  background-color: #409eff;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
}

#tex2 {
  width: 28px !important;
  color: #000;
  background-color: #fff;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
}

#tex3 {
  border: 1px solid #add2fb;
  color: #448ef8;
  background-color: #eaf4fe;
  width: 28px !important;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
}

#tex4 {
  border: 1px solid #d7f4e1;
  color: #8edfa8;
  background-color: #ebf9f1;
  width: 28px !important;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
}

#tex5 {
  border: 1px solid #f9dcdc;
  color: #f29895;
  background-color: #fceeed;
  width: 28px !important;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
}

#tex6 {
  border: 1px solid #fae4a2;
  color: #f8c341;
  background-color: #fef8e8;
  width: 28px !important;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
}

#tex7 {
  border: 1px solid #d3d4d6;
  color: #919398;
  background-color: #f4f4f5;
  width: 28px !important;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
}

#tex3:hover {
  background-color: #409eff;
  color: #fff;
}

#tex4:hover {
  background-color: #5fcb71;
  color: #fff;
}

#tex5:hover {
  background-color: #ff4949;
  color: #fff;
}

#tex6:hover {
  background-color: #f5bd41;
  color: #fff;
}

#tex7:hover {
  background-color: #919398;
  color: #fff;
}

#an1 {
  float: right;
  position: relative;
  top: 9px;
  right: 64px;
}

.lyric-enter,
.lyric-leave-to {
  opacity: 0;
  transform: translateY(15px);
}

.lyric-enter-to,
.lyric-leave {
  opacity: 1;
}

.lyric-enter-active,
.lyric-leave-active {
  transition: all 0.4s ease-out;
}
</style>