<template>
  <div id="kj">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">来往单位</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>供应商管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!--搜索-->

    <transition-group name="lyric">
      <div id="form" v-if="showDefaultAttr" key="1">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="供应商" id="form_top">
            <el-input
              v-model="formInline.gys"
              id="tex"
              placeholder="请输入供应商名称/编号"
            ></el-input>
          </el-form-item>
          <el-form-item label="状态" id="form_top">
            <el-select v-model="formInline.zt" id="tex" placeholder="请选择">
              <el-option label="启用" value="0"></el-option>
              <el-option label="停用" value="1"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="所属行业" id="form_top">
            <el-select v-model="formInline.hy" id="tex" placeholder="请选择">
              <el-option
                v-for="item in List1"
                :key="item.line_type"
                :label="item.line_type"
                :value="item.line_type"
              ></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="进货负责人" prop="startDate">
            <el-select v-model="formInline.ren" id="tex" placeholder="请输入">
              <el-option
                v-for="item in List"
                :key="item.u_id"
                :label="item.u_True_name"
                :value="item.u_id"
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
      <el-button id="tex3" icon="el-icon-plus" @click="handleEdit()"
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
      <el-button id="tex7" icon="el-icon-upload2">导入</el-button>
      <el-button id="tex6" icon="el-icon-download">导出</el-button>
    </div>
    <!--隐藏-->
    <div id="an1">
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
      tooltip-effect="dark"
      v-loading="tableloading"
      @selection-change="handleSelectionChange"
      :data="tableData"
      height="450px"
      :header-cell-style="{ background: '#F8F8F9', color: '#606266' }"
      id="tableMain"
    >
      <el-table-column type="selection" width="55"> </el-table-column>
      <el-table-column fixed prop="supply_id" label="序号" width="50">
      </el-table-column>
      <el-table-column fixed prop="supply_code" label="供应商编码" width="120">
        <template slot-scope="{ row }">
          <router-link
            :to="{ name: 'supplyXiang', query: { dh: row.supply_name } }"
            style="color: #9c27b0"
            >{{ row.supply_code }}</router-link
          >
        </template>
      </el-table-column>
      <el-table-column fixed prop="supply_name" label="供应商" width="100">
      </el-table-column>
      <el-table-column prop="line_type" label="所属行业" width="100">
      </el-table-column>
      <el-table-column prop="supply_type_code" label="供应商分类" width="120">
      </el-table-column>
      <el-table-column prop="link_man" label="联系人" width="100">
      </el-table-column>
      <el-table-column prop="link_tel" label="联系电话" width="120">
      </el-table-column>
      <el-table-column prop="e_mail" label="电子邮箱" width="160">
      </el-table-column>
      <el-table-column prop="stock_duty_man" label="进货负责人" width="130">
      </el-table-column>
      <el-table-column prop="inbill_state" label="状态" width="60">
        <template slot-scope="scope">
          <span
            v-if="scope.row.inbill_state == 0"
            style="color: blue; font-weight: 600; font-size: 13px"
            >启用</span
          >
          <span
            v-if="scope.row.inbill_state == 1"
            style="color: red; font-weight: 600; font-size: 13px"
            >停用</span
          >
        </template>
      </el-table-column>
      <el-table-column prop="supply_adr" label="供应商地址" width="250">
      </el-table-column>
      <el-table-column prop="finance_name" label="账号名称" width="120">
      </el-table-column>
      <el-table-column prop="tax_no" label="纳税人识别号" width="120">
      </el-table-column>
      <el-table-column prop="bank_no" label="银行账户" width="200">
      </el-table-column>
      <el-table-column prop="open_bank" label="开户银行" width="120">
      </el-table-column>
      <el-table-column prop="open_adr" label="开户行地址" width="200">
      </el-table-column>
      <el-table-column prop="operatoro" label="操作人" width="120">
      </el-table-column>
      <el-table-column prop="opetime" label="操作时间" width="140">
        <template slot-scope="scope">
          <span>{{ filterTime(scope.row.opetime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" fixed="right" width="100">
        <template slot-scope="scope">
          <img
            src="../Images/bianji1.png"
            width="25px"
            height="25px"
            title="编辑"
            @click="update(scope.row.supply_id)"
          />
          <img
            src="../Images/shanchu.png"
            style="margin-left: 10px"
            width="28px"
            height="28px"
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
  </div>
</template>
  
<script>
import $http from "../http/base.js";
var tj = "1 = 1 and is_del = '0'";
export default {
  data() {
    return {
      tableloading: false, //加载
      showDefaultAttr: true,
      multipleSelection: [], // 选中的行数据
      formInline: {
        gys: "",
        zt: "",
        hy: "",
        ren: "",
      },
      tableData: [],
      List1: [],
      currentPage: 1, //当前页
      pagesize: 10, //每页显示数
      rows: 0, //总行数
      tj,
      List: [],
      bl: "1",
    };
  },
  methods: {
    //查询方法
    find() {
      var t = this;
      $http
        .post(
          "http://localhost:5149/api/SupplyView/FenYe?currentPage=" +
            t.currentPage +
            "&pageSize=" +
            t.pagesize +
            "&str=" +
            tj +
            ""
        )
        .then((res) => {
          t.tableData = res.list;
          t.rows = res.rows;
          t.fzr();
          t.hy();
          console.log(res);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    fzr() {
      $http
        .post("http://localhost:5149/api/SupplyView/Czr")
        .then((res) => {
          this.List = res;
          console.log(res);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    //重置
    reset() {
      this.formInline.gys = "";
      this.formInline.zt = "";
      this.formInline.hy = "";
      this.formInline.ren = "";
      tj = "1=1";
      this.find();
    },
    handleEdit() {
      this.$router.push("supplyInsert");
    },
    update(i) {
      this.$router.push("supplyUpdate?id=" + i);
    },
    hy() {
      $http
        .post("http://localhost:5149/api/SupplyView/HY")
        .then((res) => {
          this.List1 = res;
        })
        .catch((err) => {
          alert(err);
        });
    },
    //搜索
    search() {
      this.currentPage = 1;
      tj = "1=1";
      if (this.formInline.gys != "") {
        tj +=
          " and supply_Name like '%" +
          this.formInline.gys +
          "%' or supply_code like '%" +
          this.formInline.gys +
          "%'";
      }
      if (this.formInline.zt != "") {
        tj += " and inbill_state like '%" + this.formInline.zt + "%'";
      }
      if (this.formInline.hy != "") {
        tj += " and line_type like '%" + this.formInline.hy + "%'";
      }
      if (this.formInline.ren != "") {
        tj += " and stock_duty_man like '%" + this.formInline.ren + "%'";
      }
      this.find();
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    //删除
    handleDelete(i) {
      this.$confirm("此操作将永久删除该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          $http
            .post(
              "http://localhost:5149/api/SupplyView/SupplyDelete?id=" +
                i.supply_id +
                "&bl=" +
                this.bl
            )
            .then((res) => {
              if (res) {
                this.$message({
                  message: "删除成功！",
                  type: "success",
                });
                this.find();
              }
            })
            .catch((err) => {
              console.log(err);
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
      this.find();
      console.log(`每页 ${size} 条`);
    },
    //页码改变事件
    handleCurrentChange(page) {
      this.currentPage = page;
      this.find();
      console.log(`当前页: ${page}`);
    },
    //刷新table
    flushed() {
      this.tableloading = true;
      // 模拟获取接口数据
      setTimeout(() => {
        //调用find();this.find();
        this.tableloading = false;
        this.find();
      }, 1000);
      //直接this.查询方法();
    },
    //批量删除
    delAll() {
      this.$confirm("此操作将永久删除该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          const length = this.multipleSelection.length;
          var ss = [];
          for (let i = 0; i < this.multipleSelection.length; i++) {
            ss.push(this.multipleSelection[i].supply_id);
          }
          console.log("lo" + length);
          $http
            .put("http://localhost:5149/api/SupplyView/PLDeleteSupply", ss)
            .then((res) => {
              if (res) {
                this.$message({
                  message: "删除成功！",
                  type: "success",
                });
                this.find();
              }
            })
            .catch((err) => {
              console.log(err);
            });
        })
        .catch(() => {
          this.$message({
            type: "error",
            message: "已取消删除",
          });
        });
    },
    filterTime(timestamp) {
      return formatDate(timestamp);
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
  },
};

export function formatDate(date) {
  let time = new Date(date);

  let year = time.getFullYear();

  let month = time.getMonth() + 1;
  month = month.toString().padStart(2, "0");
  let day = time.getDate().toString().padStart(2, "0");
  return year + "年" + month + "月" + day + "日";
}
</script>
<style scoped src="../CSS/public.css"></style>
<style src="../CSS/tableys.css"></style>
<style scoped>
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