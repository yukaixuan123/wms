<template>
  <div id="kj">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">用户管理</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>用户</el-breadcrumb-item>
    </el-breadcrumb>
    <!--搜索-->

    <transition-group name="lyric">
      <div id="form" v-if="showDefaultAttr" key="1">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="用户账号" id="form_top">
            <el-input
              v-model="formInline.region"
              id="tex"
              placeholder="用户账号"
            ></el-input>
          </el-form-item>
          <el-form-item label="用户姓名" id="form_top">
            <el-input
              v-model="formInline.user"
              id="tex"
              placeholder="用户姓名"
            ></el-input>
          </el-form-item>
          <el-form-item label="状态" id="form_top">
            <el-select v-model="formInline.zt" id="tex" placeholder="活动区域">
              <el-option label="启用" value="0">启用</el-option>
              <el-option label="停用" value="1">停用</el-option>
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
      <el-button id="tex3" icon="el-icon-plus" @click="add()">新增</el-button>
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
      <el-table-column fixed prop="u_id" label="序号" width="160">
      </el-table-column>
      <el-table-column
        fixed
        prop="userRolesID"
        label="编号"
        v-if="false"
        width="145"
      >
      </el-table-column>
      <el-table-column fixed prop="u_name" label="用户账户" width="160">
      </el-table-column>
      <el-table-column fixed prop="u_True_name" label="用户姓名" width="160">
      </el-table-column>

      <el-table-column label="状态" width="160">
        <template slot-scope="scope">
          <el-switch
            v-model="scope.row.u_State"
            active-color="#13ce66"
            active-value="0"
            inactive-value="1"
            inactive-color="#ff4949"
            @change="changeSwitch(scope.row)"
          >
          </el-switch>
        </template>
      </el-table-column>
      <el-table-column prop="rolesName" label="角色" width="170">
      </el-table-column>

      <el-table-column label="操作" width="164">
        <template slot-scope="scope">
          <img
            src="../Images/bianji1.png"
            title="编辑"
            @click="handleEdit(scope.row)"
          />
          <img
            src="../Images/shanchu.png"
            style="margin-left: 10px"
            title="删除"
            @click="handleDelete(scope.row.u_id)"
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
    <!--添加模态框-->
    <el-dialog title="添加数据" :visible.sync="adialogVisible" width="750px">
      <span>
        <el-form :model="AddUsers" :rules="rules" ref="ruleForm">
          <el-form-item label="用户账号" prop="u_name">
            <el-input v-model="AddUsers.u_name"></el-input>
          </el-form-item>
          <el-form-item label="用户姓名" prop="u_True_name">
            <el-input v-model="AddUsers.u_True_name"></el-input>
          </el-form-item>
          <el-form-item label="用户密码" prop="u_password">
            <el-input v-model="AddUsers.u_password" show-password></el-input>
          </el-form-item>
          <el-form-item label="角色">
            <el-select
              v-model="AddUsers.value1"
              style="width: 400px"
              placeholder="请选择"
            >
              <el-option
                v-for="item in options"
                :key="item.rolesID"
                :label="item.rolesName"
                :value="item.rolesID"
              >
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="状态" prop="u_State">
            <el-radio-group v-model="AddUsers.u_State" style="margin-bottom: 0">
              <el-radio label="0">正常</el-radio>
              <el-radio label="1">停用</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>
      </span>
      <div slot="footer" class="dialog-footer">
        <el-button @click="adialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="insertok()">确 定</el-button>
      </div>
    </el-dialog>

    <!--修改模态框-->
    <el-dialog title="编辑信息" :visible.sync="dialogVisible" width="750px">
      <span>
        <el-form :model="UpdateUsers" :rules="srules" ref="ruleForm">
          <el-form-item label="用户账号" prop="u_name">
            <el-input v-model="UpdateUsers.u_name"></el-input>
          </el-form-item>
          <el-form-item label="用户姓名" prop="u_True_name">
            <el-input v-model="UpdateUsers.u_True_name"></el-input>
          </el-form-item>
          <el-form-item label="用户密码" prop="u_password">
            <el-input v-model="UpdateUsers.u_password" show-password></el-input>
          </el-form-item>
          <el-form-item label="角色">
            <el-select
              v-model="UpdateUsers.value1"
              style="width: 400px"
              placeholder="请选择"
            >
              <el-option
                v-for="item in options"
                :key="item.rolesID"
                :label="item.rolesName"
                :value="item.rolesID"
              >
              </el-option>
            </el-select>
          </el-form-item>
        </el-form>
      </span>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateok()">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import $http from "../http/base.js";
