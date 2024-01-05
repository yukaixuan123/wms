<template>
  <div id="kjcd">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">用户管理</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>菜单管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!--搜索-->
    <transition-group name="lyric">
      <div id="form" v-if="showDefaultAttr" key="1">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="岗位" id="form_top">
            <el-input
              v-model="formInline.user"
              id="tex"
              placeholder="岗位"
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
      <!-- <el-button id="tex3" icon="el-icon-plus">新增</el-button>
      <el-button
        id="tex5"
        @click="delAll()"
        icon="el-icon-delete"
        :disabled="multipleSelection.length == 0"
        >删除</el-button
      > -->
      <el-button id="tex7" icon="el-icon-upload2">导入</el-button>
      <el-button id="tex6" icon="el-icon-download">导出</el-button>
    </div>
    <!--隐藏-->
    <div id="an1">
      <!-- <el-button
        icon="el-icon-search"
        circle
        @click="showDefaultAttr = !showDefaultAttr"
        title="展开"
      ></el-button> -->
      <el-button
        icon="el-icon-refresh"
        circle
        @click="flushed"
        title="刷新"
      ></el-button>
    </div>
    <el-table
      :data="cateList"
      row-key="id"
      border
      id="tableMain"
      height="470px"
      v-loading="tableloading"
      element-loading-text="拼命加载中"
      element-loading-spinner="el-icon-loading"
      lazy
      :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
    >
      <el-table-column prop="text" fixed label="菜单名称" width="200">
      </el-table-column>
      <el-table-column type="index" label="排序" width="200"> </el-table-column>
      <el-table-column prop="url" label="组件地址" width="200">
      </el-table-column>
      <el-table-column prop="id" label="权限标识" width="180">
      </el-table-column>
      <!-- <el-table-column
                      prop="pid"
                      label="父编号"
                      width="180">
                    </el-table-column> -->
      <el-table-column label="操作" fixed="right" width="220">
        <template slot-scope="scope">
          <div class="cell">
            <button
              type="button"
              class="el-button el-button--text el-button--mini"
              @click="update(scope.row)"
            >
              <!----><i class="el-icon-edit"></i><span>修改</span>
            </button>
            <button
              type="button"
              class="el-button el-button--text el-button--mini"
              @click="add()"
            >
              <!----><i class="el-icon-plus"></i><span>新增</span></button
            ><button
              type="button"
              class="el-button el-button--text el-button--mini"
              @click="delte(scope.row.id)"
            >
              <!---->
              <i class="el-icon-delete"></i><span>删除</span>
            </button>
          </div>
        </template>
      </el-table-column>
    </el-table>
    <!--添加菜单-->
    <el-dialog title="添加菜单" :visible.sync="dialogVisible" width="700px">
      <span>
        <el-form :model="AddAuthority" :rules="rules" ref="ruleForm">
          <el-form-item label="上级菜单">
            <el-cascader
              :options="options"
              v-model="value"
              :props="{ checkStrictly: true }"
              @change="handleChange"
              clearable
            ></el-cascader>
          </el-form-item>
          <el-form-item label="组件地址" prop="authorityAddress">
            <el-input v-model="AddAuthority.authorityAddress"></el-input>
          </el-form-item>
          <el-form-item label="菜单名称">
            <el-input v-model="AddAuthority.AuthorityName"></el-input>
          </el-form-item>
        </el-form>
      </span>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="commit()">确 定</el-button>
      </div>
    </el-dialog>
    <!--编辑菜单-->
    <el-dialog title="编辑菜单" :visible.sync="adialogVisible" width="700px">
      <span>
        <el-form :model="UpdateAuthority" :rules="urules" ref="ruleForm1">
          <el-form-item label="上级菜单 ">
            <el-cascader
              :options="options"
              v-model="value"
              :props="{ checkStrictly: true }"
              @change="handleChange"
              clearable
            ></el-cascader>
          </el-form-item>
          <el-form-item label="组件地址" prop="authorityAddress">
            <el-input v-model="UpdateAuthority.authorityAddress"></el-input>
            <el-input v-if="false" v-model="UpdateAuthority.id"></el-input>
          </el-form-item>
          <el-form-item label="菜单名称" prop="userLPWD">
            <el-input v-model="UpdateAuthority.AuthorityName"></el-input>
          </el-form-item>
        </el-form>
      </span>
      <div slot="footer" class="dialog-footer">
        <el-button @click="adialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateok()">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import $http from "../http/base.js";
import axios from "axios";
var str = "1=1";

