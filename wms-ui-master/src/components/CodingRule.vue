<template>
  <div id="kj">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">系统设置</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>编码规则</el-breadcrumb-item>
    </el-breadcrumb>
    <!--搜索-->

    <transition-group name="lyric">
      <div id="form" v-if="showDefaultAttr" key="1">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="目标表单" id="form_top">
            <el-select
              v-model="formInline.region"
              id="tex"
              placeholder="目标表单"
            >
              <el-option
                v-for="item in list1"
                :key="item.en_form"
                :value="item.en_form"
              >
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="编号前缀" id="form_top">
            <el-input
              v-model="formInline.user"
              id="tex"
              placeholder="请输入编号"
            ></el-input>
          </el-form-item>
          <el-form-item label="时间规则" id="form_top">
            <el-input
              v-model="formInline.gz"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="进货日期" prop="startDate">
            <el-date-picker
              v-model="formInline.data1"
              type="datetime"
              placeholder="选择日期时间"
              value-format="yyyy-MM-dd HH:mm:ss"
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
            <el-button
              @click="reset('formInline')"
              id="tex2"
              icon="el-icon-refresh"
              >重置</el-button
            >
            <!-- <el-button type="primary" @click="search">高级搜索</el-button> -->
          </el-form-item>
        </el-form>
      </div>
    </transition-group>

    <!--按钮-->
    <div id="an">
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
      <el-table-column fixed prop="en_code" label="序号" width="100">
      </el-table-column>
      <el-table-column
        fixed
        prop="en_form"
        label="目标表单"
        width="120"
        disabled
      >
      </el-table-column>
      <el-table-column fixed prop="en_prefix" label="编号前缀" width="120">
      </el-table-column>
      <el-table-column prop="en_time" label="时间规则" width="120">
      </el-table-column>
      <el-table-column prop="en_num" label="流水号" width="130">
      </el-table-column>
      <el-table-column prop="en_step" label="步长" width="130">
      </el-table-column>
      <el-table-column prop="en_rules" label="编号生成规则" width="250">
      </el-table-column>
      <el-table-column prop="create_by" label="操作人" width="130">
      </el-table-column>
      <el-table-column fixed label="操作时间" width="150">
        <template slot-scope="scope">
          <span>{{ filterTime(scope.row.create_time) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" fixed="right" width="100">
        <template slot-scope="scope">
          <button
            type="button"
            class="el-button el-button--text el-button--mini"
            @click="handleEdit(scope.row)"
          >
            <!----><i class="el-icon-edit"></i><span>修改</span>
          </button>
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

    <!---分配人模态框-->
    <el-drawer
      title="编辑"
      :visible.sync="dialogVisible"
      :direction="direction"
      :before-close="handleClose"
      id="bmbj"
    >
      <div class="demo-drawer__content">
        <el-form :model="formInline1" label-position="top">
          <el-form-item
            label="目标表单"
            :label-width="formLabelWidth"
            id="bmbd"
          >
            <el-input
              id="bmbd1"
              v-model="formInline1.en_form"
              disabled
              autocomplete="off"
            ></el-input>
          </el-form-item>
          <el-form-item
            label="编号前缀"
            id="bmbd"
            :label-width="formLabelWidth"
          >
            <el-input
              id="bmbd1"
              v-model="formInline1.en_prefix"
              autocomplete="off"
            ></el-input>
          </el-form-item>
          <el-form-item
            label="时间规则"
            id="bmbd"
            :label-width="formLabelWidth"
          >
            <el-checkbox-group
              title="时间规则"
              id="bmbd1"
              v-model="checkList"
              @change="change"
            >
              <el-checkbox label="YYYY">年YYYY</el-checkbox>
              <el-checkbox label="MM">月MM</el-checkbox>
              <el-checkbox label="DD">日DD</el-checkbox>
              <el-checkbox label="HH">时HH</el-checkbox>
              <el-checkbox label="F">分MM</el-checkbox>
              <el-checkbox label="SS">秒SS</el-checkbox>
            </el-checkbox-group>
          </el-form-item>

          <el-form-item label="流水号" id="bmbd" :label-width="formLabelWidth">
            <el-input
              id="bmbd1"
              v-model="formInline1.en_num"
              autocomplete="off"
            ></el-input>
          </el-form-item>
          <el-form-item label="步长" id="bmbd" :label-width="formLabelWidth">
            <el-input
              id="bmbd1"
              v-model="formInline1.en_step"
              autocomplete="off"
            ></el-input>
          </el-form-item>
          <el-form-item
            label="编号生成规则"
            id="bmbd"
            :label-width="formLabelWidth"
          >
            <el-input
              id="bmbd1"
              v-model="formInline1.en_rules"
              autocomplete="off"
            ></el-input>
          </el-form-item>
          <el-form-item
            label="编号预览"
            id="bmbd"
            :label-width="formLabelWidth"
          >
            <el-input v-model="yulan" autocomplete="off" id="bmbd1"></el-input>
          </el-form-item>
        </el-form>

        <div class="demo-drawer__footer" id="didi">
          <el-button id="tj" @click="closeDrawer()">提交</el-button>
          <el-button @click="cancelForm" id="qx">取 消</el-button>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import $http from "../http/base.js";
import { Alert, Switch } from "element-ui";
import axios from "axios";
//日期格式转换
export function formatDate(date) {
  let time = new Date(date);

  let year = time.getFullYear();

  let month = time.getMonth() + 1;
  month = month.toString().padStart(2, "0");
  let day = time.getDate().toString().padStart(2, "0");
  return year + "年" + month + "月" + day + "日";
}

var qz = "";
export default {
  data() {
    return {
      labelPosition: "right",
      formLabelAlign: {
        name: "",
        region: "",
        type: "",
      },
      list: [],
      list1: [],
      checkList: [],
      update: {
        en_form: "",
      },
      labelPosition: "right",
      formLabelWidth: "80px",

      direction: "rtl",
      tableloading: false, //加载
      showDefaultAttr: true,
      multipleSelection: [], // 选中的行数据
      tableData: [],
      formInline: {
        user: "",
        gz: "",
        data1: "",
        region: "",
      },
      yulan: "",
      formInline1: {
        en_step: "",
        en_prefix: "",
        en_rules: "",
        en_time: "",
        en_code: 0,
        en_num: "",
        en_form: "",
      },
      dialogVisible: false,
      qz,
      currentPage: 1, //当前页
      pagesize: 10, //每页显示数
      rows: 0, //总行数
      rules: {
        en_form: [
          { required: true, message: "请填写完整信息", trigger: "blur" },
        ],
      },
    };
  },
  methods: {
    //查询方法
    find() {
      $http
        .get("http://localhost:5149/api/Sys_encode/Sys_encodeFenYe", {
          params: {
            page: this.currentPage,
            pageSize: this.pagesize,
            qz: this.formInline.user,
            from: this.formInline.region,
            gz: this.formInline.gz,
            time: this.formInline.data1,
          },
        })
        .then((res) => {
          this.list = res.data;
          this.tableData = res.data;
          this.rows = res.totalCount;
          console.log(res);
        });
    },

    //提交
    closeDrawer() {
      var h = localStorage.getItem("b");
      console.log(h);
      $http
        .put(
          "http://localhost:5149/api/Sys_encode/Sys_encodeUpdate?en_code=" +
            this.formInline1.en_code +
            "&en_prefix=" +
            this.formInline1.en_prefix +
            "&en_time=" +
            this.formInline1.en_time +
            "&en_num=" +
            this.formInline1.en_num +
            "&en_step=" +
            this.formInline1.en_step +
            "&en_rules=" +
            this.formInline1.en_rules +
            "&create_by=" +
            h +
            ""
        )
        .then((res) => {
          if (res) {
            this.$message({
              type: "success",
              message: "修改成功!",
            });
          }
        })
        .catch((err) => {
          console.log(err);
        });
    },
    //重置
    reset() {
      this.formInline = {
        user: "",
        region: "",
        gz: "",
        date1: "",
      };
      this.find();
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
    //打开模态框
    handleEdit(obj) {
      this.dialogVisible = true;
      this.formInline1.en_form = obj.en_form;
      this.formInline1.en_prefix = obj.en_prefix;
      this.formInline1.en_num = obj.en_num;
      this.formInline1.en_step = obj.en_step;
      this.formInline1.en_rules = obj.en_rules;
      this.formInline1.en_time = obj.en_time;
      this.formInline1.en_code = obj.en_code;
      console.log(obj.en_time);
      var enTime = obj.en_time;
      //多选框显示
      for (var a in enTime) {
        switch (enTime[a]) {
          case "年":
            this.checkList.push("YYYY");
            break;
          case "月":
            this.checkList.push("MM");
            break;
          case "日":
            this.checkList.push("DD");
            break;
          case "时":
            this.checkList.push("HH");
            break;
          case "分":
            this.checkList.push("F");
            break;
          case "秒":
            this.checkList.push("SS");
            break;
        }
        console.log(this.checkList);
      }
    },
    //删除
    handleDelete() {
      this.$confirm("此操作将永久删除该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$message({
            type: "success",
            message: "删除成功!",
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
    change(checkList) {
      // console.log(checkList);
      //  console.log(123);
      //#region  编码生成规则
      var sun = "";
      var sun2 = "";
      for (var s in checkList) {
        console.log(checkList[s]);
        switch (checkList[s]) {
          case "YYYY":
            sun += "年";
            sun2 += "YYYY";
            break;
          case "MM":
            sun += "月";
            sun2 += "MM";
            break;
          case "DD":
            sun += "日";
            sun2 += "DD";
            break;
          case "HH":
            sun += "时";
            sun2 += "HH";
            break;
          case "F":
            sun += "分";
            sun2 += "MM";
            break;
          case "SS":
            sun += "秒";
            sun2 += "SS";
            break;
        }
      }
      console.log(sun + "" + sun2);
      this.formInline1.en_time = sun;
      this.formInline1.en_rules = "";
      this.formInline1.en_rules += this.formInline1.en_prefix;
      //     console.log(this.formInline.en_rules);
      this.formInline1.en_rules += sun2;
      //   console.log(this.formInline.en_rules);
      var su = 0;
      su = this.formInline1.en_num;
      for (var i = 1; i < su; i++) {
        this.formInline1.en_rules += "0";
      }
      this.formInline1.en_rules += "1";
      //  console.log(this.formInline.en_rules);
      //  console.log(this.formInline.en_num);
      //#endregion
      //#region   预览
      var today = new Date(); //获取当前时间
      var year = today.getFullYear(); //获取年份
      var month = today.getMonth() + 1; //获取月份
      var day = today.getDate(); //获取日期
      var hours = today.getHours(); //获取时
      var minutes = today.getMinutes(); //获得分钟
      var Seconds = today.getSeconds(); //获得秒
      if (Seconds <= 9) {
        Seconds = "0" + Seconds;
      }
      //console.log("年"+year + "月" + month + "日" + day+"时"+hours+"分"+minutes+"秒"+Seconds);
      this.yulan = this.formInline1.en_prefix;

      var chaifen = sun.split("");
      for (var s in chaifen) {
        switch (chaifen[s]) {
          case "年":
            this.yulan += year;
            break;
          case "月":
            this.yulan += month;
            break;
          case "日":
            this.yulan += day;
            break;
          case "时":
            this.yulan += hours;
            break;
          case "分":
            this.yulan += minutes;
            break;
          case "秒":
            this.yulan += Seconds;
            break;
        }
        console.log(this.checkList);
      }

      var b = 0; //获取流水号  如:01  001
      b = this.formInline1.en_num;
      for (var b = 1; b < su; b++) {
        this.yulan += "0";
        console.log("进来了" + b);
      }
      this.yulan += "1";
      //#endregion
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
      this.checkList = [];
    },
    findXLK() {
      $http.get("http://localhost:5149/api/Sys_encode/FindXlk").then((res) => {
        this.list1 = res;
      });
    },
  },
  mounted() {
    this.find();
    this.findXLK();
  },
};
</script>
<style scoped src="../CSS/public.css"></style>
<style src="../CSS/tableys.css"></style>

<style>
#bmbd {
  width: 380px;
  margin-left: 20px;
  margin-top: -34px;
  position: relative;
  top: 35px;
}
#bmbd1 {
  position: relative;
  top: -10px;
}
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

#bj {
  width: 100%;
}

#form_top {
  margin-right: 25px !important;
  margin-bottom: 12px;
}
.el-drawer__header {
  align-items: center;
  color: #72767b;
  display: flex;
  margin-bottom: 5px !important;
  padding: 20px 20px 0;
}
#didi {
  position: absolute;
  bottom: -0px;
  box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
  background-color: #fff;
  width: 430px;
  height: 60px;
  text-align: center;
  line-height: 60px;
}
#qx {
  width: 150px;
  height: 35px;
  line-height: 35px;
  padding: 0px !important;
  background-color: #fff;
  color: #000;
  margin-left: 30px;
}
#tj {
  width: 150px;
  height: 35px;
  line-height: 35px;
  padding: 0px !important;
  background-color: #9c27b0;
  color: #fff;
  margin-left: 50px;
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
#HE {
  height: 500px;
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