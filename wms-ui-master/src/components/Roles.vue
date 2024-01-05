<template>
  <div id="kj">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">用户管理</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>角色管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!--搜索-->

    <transition-group name="lyric">
      <div id="form" v-if="showDefaultAttr" key="1">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="角色名称" id="form_top">
            <el-input
              v-model="formInline.user"
              id="tex"
              placeholder="角色名称"
            ></el-input>
          </el-form-item>
          <el-form-item label="状态" id="form_top">
            <el-select v-model="formInline.region" id="tex" placeholder="状态">
              <el-option label="启用" value="0"></el-option>
              <el-option label="停用" value="1"></el-option>
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
      id="tableMain1"
    >
      <el-table-column type="selection" width="55"> </el-table-column>
      <el-table-column fixed prop="rolesID" label="序号" width="150">
      </el-table-column>
      <el-table-column fixed prop="rolesName" label="角色名称" width="200">
      </el-table-column>
      <el-table-column fixed prop="rolesAuthority" label="备注" width="223">
      </el-table-column>
      <el-table-column label="状态" width="200">
        <template slot-scope="scope">
          <el-switch
            v-model="scope.row.rolesState"
            active-color="#13ce66"
            active-value="0"
            inactive-value="1"
            inactive-color="#ff4949"
            @change="changeSwitch(scope.row)"
          >
          </el-switch>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200">
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
            @click="handleDelete(scope.row.rolesID)"
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
    <!--权限的模态框-->
    <el-drawer
      id="bj"
      title="编辑"
      :visible.sync="dialogVisible"
      :direction="direction"
      :before-close="handleClose"
    >
      <div class="demo-drawer__content">
        <el-tree
          ref="tree"
          show-checkbox
          :data="treeData"
          :props="treeProps"
          node-key="id"
          :default-expand-all="true"
          :default-checked-keys="defualtkeys"
        ></el-tree>
        <div class="demo-drawer__footer" id="didi">
          <el-button id="tj" @click="closeDrawer()">提交</el-button>
          <el-button @click="cancelForm" id="qx">取 消</el-button>
        </div>
      </div>
    </el-drawer>
    <!--角色添加模态框-->
    <el-dialog title="编辑菜单" :visible.sync="adialogVisible" width="700px">
      <span>
        <el-form :model="AddRoles" :rules="rules" ref="ruleForm">
          <el-form-item label="角色名称" prop="rolesName">
            <el-input v-model="AddRoles.rolesName"></el-input>
          </el-form-item>
          <el-form-item label="角色说明" prop="rolesAuthority">
            <el-input v-model="AddRoles.rolesAuthority"></el-input>
          </el-form-item>
          <el-form-item label="状态" prop="rolesState">
            <el-radio-group
              v-model="AddRoles.rolesState"
              style="margin-bottom: 0"
            >
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
  </div>
</template>