export default {
  data() {
    return {
      formInline: {
        user: "",
        region: "",
      },
      value: [],
      tableloading: false, //加载

      NewMenu: "",
      AddAuthority: {
        AuthorityName: "",
        authorityAddress: "",
      },
      UpdateAuthority: {
        AuthorityName: "",
        authorityAddress: "",
        id: "",
      },
      urules: {
        authorityAddress: [
          { required: true, message: "菜单名称不能为空!", trigger: "blur" },
        ],
      },
      rules: {
        //  authorityAddress: [
        //    { required: true, message: '组件地址不能为空!', trigger: 'blur' },
        // ],
        authorityAddress: [
          { required: true, message: "菜单名称不能为空!", trigger: "blur" },
        ],
      },
      options1: [],
      //级联
      options: [],
      dialogVisible: false,
      adialogVisible: false,
      showDefaultAttr: false,
      multipleSelection: [], // 选中的行数据
      list: [],
      cateList: [],
      columns: [],
      currentPage: 1, //当前页
      pageSize: 3, //分页显示数
      rows: 0, //总行数
    };
  },
  methods: {
    fenye() {
      $http.get("http://localhost:5149/api/Roless/GetTrees").then((res) => {
        console.log(res);
        this.cateList = res;
      });
      var t = this;
      // $http.get('http://localhost:5149/api/Roless/FindAuthority', {
      //     params: {
      //         pageSize: t.pageSize,
      //         CurrentPage: t.currentPage,
      //         str
      //     }
      // }).then(res => {
      //     var t = this;
      //     console.log(res);
      //     // console.log(res.data);
      //     t.list = res.cateList;
      //     t.rows = res.rows;

      // }).catch((err) => {
      //     console.log(err);
      // });
    },
    select() {
      axios
        .get("http://localhost:5149/api/Roless/GetAuthorities")
        .then((res) => {
          this.options = res.data;
          console.log(res.data);
        });
    },
    flushed() {
      this.tableloading = true;
      // 模拟获取接口数据
      setTimeout(() => {
        //调用find();
        this.select();
        this.tableloading = false;
      }, 1000);
      //直接this.查询方法();
    },
    find() {
      //调用分页
      this.fenye();
      this.currentPage = 1;
    },
    //打开新增模态框
    add() {
      this.dialogVisible = true;
    },
    //提交
    commit() {
      this.$refs["ruleForm"].validate((valid) => {
        if (!valid) return;
        if (this.value == "") {
          this.$notify({
            title: "提示",
            message: "请输入上级菜单",
            type: "warning",
          });
          return false;
        }
        var ppid = 0;
        if (this.value.length > 0) {
          ppid = parseInt(this.value[this.value.length - 1]);
        }
        console.log(ppid);
        $http
          .post("http://localhost:5149/api/Roless/AddAuthority", {
            authorityName: this.AddAuthority.AuthorityName,
            authorityAddress: this.AddAuthority.authorityAddress,
            pid: ppid,
          })
          .then((res) => {
            this.$message({
              type: "success",
              message: "新增成功",
            });
            this.fenye();
            this.dialogVisible = false;
          })
          .catch((err) => {
            console.log(err);
          });
      });
    },
    //修改模态
    update(obj) {
      console.log(obj);
      $http
        .get("http://localhost:5149/api/Roless/GetAuthorities", {})
        .then((res) => {
          this.options = res;
          console.log(res);
        });
      this.adialogVisible = true;
      this.UpdateAuthority.AuthorityName = obj.text;
      this.UpdateAuthority.authorityAddress = obj.url;
      this.value = obj.pid;
      this.UpdateAuthority.id = obj.id;
    },
    updateok() {
      this.$refs["ruleForm1"].validate((valid) => {
        if (!valid) return;
        if (this.value == "") {
          this.$notify({
            title: "提示",
            message: "请输入上级菜单",
            type: "warning",
          });
          return false;
        }
        var h = 0;
        if (this.value.length > 0) {
          h = parseInt(this.value[this.value.length - 1]);
        } else {
          h = this.value;
        }
        $http
          .put("http://localhost:5149/api/Roless/UpdateAuthority", {
            authorityName: this.UpdateAuthority.AuthorityName,
            authorityAddress: this.UpdateAuthority.authorityAddress,
            AuthorityID: this.UpdateAuthority.id,
            pid: h,
          })
          .then((res) => {
            if (res) {
              this.$message({
                type: "success",
                message: "修改成功!",
              });
              this.fenye();
            }
          });
      });
    },
    handleChange(value) {
      console.log(value);
    },
    handleChange1(value) {
      console.log(this.Newvalue);
    },

    //每页显示数
    handleSizeChange(size) {
      this.pageSize = size;
      (this.currentPage = 1), this.fenye();
    },
    //页码改变事件
    handleCurrentChange(page) {
      this.currentPage = page;
      this.fenye();
    },
    delte(id) {
      this.$confirm("此操作将永久删除该文件, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          axios
            .delete(
              "http://localhost:5149/api/Roless/DeleteAuthority?aid=" + id + ""
            )
            .then((res) => {
              if (res) {
                this.$message({
                  type: "success",
                  message: "删除成功!",
                });
                this.fenye();
              }
            });
        })
        .catch(() => {
          this.$message({
            type: "info",
            message: "已取消删除",
          });
        });
    },
  },
  mounted() {
    this.find();
    this.select();
  },
};
</script>


<style>
#kjcd {
  width: 1150px !important;
  height: 630px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
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