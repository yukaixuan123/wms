<template>
  <div id="kj">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">系统设置</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>数字字典</el-breadcrumb-item>
    </el-breadcrumb>
    <!--搜索-->

    <transition-group name="lyric">
      <div id="form" v-if="showDefaultAttr" key="1">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="字典名称" id="form_top">
            <el-input
              v-model="formInline.region"
              id="tex"
              placeholder="字典名称"
            ></el-input>
          </el-form-item>
          <el-form-item label="字典类型" id="form_top">
            <el-input
              v-model="formInline.user"
              id="tex"
              placeholder="字典类型"
            ></el-input>
          </el-form-item>
          <el-form-item label="状态" id="form_top">
            <el-select v-model="formInline.zt" id="tex" placeholder="活动区域">
              <el-option label="正常" value="0">正常</el-option>
              <el-option label="停用" value="1">停用</el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="查询日期">
            <el-date-picker
              v-model="formInline.data1"
              type="datetimerange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
            >
            </el-date-picker>
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
      <el-table-column fixed prop="dict_id" label="字典编号" width="130">
      </el-table-column>
      <el-table-column fixed prop="dict_name" label="字典名称" width="130">
      </el-table-column>
      <el-table-column fixed label="字典类型" width="150">
        <template slot-scope="scope">
          <a href="javascript:void(0)" @click="type(scope.row)">{{
            scope.row.dict_label
          }}</a>
        </template>
      </el-table-column>
      <el-table-column fixed label="状态" width="120">
        <template slot-scope="scope">
          <div v-if="scope.row.status == 0">
            <el-tag>正常</el-tag>
          </div>
          <div v-if="scope.row.status == 1">
            <el-tag type="danger">异常 </el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column fixed prop="remark" label="备注" width="135">
      </el-table-column>
      <el-table-column fixed label="创建时间" width="135">
        <template slot-scope="scope">
          <span>{{ filterTime(scope.row.create_time) }}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="状态" width="130">
                <template slot-scope="scope">
                    <el-switch v-model="scope.row.u_State" active-color="#13ce66" active-value="0" inactive-value="1"
                        inactive-color="#ff4949" @change="changeSwitch(scope.row)">
                    </el-switch>
                </template>
            </el-table-column> -->
      <el-table-column label="操作" fixed="right" width="100">
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
            @click="handleDelete(scope.row.dict_id)"
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
    <el-dialog title="新增字典" :visible.sync="adialogVisible" width="700px">
      <span>
        <el-form :model="AddType" :rules="rules" ref="ruleForm">
          <el-form-item label="字典名称" prop="dict_name">
            <el-input v-model="AddType.dict_name"></el-input>
          </el-form-item>
          <el-form-item label="字典类型" prop="dict_label">
            <el-input v-model="AddType.dict_label"></el-input>
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="AddType.status" style="margin-bottom: 0">
              <el-radio label="0">正常</el-radio>
              <el-radio label="1">停用</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="备注" prop="remark">
            <el-input
              type="textarea"
              :rows="2"
              placeholder="请输入内容"
              v-model="AddType.remark"
            >
            </el-input>
          </el-form-item>
        </el-form>
      </span>
      <div slot="footer" class="dialog-footer">
        <el-button @click="adialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="insertok()">确 定</el-button>
      </div>
    </el-dialog>
    <!--修改模态框-->
    <el-dialog title="新增字典" :visible.sync="dialogVisible" width="700px">
      <span>
        <el-form :model="UpdateType" :rules="arules" ref="ruleForm">
          <el-form-item label="字典名称" prop="dict_name">
            <el-input v-model="UpdateType.dict_name"></el-input>
          </el-form-item>
          <el-form-item label="字典类型" prop="dict_label">
            <el-input v-model="UpdateType.dict_label"></el-input>
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-radio-group
              v-model="UpdateType.status"
              style="margin-bottom: 0"
            >
              <el-radio label="0">正常</el-radio>
              <el-radio label="1">停用</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="备注" prop="remark">
            <el-input
              type="textarea"
              :rows="2"
              placeholder="请输入内容"
              v-model="UpdateType.remark"
            >
            </el-input>
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