<script>
import $http from "../http/base.js";
import axios from "axios";
var rid = 0;
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
      },
      tableData: [], //表格数据
      treeData: [], //树控件的数据
      defualtkeys: [], //默认选中的节点集合
      treeProps: {
        label: "text",
        children: "children",
      },
      AddRoles: {
        rolesName: "",
        rolesState: "0",
        rolesAuthority: "",
      },
      rules: {
        rolesName: [
          { required: true, message: "请输入角色名称", trigger: "blur" },
        ],
        rolesAuthority: [
          { required: true, message: "请输入角色说明", trigger: "blur" },
        ],
      },
      direction: "rtl",
      dialogVisible: false,
      adialogVisible: false,
      currentPage: 1, //当前页
      pagesize: 10, //每页显示数
      rows: 0, //总行数
    };
  },
  methods: {
    //查询方法
    find() {
      $http
        .get("http://localhost:5149/api/Roless/RolesFind", {
          params: {
            page: this.currentPage,
            pageSize: this.pagesize,
            gw: this.formInline.user,
            zt: this.formInline.region,
          },
        })
        .then((res) => {
          this.list = res.data;
          this.tableData = res.data;
          this.rows = res.totalCount;
          console.log(res);
        });
      // $http.get('http://localhost:5149/api/Users/FindUser', {
      //     params: {
      //         CurrentPage: this.currentPage,
      //         PageSize: this.pagesize,
      //         str
      //     }
      // }).then(res => {
      //     this.tableData = res.list;
      //     this.rows = res.rows;

      //     console.log(res);
      // })
    },
    //修改用户状态
    changeSwitch(row) {
      console.log(row);
      $http
        .put(
          "http://localhost:5149/api/Roless/UpdateRolessState?roleId=" +
            row.rolesID +
            "&roleState=" +
            row.rolesState +
            ""
        )
        .then((res) => {
          if (row.rolesState == "0") {
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
          //     console.log(err);
        });
    },
    handleClose(done) {
      this.$confirm("确认关闭？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then((_) => {
          done();
        })
        .catch((_) => {});
    },
    cancelForm() {
      this.dialogVisible = false;
    },
    //重置
    reset() {
      this.formInline = {
        region: "",
        user: "",
      };
    },
    //新增
    insert() {
      this.adialogVisible = true;
      this.AddRoles = {
        rolesName: "",
        rolesAuthority: "",
        rolesState: "0",
      };
    },
    insertok() {
      this.$refs.ruleForm.validate((valid) => {
        if (valid) {
          $http
            .post("http://localhost:5149/api/Roless/AddRoles", {
              rolesName: this.AddRoles.rolesName,
              rolesState: this.AddRoles.rolesState,
              rolesAuthority: this.AddRoles.rolesAuthority,
            })
            .then((res) => {
              if (res) {
                this.$message({
                  type: "success",
                  message: "新增用户成功!",
                });
                this.find();
                this.adialogVisible = false;
              }
            });
        }
      });
    },
    //搜索
    search() {
      this.currentPage = 1;
      this.find();
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    //修改
    handleEdit(obj) {
      rid = obj.rolesID;
      console.log(obj);
      this.dialogVisible = true;
      this.doLoadTreeNodes();
    },
    //删除
    handleDelete(id) {
      this.$confirm("此操作将永久删除该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          $http
            .delete(
              "http://localhost:5149/api/Roless/RemoveRoles?roleId=" + id + ""
            )
            .then((res) => {
              if (res) {
                this.$message({
                  type: "success",
                  message: "删除成功!",
                });
              }
              this.find();
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
    //树状查询
    doLoadTreeNodes: function () {
      var t = this;
      axios.all([this.getTree(), this.getQuan()]).then(
        axios.spread(function (acct, perms) {
          t.treeData = acct.data;
          t.defualtkeys = perms.data;
          console.log(t.treeData);
        })
      );
    },
    getTree: function () {
      return axios.get("http://localhost:5149/api/Roless/GetTrees");
    },
    getQuan: function () {
      return axios.get(
        "http://localhost:5149/api/Roless/GetQuan?RoelsId=" + rid + ""
      );
    },
    closeDrawer() {
      //1 获取选中节点的值，发送ajax做修改操作
      var zhi = [
        ...this.$refs.tree.getCheckedKeys(),
        ...this.$refs.tree.getHalfCheckedKeys(),
      ];
      console.log(zhi);

      $http
        .get("http://localhost:5149/api/Roless/GetRolesById", {
          params: {
            RolesID: rid,
          },
        })
        .then((res) => {
          if (Array.isArray(res) && res.length === 0) {
            console.log(2);
            for (let i = 0; i < zhi.length; i++) {
              var val = zhi[i];
              $http
                .put(
                  "http://localhost:5149/api/Roless/UpdateRoles?roleId=" +
                    rid +
                    "&pid=" +
                    val +
                    ""
                )
                .then((res) => {});
            }
            this.$message({
              type: "success",
              message: "权限修改成功",
            });
          } else {
            console.log(1);
            //删除原有数据
            $http
              .delete(
                "http://localhost:5149/api/Roless/DeleteRoles?roleId=" +
                  rid +
                  ""
              )
              .then((res) => {
                if (res) {
                  if (zhi.length != 0) {
                    console.log(1);
                    for (let i = 0; i < zhi.length; i++) {
                      var val = zhi[i];
                      $http
                        .put(
                          "http://localhost:5149/api/Roless/UpdateRoles?roleId=" +
                            rid +
                            "&pid=" +
                            val +
                            ""
                        )
                        .then((res) => {});
                    }
                    this.$message({
                      type: "success",
                      message: "权限修改成功",
                    });
                  }
                }
              });
          }
        })
        .catch((err) => {
          console.log(err);
          console.log(12);
        });
      //var qids = zhi.join(',');

      this.dialogVisible = false;
    },
  },
  mounted() {
    this.find();
  },
};
</script>
<style scoped src="../CSS/public.css"></style>
<style src="../CSS/tableys.css"></style>

<style scoped>
#didi {
  position: absolute;
  bottom: 0px;
  box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
  background-color: #fff;
  width: 430px;
  height: 60px;
  text-align: center;
  line-height: 60px;
  z-index: 99999;
}
.el-tree {
  height: 850px; /* 设置容器的高度 */
  overflow: auto; /* 显示滚动条 */
}
#w {
  margin-left: 20px;
}
#tableMain1 {
  margin-top: 65px;
  margin-left: 60px;
  width: 1030px;
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