<template>
  <div id="kj">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">订单管理</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>进货退货</el-breadcrumb-item>
    </el-breadcrumb>
    <!--搜索-->
    <transition-group name="lyric">
      <div id="form" v-if="showDefaultAttr" key="1">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="退货单号" id="form_top">
            <el-input
              v-model="formInline.bh"
              id="tex"
              placeholder="退货单号"
            ></el-input>
          </el-form-item>
          <el-form-item label="单据状态" id="form_top">
            <el-select v-model="formInline.zt" id="tex" placeholder="单据状态">
              <el-option label="待审核" value="0"></el-option>
              <el-option label="驳回" value="1"></el-option>
              <el-option label="通过" value="2"></el-option>
              <el-option label="部分退货" value="3"></el-option>
              <el-option label="全部退货" value="4"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="供应商" id="form_top">
            <el-input
              v-model="formInline.gys"
              id="tex"
              placeholder="供应商"
            ></el-input>
          </el-form-item>
          <el-form-item label="退货日期" prop="startDate">
            <el-date-picker
              v-model="formInline.date"
              type="date"
              id="tex"
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
      <el-button id="tex3" @click="inserok()" icon="el-icon-plus"
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
      <el-button
        id="tex6"
        @click="chexiao"
        :disabled="multipleSelection.length > 1"
        icon="el-icon-sort"
        >撤销</el-button
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
      tooltip-effect="dark"
      height="450px"
      v-loading="tableloading"
      @selection-change="handleSelectionChange"
      :data="tableData"
      :header-cell-style="{ background: '#F8F8F9', color: '#606266' }"
      element-loading-text="拼命加载中"
      element-loading-spinner="el-icon-loading"
      id="tableMain"
    >
      <el-table-column type="selection" width="55"> </el-table-column>
      <el-table-column fixed prop="" label="退货单号" width="150">
        <template slot-scope="scope">
          <a
            href="javascript:void(0)"
            style="color: #9c27b0"
            v-on:click="jhdh(scope.row)"
            >{{ scope.row.returns_code }}</a
          >
        </template>
      </el-table-column>
      <el-table-column fixed label="单据状态" width="100">
        <template slot-scope="scope">
          <span
            v-if="scope.row.sale_state == 0"
            style="color: blue; font-weight: 600; font-size: 13px"
            >待审核</span
          >
          <span
            v-if="scope.row.sale_state == 1"
            style="color: red; font-weight: 600; font-size: 13px"
            >驳回</span
          >
          <span
            v-if="scope.row.sale_state == 2"
            style="color: Green; font-weight: 600; font-size: 13px"
            >通过</span
          >
          <span
            v-if="scope.row.sale_state == 3"
            style="color: #9c27b0; font-weight: 600; font-size: 13px"
            >部分退货</span
          >
          <span
            v-if="scope.row.sale_state == 4"
            style="color: #000; font-weight: 600; font-size: 13px"
            >全部退货</span
          >
        </template>
      </el-table-column>
      <el-table-column fixed label="退货日期" width="170">
        <template slot-scope="scope">
          <span>{{ filterTime(scope.row.sr_date) }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="buy_code" label="进货单号" width="120">
      </el-table-column>
      <el-table-column prop="supply_code" label="供应商" width="120">
      </el-table-column>
      <el-table-column prop="link_man" label="联系人" width="120">
      </el-table-column>
      <el-table-column prop="link_way" label="联系方式" width="120">
      </el-table-column>
      <el-table-column prop="buy_man" label="进货人" width="120">
      </el-table-column>
      <el-table-column prop="returns_num" label="退货数量" width="120">
      </el-table-column>
      <el-table-column prop="returns_money" label="退货金额" width="120">
      </el-table-column>
      <el-table-column
        prop="names"
        :show-overflow-tooltip="true"
        label="退货货品"
        width="120"
      >
      </el-table-column>
      <el-table-column prop="create_by" label="制单人" width="120">
      </el-table-column>
      <el-table-column label="制单时间" width="170">
        <template slot-scope="scope">
          <span>{{ filterTime(scope.row.create_time) }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="sure_man" label="审核人" width="120">
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
          <span v-if="scope.row.sale_state == 3 || scope.row.sale_state == 4">
          </span>
          <span
            v-if="
              scope.row.sale_state == 1 ||
              scope.row.sale_state == 0 ||
              scope.row.sale_state == 2
            "
          >
            <img
              src="../Images/bianji1.png"
              title="编辑"
              width="25px"
              height="25px"
              style="position: relative; left: 0px; top: 5px"
              @click="handleEdit(scope.row)"
            />

            <!-- <img
            src="../Images/bianji1.png"
            title="编辑"
            width="25px"
            height="25px"
            @click="handleEdit(scope.row)"
          /> -->

            <img
              src="../Images/shanchu.png"
              style="position: absolute; left: 40px; top: 15px"
              title="删除"
              width="28px"
              height="28px"
              @click="handleDelete(scope.row.buy_codeId)"
            />
          </span>
        </template>
      </el-table-column>
    </el-table>

    <el-table
      tooltip-effect="dark"
      @selection-change="handleSelectionChange"
      :data="tableData1"
      :header-cell-style="{
        background: '#F8F8F9',
        color: '#606266',
        'text-align': 'center',
      }"
      :cell-style="{ 'text-align': 'center' }"
      id="jhmx"
    >
      <el-table-column type="selection" width="55"> </el-table-column>
      <el-table-column label="序号" type="index" width="50"> </el-table-column>
      <el-table-column prop="item_name" label="货品名称" width="90">
      </el-table-column>
      <el-table-column prop="item_code" label="货品编号" width="90">
      </el-table-column>
      <el-table-column prop="item_type_name" label="货品类型" width="90">
      </el-table-column>
      <el-table-column prop="model_code" label="规格型号" width="90">
      </el-table-column>
      <el-table-column prop="unit" label="单位" width="90"> </el-table-column>

      <el-table-column prop="buy_num" label="进货数量" width="90">
      </el-table-column>
      <el-table-column prop="inbill_num" label="已入库" width="80">
      </el-table-column>
      <el-table-column label="未入库" width="80">
        <template slot-scope="scope">
          <span>{{ scope.row.buy_num - scope.row.inbill_num }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="treat_num" label="退货数量" width="90">
        <template slot-scope="scope">
          <input
            :id="'numberSum' + (scope.$index + 1)"
            readonly
            style="border: 0px solid; margin-left: 30px"
            v-model="tableData1[scope.$index].return_goods_num"
          />
        </template>
      </el-table-column>
      <el-table-column prop="buy_goods_money" label="进货单价" width="90">
      </el-table-column>
      <el-table-column label="退货金额" width="90">
        <template slot-scope="scope">
          <input
            style="border: 0px solid"
            readonly
            v-model="tableData1[scope.$index].return_money"
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

    <el-drawer
      title="新增"
      :visible.sync="drawer"
      :direction="direction"
      :before-close="handleClose"
    >
      <div class="demo-drawer__content">
        <el-form :model="formInline">
          <el-form-item label="活动名称" :label-width="formLabelWidth">
            <el-input v-model="formInline.bh" autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item label="活动区域" :label-width="formLabelWidth">
            <el-select v-model="formInline.bh" placeholder="请选择活动区域">
              <el-option label="区域一" value="shanghai"></el-option>
              <el-option label="区域二" value="beijing"></el-option>
            </el-select>
          </el-form-item>
        </el-form>
        <div class="demo-drawer__footer" id="didi">
          <el-button id="tj" @click="closeDrawer()">提交</el-button>
          <el-button @click="cancelForm" id="qx">取 消</el-button>
        </div>
      </div>
    </el-drawer>

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
export function formatDate(date) {
  let time = new Date(date);
  console.log(time);
  let year = time.getFullYear();
  console.log(year);
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
var str = "1=1 and is_del=0";
export default {
  data() {
    return {
      formLabelWidth: "80px",
      drawer: false,
      direction: "rtl",
      dialogFormVisible: false,
      tableloading: false, //加载
      showDefaultAttr: true,
      multipleSelection: [], // 选中的行数据
      formInline: {
        bh: "",
        zt: "",
        gys: "",
        date: "",
      },
      tableData: [],
      tableData1: [],
      currentPage: 1, //当前页
      pagesize: 10, //每页显示数
      rows: 0, //总行数
      str,
      delarr: [],
      resource: "",
      desc: "",
      buy_codeId: 0,
      buy_code1: "",
      returns_code: "",
    };
  },
  methods: {
    updateTextBox(i) {
      this.desc = i === "2" ? "通过" : "驳回";
    },
    daoru() {},
    daochu() {},
    qd() {
      if (this.resource == 1) {
        $http
          .put(
            "http://localhost:5149/api/Wh_return_supply_h/Wh_return_supply_h_sale_state1?sale_state=" +
              this.resource +
              "&sure_man=" +
              localStorage.getItem("name") +
              "&buy_codeId=" +
              this.buy_codeId +
              "&sure_yj=" +
              this.desc +
              ""
          )
          .then((res) => {
            if (res) {
              this.$message({
                message: "审核成功！",
                type: "success",
              });
              this.dialogFormVisible = false;
              this.find();
            }
          })
          .catch((err) => {
            console.log(err);
          });
      } else {
        let j = 0;
        j++;
        const s = {
          sale_state: this.resource,
          sure_man: localStorage.getItem("name"),
          sure_yj: this.desc,
          buy_codeId: this.buy_codeId,
        };
        var i = 0;
        this.tableData1 = this.tableData1.map((item) => {
          i++;
          return {
            ...item,
            return_goods_num: document.getElementById("numberSum" + i).value,
            buy_code: this.buy_code1,
          };
        });
        const jsonString = JSON.stringify(this.tableData1);
        const jsonString1 = JSON.stringify(s);
        console.log(jsonString);
        console.log(jsonString1);
        $http
          .get(
            "http://localhost:5149/api/Wh_return_supply_h/Wh_return_supply_h_sale_state",
            {
              params: {
                json: jsonString,
                xx: jsonString1,
              },
            }
          )
          .then((res) => {
            if (res) {
              this.$message({
                message: "审核成功!",
                type: "success",
              });
              this.dialogFormVisible = false;
              this.find();
            }
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
    //退货明细
    findddd() {
      $http
        .get(
          "http://localhost:5149/api/Wh_buy_order_h/Wh_buy_order_h_Code1Asyunc?buy_code=" +
            this.buy_code1 +
            ""
        )
        .then((res) => {
          console.log(res);
          this.tableData1 = res;
          this.FindNum();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    FindNum() {
      $http
        .get(
          "http://localhost:5149/api/Wh_return_supply_h/Wh_return_supply_h_Code1Asyunc?returns_code=" +
            this.returns_code +
            ""
        )
        .then((res) => {
          console.log(res);

          let i = -1;
          this.tableData1 = this.tableData1.map((item) => {
            i++;
            return {
              ...item,
              return_goods_num: res[i].return_goods_num,
              return_money: res[i].return_money,
            };
          });

          for (let i = 0; i < res.length; i++) {
            this.thsl += res[i].return_goods_num;
            this.zje1 += res[i].return_money;
          }
        })
        .catch((err) => {
          console.log(err);
        });
    },
    //取消
    qx() {
      this.dialogFormVisible = false;
    },
    //撤销
    chexiao() {
      if (this.multipleSelection.length == 0) {
        this.$notify.error({
          title: "错误",
          message: "请选择要进行撤销的数据",
        });
        return;
      }
      for (let i = 0; i < this.multipleSelection.length; i++) {
        var zt = this.multipleSelection[i].sale_state;
      }
      if (zt == 0) {
        this.$message({
          message: "无法执行该操作",
          type: "warning",
        });
        return;
      } else if (zt == 1) {
        this.$message({
          message: "无法执行该操作",
          type: "warning",
        });
        return;
      } else if (zt == 2) {
        this.$confirm("是否撤销所选单据", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning",
        })
          .then(() => {
            $http
              .put(
                "http://localhost:5149/api/Wh_return_supply_h/Wh_return_supply_h_chexiao?sure_man=" +
                  localStorage.getItem("name") +
                  "&buy_codeId=" +
                  this.buy_codeId +
                  ""
              )
              .then((res) => {
                if (res) {
                  this.$message({
                    message: "撤销成功!",
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
              message: "已取消撤销",
            });
          });
      }
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
        var zt = this.multipleSelection[i].sale_state;
      }
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
    jhdh(id) {
      this.$router.push({
        path: "/ReturnedGoodsCode",
        query: {
          returns_code: id.returns_code,
          buy_code: id.buy_code,
        },
      });
    },
    handleEdit(id) {
      this.$router.push({
        path: "/ReturnedGoodsUpdate",
        query: {
          returns_code: id.returns_code,
          buy_code: id.buy_code,
        },
      });
      // this.drawer = true;
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
    inserok() {
      this.$router.push("/ReturnedGoodsAdd");
    },
    //查询方法
    find() {
      var t = this;
      $http
        .get(
          "http://localhost:5149/api/Wh_return_supply_h/Wh_return_supply_hFenYe",
          {
            params: {
              pageSize: t.pagesize,
              currentPage: t.currentPage,
              str,
            },
          }
        )
        .then((res) => {
          console.log(res);
          t.tableData = res.list;
          t.rows = res.rows;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    //重置
    reset() {
      this.formInline = {
        bh: "",
        zt: "",
        gys: "",
        date: "",
      };
    },
    //搜索
    search() {
      this.currentPage = 1;
      str = "1=1 and is_del=0 ";
      if (this.formInline.bh != "") {
        str += "and returns_code like '%" + this.formInline.bh + "%'";
      }
      if (this.formInline.zt != "") {
        str += "and sale_state like '%" + this.formInline.zt + "%'";
      }
      if (this.formInline.gys != "") {
        str += "and supply_code like '%" + this.formInline.gys + "%'";
      }
      if (this.formInline.date != "") {
        const yearMonthDay = this.formInline.date.substring(0, 10);
        str +=
          "and convert(varchar(50),sr_date,120) LIKE  '" + yearMonthDay + "%'";
      }
      this.find();
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      for (let i = 0; i < this.multipleSelection.length; i++) {
        this.buy_codeId = this.multipleSelection[i].buy_codeId;
        this.buy_code1 = this.multipleSelection[i].buy_code;
        this.returns_code = this.multipleSelection[i].returns_code;
      }
      this.findddd();
      console.log(this.multipleSelection);
    },
    //删除
    handleDelete(buy_codeId) {
      this.$confirm("此操作将永久删除该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          $http
            .put(
              "http://localhost:5149/api/Wh_return_supply_h/Wh_return_supply_h_Delete?buy_codeId=" +
                buy_codeId +
                ""
            )
            .then((res) => {
              if (res) {
                this.$message({
                  message: "删除成功!",
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
      this.$confirm("此操作将永久删除该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          const length = this.multipleSelection.length;
          var strs = [];
          for (let i = 0; i < this.multipleSelection.length; i++) {
            strs.push(this.multipleSelection[i].buy_codeId);
          }
          console.log(strs);
          $http
            .put(
              "http://localhost:5149/api/Wh_return_supply_h/Wh_return_supply_h_DeleteArry/route",
              strs
            )
            .then((res) => {
              if (res) {
                this.$message({
                  message: "删除成功!",
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
    //时间格式化
    filterTime(timestamp) {
      return formatDate(timestamp);
    },
    cancelForm() {
      this.drawer = false;
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
</script>
<style scoped src="../CSS/public.css"></style>
<style src="../CSS/tableys.css"></style>

<style scoped>
#jhmx {
  display: none;
}
#dx {
  margin-left: -64px;
  margin-top: 49px;
}
#yj {
  height: 100px;
}
.el-drawer__header {
  align-items: center;
  color: #000 !important;
  display: flex;
  font-weight: bold;
  margin-bottom: 32px;
  padding: 10px 20px 0 !important;
  box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
  background-color: #fff;
  height: 50px;
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