//日期格式转换
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
      tableloading: false, //加载
      showDefaultAttr: true,
      multipleSelection: [], // 选中的行数据
      tableData: [],
      textarea: "",
      formInline: {
        user: "",
        region: "",
        data1: "",
        zt: "",
      },
      rules: {
        dict_name: [
          { required: true, message: "请输入字典名称", trigger: "blur" },
        ],
        dict_label: [
          { required: true, message: "请输入字典类型", trigger: "blur" },
        ],
      },
      arules: {
        dict_name: [
          { required: true, message: "请输入字典名称", trigger: "blur" },
        ],
        dict_label: [
          { required: true, message: "请输入字典类型", trigger: "blur" },
        ],
      },
      UpdateType: {
        dict_name: "",
        dict_label: "",
        status: "",
        remark: "",
        dict_id: 0,
      },
      AddType: {
        dict_name: "",
        dict_label: "",
        status: "0",
        remark: "",
      },
      adialogVisible: false,
      dialogVisible: false,
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
        .get("http://localhost:5149/api/Sys_encode/Find_dictType", {
          params: {
            CurrentPage: this.currentPage,
            PageSize: this.pagesize,
            str,
          },
        })
        .then((res) => {
          this.tableData = res.list;
          this.rows = res.rows;
          localStorage.setItem("idd", res.list.dict_id);
          console.log(res);
        });
    },
    add() {
      this.adialogVisible = true;
    },
    insertok() {
      var uname = localStorage.getItem("b");
      this.$refs.ruleForm.validate((valid) => {
        if (valid) {
          $http
            .post(
              "http://localhost:5149/api/Sys_encode/AddSys_dict_type?dict_name=" +
                this.AddType.dict_name +
                "&dict_label=" +
                this.AddType.dict_label +
                "&status=" +
                this.AddType.status +
                "&remark=" +
                this.AddType.remark +
                "&create_by=" +
                uname +
                "&is_del=" +
                0 +
                ""
            )
            .then((res) => {
              if (res) {
                this.$message({
                  type: "success",
                  message: "新增字典成功!",
                });
                this.find();
                this.adialogVisible = false;
              }
            });
        }
      });
    },
    type(obj) {
      console.log(obj);
    },
    //重置
    reset() {
      this.formInline = {
        region: "",
        data1: "",
        user: "",
        zt: "",
      };
      console.log("reset!");
    },
    //搜索
    search() {
      this.currentPage = 1;
      str = " 1=1 ";
      if (this.formInline.region != null) {
        str += "and dict_name  like'%" + this.formInline.region + "%'";
      }
      if (this.formInline.user != null) {
        str += "and dict_label  like'%" + this.formInline.user + "%'";
      }
      if (this.formInline.zt != null) {
        str += "and status  like'%" + this.formInline.zt + "%'";
      }
      // if (this.formInline.data1 != null) {
      //     str += " and  create_time BETWEEN '2023-12-05' AND '2023-12-06'";
      // str += " and create_time between'" + start + " 'and'" + end + "'";
      //      str += "and create_time  '%" + this.formInline.data1 + "%'";
      // }
      // alert(str);
      this.find();
    },
    type(obj) {
      localStorage.setItem("iidd", obj.dict_id);
      console.log(obj);
      this.$router.push({
        path: `/DictionaryData/${obj.dict_id}/${obj.dict_label}`,
      });
      // this.$router.push({ path: '/DictionaryData', query: { index: obj.dict_id } });
      // this.$router.push('DictionaryData');
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    //修改
    handleEdit(obj) {
      this.dialogVisible = true;
      this.UpdateType.dict_name = obj.dict_name;
      this.UpdateType.dict_label = obj.dict_label;
      this.UpdateType.status = obj.status;
      this.UpdateType.remark = obj.remark;
      this.UpdateType.dict_id = obj.dict_id;

      console.log(obj);
    },
    updateok() {
      var uname = localStorage.getItem("b");
      this.$refs.ruleForm.validate((valid) => {
        if (valid) {
          $http
            .put(
              "http://localhost:5149/api/Sys_encode/UpdateSys_dict_type?dict_name=" +
                this.UpdateType.dict_name +
                "&dict_label=" +
                this.UpdateType.dict_label +
                "&status=" +
                this.UpdateType.status +
                "&remark=" +
                this.UpdateType.remark +
                "&update_by=" +
                uname +
                "&dict_id=" +
                this.UpdateType.dict_id +
                ""
            )
            .then((res) => {
              if (res) {
                this.$message({
                  type: "success",
                  message: "修改字典成功!",
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
          $http
            .get(
              "http://localhost:5149/api/Sys_encode/FindSys_dict_type?dict_id=" +
                id
            )
            .then((res) => {
              if (res && res.length > 0) {
                this.$message({
                  type: "error",
                  message: "无法删除，主表在子表中有引用!",
                });
              } else {
                $http
                  .put(
                    "http://localhost:5149/api/Sys_encode/Delete_dict_type?is_del=" +
                      1 +
                      "&dict_id=" +
                      id +
                      ""
                  )
                  .then((res) => {
                    if (res) {
                      this.$message({
                        type: "success",
                        message: "删除成功!",
                      });
                      this.find();
                    }
                  });
              }
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
    filterTime(timestamp) {
      return formatDate(timestamp);
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