var str = " is_del=0 and 1=1";
export default {
  data() {
    return {
      tableloading: false, //加载
      showDefaultAttr: true,
      multipleSelection: [], // 选中的行数据
      tableData: [],
      formInline: {
        user: "",
        region: "",
        zt: "",
      },
      AddUsers: {
        u_password: "",
        u_name: "",
        u_True_name: "",
        u_State: "0",
        value1: "",
        u_id: "",
      },
      UpdateUsers: {
        u_password: "",
        u_name: "",
        u_True_name: "",
        u_State: "",
        value1: "",
        u_id: 0,
        userRolesID: 0,
      },
      dialogVisible: false,
      options: [],
      srules: {
        u_name: [
          { required: true, message: "请输入账号名称", trigger: "blur" },
        ],
        u_True_name: [
          { required: true, message: "请输入真实名称", trigger: "blur" },
        ],
        u_password: [
          { required: true, message: "请输入用户密码", trigger: "blur" },
        ],
      },
      rules: {
        u_name: [
          { required: true, message: "请输入账号名称", trigger: "blur" },
        ],
        u_True_name: [
          { required: true, message: "请输入真实名称", trigger: "blur" },
        ],
        u_password: [
          { required: true, message: "请输入用户密码", trigger: "blur" },
        ],
      },
      adialogVisible: false,
      value: true,
      currentPage: 1, //当前页
      pagesize: 10, //每页显示数
      rows: 0, //总行数
    };
  },
  methods: {
    //查询方法
    find() {
      $http
        .get("http://localhost:5149/api/Users/FindUser", {
          params: {
            CurrentPage: this.currentPage,
            PageSize: this.pagesize,
            str,
          },
        })
        .then((res) => {
          this.tableData = res.list;
          this.rows = res.rows;

          console.log(res);
        });

      //下拉框查询
      $http.get("http://localhost:5149/api/Roless/FindRoles").then((res) => {
        console.log(res);
        this.options = res;
      });
    },
    //修改用户状态
    changeSwitch(row) {
      console.log(row);
      $http
        .put(
          "http://localhost:5149/api/Users/UpdateUsersState?u_id=" +
            row.u_id +
            "&u_State=" +
            row.u_State +
            ""
        )
        .then((res) => {
          if (row.u_State == "0") {
            this.$message({
              type: "success",
              message: "状态启用成功",
            });
          } else {
            this.$message({
              type: "error",
              message: "状态停用",
            });
          }
        })
        .catch((err) => {
          console.log(err);
        });
    },
    add() {
      this.adialogVisible = true;
    },
    //xz
    insertok() {
      var a = this.AddUsers.value1;
      this.$refs.ruleForm.validate((valid) => {
        if (valid) {
          $http
            .post(
              "http://localhost:5149/api/Users/AddUsers?u_name=" +
                this.AddUsers.u_name +
                "&U_True_name=" +
                this.AddUsers.u_True_name +
                "&U_password=" +
                this.AddUsers.u_password +
                "&U_State=" +
                this.AddUsers.u_State +
                "&is_del=" +
                0 +
                "&rolesId=" +
                a +
                ""
            )
            .then((res) => {
              if (res) {
                this.$message({
                  type: "success",
                  message: "添加成功!",
                });
                this.find();
                this.adialogVisible = false;
              }
            });
        }
      });
    },
    //重置
    reset() {
      this.formInline = {
        region: "",
        user: "",
        zt: "",
      };
    },
    //搜索
    search() {
      this.currentPage = 1;
      str = " is_del=0 and 1=1";
      if (this.formInline.region != null) {
        str += "and u_name  like'%" + this.formInline.region + "%'";
      }
      if (this.formInline.user != null) {
        str += "and u_True_name like'%" + this.formInline.user + "%'";
      }
      if (this.formInline.zt != null) {
        str += "and u_State like'%" + this.formInline.zt + "%'";
      }
      this.find();
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    //修改
    handleEdit(obj) {
      this.dialogVisible = true;
      this.UpdateUsers.userRolesID = obj.userRolesID;
      this.UpdateUsers.u_id = obj.u_id;
      this.UpdateUsers.u_True_name = obj.u_True_name;
      this.UpdateUsers.u_State = obj.u_State;
      this.UpdateUsers.u_name = obj.u_name;
      this.UpdateUsers.u_password = obj.u_password;
      this.UpdateUsers.value1 = obj.rolesID;
    },
    updateok() {
      var a = this.UpdateUsers.value1;

      this.$refs.ruleForm.validate((valid) => {
        if (valid) {
          $http
            .put(
              "http://localhost:5149/api/Users/UpdateUsers?u_name=" +
                this.UpdateUsers.u_name +
                "&U_True_name=" +
                this.UpdateUsers.u_True_name +
                "&U_password=" +
                this.UpdateUsers.u_password +
                "&rolesId=" +
                this.UpdateUsers.value1 +
                "&u_id=" +
                this.UpdateUsers.u_id +
                "&UserRolesID=" +
                this.UpdateUsers.userRolesID +
                ""
            )
            .then((res) => {
              if (res) {
                this.$message({
                  type: "success",
                  message: "修改成功!",
                });
                this.find();
                this.dialogVisible = false;
              }
            });
        }
      });
    },
    //删除
    handleDelete(id) {
      this.$confirm("此操作将永久删除该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          if (id == 1) {
            this.$message({
              type: "info",
              message: "管理员禁止删除!",
            });
          } else {
            $http
              .put(
                "http://localhost:5149/api/Users/DeleteUsers?u_id=" +
                  id +
                  "&is_del=1"
              )
              .then((res) => {
                if (res) {
                  this.$message({
                    type: "success",
                    message: "删除成功!",
                  });
                }
              });
          }
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
    },
    //页码改变事件
    handleCurrentChange(page) {
      this.currentPage = page;
      this.find();
    },
    //刷新table
    flushed() {
      this.tableloading = true;
      // 模拟获取接口数据
      setTimeout(() => {
        //调用find();
        this.find();
        this.tableloading = false;
      }, 1000);
      //直接this.查询方法();
    },
    //批量删除
    delAll() {
      alert("123");
      //   const length = this.multipleSelection.length;
      //   for (let i = 0; i < length; i++) {
      //     this.delarr.push(this.multipleSelection[i].PackingId)
      //   }
    },
  },
  mounted() {
    this.find();
  },
};
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