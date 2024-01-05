<template>
  <div>
    <div id="adddds">
      <div
        style="
          height: 60;
          line-height: 60px;
          box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
          background-color: #fff;
        "
      >
        <h4 style="margin-left: 25px">基础信息</h4>
      </div>
      <div style="margin-top: 30px">
        <el-form
          :inline="true"
          :model="formInline"
          :rules="rules"
          class="demo-form-inline"
          ref="formInline1"
        >
          <el-form-item label="盘点单号" id="yy" prop="dh">
            <el-input
              v-model="formInline.dh"
              id="tex"
              placeholder="自动获取系统编号"
              :readonly="true"
            ></el-input>
          </el-form-item>

          <el-form-item label="盘点开始时间" prop="datek" id="ru">
            <el-date-picker
              v-model="formInline.datek"
              id="tex"
              type="datetime"
              placeholder="选择日期时间"
              value-format="yyyy-MM-dd HH:mm:ss"
            >
            </el-date-picker>
          </el-form-item>

          <el-form-item label="盘点类型" id="yy" prop="lx">
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

          <el-form-item label="仓库名称" id="yy" prop="mc">
            <el-select
              v-model="formInline.mc"
              clearable
              filterable
              id="tex"
              placeholder="请选择"
              @change="cang()"
            >
              <el-option
                v-for="item in countryList"
                :key="item"
                :label="item"
                :value="item"
              ></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="盘点结束时间" prop="date" id="ru">
            <el-date-picker
              v-model="formInline.date"
              id="tex"
              type="datetime"
              placeholder="选择日期时间"
              value-format="yyyy-MM-dd HH:mm:ss"
            >
            </el-date-picker>
          </el-form-item>
          <el-form-item label="经办人" id="yyy">
            <el-select
              v-model="formInline.jbr"
              id="tex"
              clearable
              filterable
              placeholder="请选择"
            >
              <el-option
                v-for="item in countryList2"
                :key="item.u_id"
                :label="item.u_True_name"
                :value="item.u_True_name"
              ></el-option>
            </el-select>
          </el-form-item>

          <el-form-item label="备注" id="yyyy">
            <el-input
              id="te"
              type="textarea"
              placeholder="请输入"
              v-model="formInline.bei"
              maxlength="100"
              :rows="5"
              show-word-limit
            >
            </el-input>
          </el-form-item>
        </el-form>
      </div>
    </div>
    <div id="addx">
      <div
        style="
          height: 60;
          line-height: 60px;
          box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
          background-color: #fff;
        "
      >
        <h4 style="margin-left: 25px">盘点明细</h4>
      </div>
      <div style="margin-top: 50px; margin-left: 30px">
        <el-button id="bcc" @click="bcc()" :disabled="true">添加</el-button>
        <el-button
          id="yichuchu"
          @click="sc()"
          icon="el-icon-delete"
          :disabled="true"
          >移除</el-button
        >
        <el-table
          tooltip-effect="dark"
          :data="tableData"
          height="300"
          :row-style="{ height: 70 + 'px' }"
          :header-cell-style="{
            background: '#F8F8F9',
            color: '#606266',
            'text-align': 'center',
          }"
          :cell-style="{ 'text-align': 'center' }"
          id="ttt"
          @selection-change="handleSelectionChange"
        >
          <el-table-column type="selection" width="55"> </el-table-column>
          <el-table-column label="序号" fixed type="index" width="50">
          </el-table-column>
          <el-table-column prop="buy_code" label="货品编号" v-if="false">
          </el-table-column>

          <el-table-column fixed prop="item_name" label="货品名称" width="100">
          </el-table-column>
          <el-table-column fixed label="货品编号" width="100">
            <template slot-scope="scope">
              <span :id="'hp' + (scope.$index + 1)">{{
                scope.row.item_code
              }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="item_type_name" label="货品类型" width="80">
          </el-table-column>
          <el-table-column prop="model_code" label="规格型号" width="80">
          </el-table-column>
          <el-table-column prop="unit" label="单位" width="80">
          </el-table-column>

          <el-table-column label="账面库存" width="80" prop="account_num">
            <template slot-scope="scope">
              <span :id="'ku' + (scope.$index + 1)">{{
                scope.row.account_num
              }}</span>
            </template>
          </el-table-column>
          <el-table-column label="账面金额" width="140">
            <template slot-scope="scope">
              <span :id="'jin' + (scope.$index + 1)">{{
                scope.row.inbill_price * scope.row.account_num
              }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="area_code" label="盘点仓位" width="140px">
            <template slot-scope="scope">
              <select
                v-model="scope.row.area_code"
                placeholder="请选择"
                @change="kuwei(scope.row.cw, scope.$index + 1)"
                style="
                  width: 120px;
                  height: 25px;
                  border: 1px solid rgb(211 211 217);
                "
              >
                <option
                  v-for="item in countryList1"
                  :key="item.ware_area_id"
                  :label="item.area_name"
                  :value="item.area_name"
                ></option>
              </select>
            </template>
          </el-table-column>
          <el-table-column prop="inventory_num" label="盘点数量" width="140">
            <template slot-scope="scope">
              <input
                type="text"
                v-model="scope.row.inventory_num"
                style="
                  width: 110px;
                  height: 25px;
                  border: 1px solid rgb(211 211 217);
                "
                placeholder="货品数量"
                name="grantDetails[0].numberSum"
                :id="'numberSum' + (scope.$index + 1)"
                v-on:keyup="onKeyPress(scope.$index + 1)"
                value="0"
              />
            </template>
          </el-table-column>
          <el-table-column label="盈亏数量" width="140" prop="break_even_num">
            <template slot-scope="scope">
              <span :id="'weiSum' + (scope.$index + 1)">{{
                scope.row.break_even_num
              }}</span>
            </template>
          </el-table-column>
          <el-table-column label="盘点状态" width="140" prop="inventory_state">
            <template slot-scope="scope">
              <el-tag
                :id="'elTag' + (scope.$index + 1)"
                v-if="scope.row.inventory_state == 0"
                class="el-tag el-tag--light el-tag--primary"
                disable-transitions
                >未盈亏</el-tag
              >
              <el-tag
                :id="'elTag' + (scope.$index + 1)"
                v-if="scope.row.inventory_state == 1"
                class="el-tag el-tag--light el-tag--danger"
                disable-transitions
                >盘亏</el-tag
              >
              <el-tag
                :id="'elTag' + (scope.$index + 1)"
                v-if="scope.row.inventory_state == 2"
                class="el-tag el-tag--light el-tag--success"
                disable-transitions
                >盘盈</el-tag
              >
            </template>
          </el-table-column>

          <el-table-column label="入库单价" width="100" prop="inbill_price">
            <template slot-scope="scope">
              <span :id="'saleSum' + (scope.$index + 1)">{{
                scope.row.inbill_price
              }}</span>
            </template>
          </el-table-column>
          <el-table-column label="入库金额" width="100">
            <template slot-scope="scope">
              <i :id="'totalsum' + (scope.$index + 1)" style="color: red">{{
                scope.row.inbill_price * scope.row.inventory_num
              }}</i>
            </template>
          </el-table-column>

          <el-table-column prop="remark" label="备注" width="300">
            <template slot-scope="scope">
              <input
                v-model="scope.row.remark"
                style="
                  width: 260px;
                  height: 25px;
                  border: 1px solid rgb(211 211 217);
                "
              />
            </template>
          </el-table-column>
        </el-table>
        <div
          style="
            border: 1px solid #eeeeee;
            width: 1080px;
            height: 45px;
            display: inline-block;
          "
        >
          <span style="line-height: 45px; font-size: 14px; margin-left: 25px"
            >合计</span
          >
          <p style="float: right">
            <span style="line-height: 45px; font-size: 14px">账面库存：</span>
            <span
              style="
                line-height: 45px;
                font-weight: bold;
                color: red;
                font-size: 14px;
                margin-right: 25px;
              "
              id="sumKu"
              >0</span
            >
            <span style="line-height: 45px; font-size: 14px">账面金额：</span>
            <span
              style="
                line-height: 45px;
                font-weight: bold;
                color: red;
                font-size: 14px;
                margin-right: 25px;
              "
              id="sumJin"
              >￥0.00</span
            >
            <span style="line-height: 45px; font-size: 14px">盘点数量：</span>
            <span
              style="
                line-height: 45px;
                font-weight: bold;
                color: red;
                font-size: 14px;
                margin-right: 25px;
              "
              id="sumNumber"
              >0</span
            >
            <span style="line-height: 45px; font-size: 14px">盘点金额：</span>
            <span
              style="
                line-height: 45px;
                font-weight: bold;
                color: red;
                font-size: 14px;
                margin-right: 25px;
              "
              id="sumSalary"
              >￥0.00</span
            >
            <span style="line-height: 45px; font-size: 14px">盘盈数量：</span>
            <span
              style="
                line-height: 45px;
                font-weight: bold;
                color: red;
                font-size: 14px;
                margin-right: 25px;
              "
              id="sumNumbery"
              >0</span
            >
            <span style="line-height: 45px; font-size: 14px">盘亏数量：</span>
            <span
              style="
                line-height: 45px;
                font-weight: bold;
                color: red;
                font-size: 14px;
                margin-right: 25px;
              "
              id="sumNumberk"
              >0</span
            >
            <span style="line-height: 45px; font-size: 14px">盘盈金额：</span>
            <span
              style="
                line-height: 45px;
                font-weight: bold;
                color: red;
                font-size: 14px;
                margin-right: 25px;
              "
              id="sumSalaryy"
              >￥0.00</span
            >
            <span style="line-height: 45px; font-size: 14px">盘亏金额：</span>
            <span
              style="
                line-height: 45px;
                font-weight: bold;
                color: red;
                font-size: 14px;
                margin-right: 25px;
              "
              id="sumSalaryk"
              >￥0.00</span
            >
          </p>
        </div>
      </div>
    </div>

    <!-- 添加货品 -->
    <el-dialog
      title="添加货品"
      :visible.sync="dialogFormVisible1"
      width="800px"
      id="tjsh"
    >
      <el-form :inline="true" :model="formtable1" class="demo-form-inline">
        <el-form-item label="">
          <el-input
            v-model="formtable1.bh"
            id="bddd"
            placeholder="请输入货品编号/名称"
          ></el-input>
        </el-form-item>
        <el-form-item label="" style="margin-left: 30px">
          <el-select
            v-model="formtable1.dw"
            clearable
            filterable
            placeholder="请选择单位"
            id="bddd"
          >
            <el-option label="箱" value="箱"></el-option>
            <el-option label="瓶" value="瓶"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button
            icon="el-icon-refresh"
            style="margin-left: 60px"
            id="bddddd"
            @click="cz1()"
            >重置</el-button
          >
          <el-button
            type="primary"
            icon="el-icon-search"
            style="margin-left: 20px"
            @click="onSubmit1()"
            id="bdddd"
            >查询</el-button
          >
        </el-form-item>
      </el-form>
      <el-table
        ref="tablee"
        height="300"
        :data="gridData1"
        :header-cell-style="{ background: '#F8F8F9', color: '#606266' }"
        @selection-change="handleSelectionChange1"
      >
        <el-table-column type="selection" width="55"> </el-table-column>
        <el-table-column label="序号" type="index" width="50">
        </el-table-column>
        <el-table-column
          property="item_code"
          label="货品编号"
          width="100"
        ></el-table-column>
        <el-table-column
          property="item_name"
          label="货品名称"
          width="120"
        ></el-table-column>
        <el-table-column
          property="model_code"
          label="规格型号"
          width="120"
        ></el-table-column>
        <el-table-column
          property="unit"
          label="单位"
          width="100"
        ></el-table-column>
        <el-table-column
          property="inbill_price"
          label="销售单价"
          width="100"
        ></el-table-column>
      </el-table>
      <el-pagination
        id="fenye"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="currentPage2"
        :page-sizes="[4, 8, 12, 16]"
        :page-size="pagesize2"
        layout="total, sizes, prev, pager, next, jumper"
        :total="rows2"
      >
      </el-pagination>
      <div slot="footer" class="dialog-footer">
        <el-button id="gb1" @click="qqxx()">取 消</el-button>
        <el-button
          id="bc12"
          style="background-color: #9c27b0; color: #fff"
          @click="qd()"
          >确 定</el-button
        >
      </div>
    </el-dialog>

    <div id="notification-container">
      <div id="dibu">
        <el-button id="gb" @click="gb()">关闭</el-button>
        <el-button id="bc" @click="bc()">保存</el-button>
      </div>
    </div>
  </div>
</template>

<script>
import $http from "../http/base.js";
export default {
  data() {
    return {
      kj: false,
      type: "",
      str: "is_del=0 and 1=1 and sale_state=2 or sale_state=3",
      str1: "1=1",
      dialogVisible: true,
      dialogFormVisible: false,
      dialogFormVisible1: false,
      gridData: [],
      gridData1: [],
      multipleSelection: [], // 选中的行数据
      multipleSelection1: [], // 选中的行数据
      currentPage: 1, //当前页
      pagesize: 4, //每页显示数
      currentPage1: 1, //当前页
      pagesize1: 20, //每页显示数

      currentPage2: 1, //当前页
      pagesize2: 4, //每页显示数
      rows: 0, //总行数
      rows1: 0,
      rows2: 0,
      tableData: [],
      ff1: true,
      formtable1: {
        bh: "",
        dw: "",
      },
      formtable: {
        dh: "",
        zt: "",
        gys: "",
        jhr: "",
        data: "",
      },
      xx: {
        wei: 0,
        cw: "",
        sl: "",
        bei: "",
        jin: 0,
      },
      ff: false,
      zj: true,
      countryList: [],
      countryList1: [],
      countryList2: [],

      formInline: {
        dh: "11",
        lx: "",
        mc: "",
        date: "",
        bei: "",
        jbr: "",
        datek: "",
        zt: "",
        user: localStorage.getItem("name"),
      },
      hp: "",
      rules: {
        datek: [
          { required: true, message: "请选择开始时间!", trigger: "blur" },
        ],
        date: [{ required: true, message: "请选择结束时间!", trigger: "blur" }],
        dh: [{ required: true, message: "请填写单号!", trigger: "blur" }],
        lx: [{ required: true, message: "请选择入库类型!", trigger: "change" }],
        mc: [{ required: true, message: "请选择仓库名称!", trigger: "change" }],
      },
    };
  },

  methods: {
    //库位改变事件
    kuwei(cw, index) {
      //数量
      var hp = document.getElementById("hp" + index).innerHTML;

      $http
        .get(
          " http://localhost:5149/api/Wh_outbill_h/Num?hp=" +
            hp +
            "&kw=" +
            cw +
            ""
        )
        .then((res) => {
          if (res == "") {
            document.getElementById("ku" + index).innerHTML = "";
            document.getElementById("jin" + index).innerHTML = "";
            this.$message({
              showClose: true,
              message: "该库位未找到该商品，请重新选择！",
              type: "error",
            });
          } else {
            document.getElementById("ku" + index).innerHTML =
              res.inbill3_num - res.plan_outnum;
            document.getElementById("jin" + index).innerHTML =
              (res.inbill3_num - res.plan_outnum) *
              document.getElementById("saleSum" + index).innerHTML;
          }
        })
        .catch((err) => {
          alert(err);
        });
    },
    //仓库改变事件
    cang() {
      var t = this;
      if (t.formInline.mc == "") {
        t.tableData = [];
        return;
      }
      $http
        .post(
          "http://localhost:5149/api/Wh_inbill_h/Bs_ware_areaName?bh=" +
            this.formInline.mc
        )
        .then((res) => {
          t.countryList1 = res;
        })
        .catch((err) => {
          alert(err);
        });
    },

    //添加查询
    onSubmit1() {
      this.str1 = "1=1";
      if (this.formtable1.bh != "") {
        this.str1 +=
          "and item_code like '%" +
          this.formtable1.bh +
          "%' or item_name like '%" +
          this.formtable1.bh +
          "%' ";
      }
      if (this.formtable1.dw != "") {
        this.str1 += "and unit like '%" + this.formtable1.dw + "%'";
      }
      this.find1();
    },
    //添加重置
    cz1() {
      this.formtable1 = {
        bh: "",
        dw: "",
      };
    },
    //下拉框
    CK() {
      var t = this;
      //仓库
      $http
        .get("http://localhost:5149/api/Wh_outbill_h/Ku?id=1")
        .then((res) => {
          t.countryList = res;
        })
        .catch((err) => {
          alert(err);
        });
      //经办人
      $http
        .get("http://localhost:5149/api/Wh_inbill_h/FindUser")
        .then((res) => {
          t.countryList2 = res;
        })
        .catch((err) => {
          alert(err);
        });
    },

    filterTime(timestamp) {
      return formatDate(timestamp);
    },
    //保存
    bc() {
      var i = 0;
      this.tableData = this.tableData.map((item) => {
        i++;
        let sum = document.getElementById("weiSum" + i).innerHTML;
        if (sum !== "0") {
          this.formInline.zt = "1";
        } else {
          this.formInline.zt = "0";
        }
        return {
          ...item,
          zong: document.getElementById("totalsum" + i).innerHTML,
          zm: document.getElementById("ku" + i).innerHTML,
          yksl: sum,
          pdzt: document.getElementById("elTag" + i).innerHTML,
        };
      });

      this.$refs["formInline1"].validate((valid) => {
        if (!valid) return;

        const serializedData = JSON.stringify(this.formInline);
        const serializedData1 = JSON.stringify(this.tableData);
        console.log(serializedData1);
        console.log(serializedData);

        $http
          .get("http://localhost:5149/api/Wh_inventory_h/Update", {
            params: {
              arrayList: serializedData,
              xx: serializedData1,
            },
          })
          .then((res) => {
            if (res) {
              this.$notify({
                title: "修改成功",
                message: "这是一条成功的提示消息",
                type: "success",
              });
              this.$router.push("/Wh_inventory_h");
            }
          })
          .catch((err) => {
            alert(err);
          });
      });
    },
    //添加
    bcc() {
      if (this.formInline.mc == "") {
        this.$message({
          showClose: true,
          message: "未选择仓库！",
          type: "error",
        });
        return;
      }
      this.find1();
      this.dialogFormVisible1 = true;
      this.formtable1 = {
        bh: "",
        dw: "",
      };
    },
    //盘点明细
    find1() {
      var t = this;
      if (t.formInline.mc == "") {
        return;
      }
      $http
        .get("http://localhost:5149/api/Wh_outbill_h/Hp?ck=" + t.formInline.mc)
        .then((res) => {
          t.hp = res.map((item) => "'" + item + "'"); // 给每个值加上单引号
          t.str1 += "AND item_code IN (" + t.hp.join(",") + ")"; // 使用逗号分隔每个值

          $http
            .post(
              "http://localhost:5149/api/Wh_inbill_h/Hp?page=" +
                t.pagesize2 +
                "&pageSize=" +
                t.currentPage2 +
                "&str=" +
                t.str1
            )
            .then((res) => {
              t.gridData1 = res.list;
              t.rows2 = res.rows;
            })
            .catch((err) => {
              alert(err);
            });
        })
        .catch((err) => {
          alert(err);
        });
    },
    //取消添加
    qqxx() {
      this.dialogFormVisible1 = false;
    },
    //关闭
    gb() {
      this.$router.go(-1);
    },
    //删除
    sc() {
      if (this.multipleSelection.length == 0) {
        this.$message({
          message: "请选择需要移除的货品！",
          type: "warning",
        });
        return;
      }
      this.multipleSelection.forEach((row) => {
        let index = this.tableData.indexOf(row);
        if (index !== -1) {
          this.tableData.splice(index, 1);
        }
      });
      for (var j = 1; j <= this.tableData.length; j++) {
        document.getElementById("numberSum" + j).value = "";
        document.getElementById("totalsum" + j).innerHTML = "";
      }
      document.getElementById("sumNumber").innerHTML = 0.0;
      document.getElementById("sumSalary").innerHTML = 0.0;
      this.$notify({
        title: "成功",
        message: "入库移除成功!",
        type: "success",
      });
    },
    onKeyPress(i) {
      //数量
      var numberSum = document.getElementById("numberSum" + i);
      //单价
      var saleSum = document.getElementById("saleSum" + i);

      //金额
      document.getElementById("totalsum" + i).innerHTML =
        document.getElementById("numberSum" + i).value *
        document.getElementById("saleSum" + i).innerHTML;

      if (isNaN(numberSum.value) || numberSum.value < 0) {
        this.$message({
          showClose: true,
          message: "数量填写错误",
          type: "error",
        });
        numberSum.value = "0";
        return;
      }
      //账面库存
      var ku = document.getElementById("ku" + i).innerHTML;
      //盈亏数量
      document.getElementById("weiSum" + i).innerHTML = numberSum.value - ku;
      var ss = parseInt(document.getElementById("weiSum" + i).innerHTML);
      var ee = document.getElementById("elTag" + i);

      if (ss > 0) {
        // 盘盈
        document.getElementById("elTag" + i).innerHTML = "盘盈";

        ee.classList.add("el-tag--success");
        ee.classList.remove("el-tag--primary");
        ee.classList.remove("el-tag--danger");
      } else if (ss < 0) {
        // 盘亏
        document.getElementById("elTag" + i).innerHTML = "盘亏";

        ee.classList.add("el-tag--danger");
        ee.classList.remove("el-tag--primary");
        ee.classList.remove("el-tag--success");
      } else if (ss == 0) {
        // 未盈亏
        document.getElementById("elTag" + i).innerHTML = "未盈亏";

        ee.classList.add("el-tag--primary");
        ee.classList.remove("el-tag--danger");
        ee.classList.remove("el-tag--success");
      }

      var sum = 0;
      var sum1 = 0;
      var sum2 = 0;
      var sum3 = 0;
      var sum4 = 0;
      var sum5 = 0;
      var sum6 = 0;
      var sum7 = 0;
      var sum8 = 0;
      for (var j = 1; j <= this.tableData.length; j++) {
        var numberSum = document.getElementById("numberSum" + j).value; //数量
        var saleSum = document.getElementById("saleSum" + j).innerHTML; //单价

        var ku = document.getElementById("ku" + j).innerHTML; //账面库存
        var jin = document.getElementById("jin" + j).innerHTML; //账面金额
        var yk = document.getElementById("weiSum" + j).innerHTML; //盈亏数量
        var totalsum = document.getElementById("totalsum" + j).innerHTML; //总金额
        var ykjin = Number(saleSum) * Number(yk);

        if (totalsum == "") {
          totalsum = "0";
        }
        sum2 = Number(sum2) + Number(totalsum);
        if (numberSum == "") {
          numberSum = "0";
        }
        sum = Number(sum) + Number(numberSum);
        sum3 = Number(sum3) + Number(ku);

        sum4 = Number(sum4) + Number(jin);
        if (yk > 0) {
          sum5 = Number(sum5) + Number(yk);
          sum7 = Number(sum7) + Number(ykjin);
        }
        if (yk < 0) {
          sum6 = Number(sum6) + Number(yk);
          sum8 = Number(sum8) + Number(ykjin);
        }
      }
      document.getElementById("sumNumber").innerHTML = sum; //盘点数量
      document.getElementById("sumKu").innerHTML = sum3; //账面库存
      document.getElementById("sumJin").innerHTML = sum4; //账面金额
      document.getElementById("sumSalary").innerHTML = sum2; //盘点金额
      document.getElementById("sumNumbery").innerHTML = sum5; //盘盈数量
      document.getElementById("sumNumberk").innerHTML = sum6; //盘亏数量
      document.getElementById("sumSalaryy").innerHTML = sum7; //盘盈金额
      document.getElementById("sumSalaryk").innerHTML = sum8; //盘亏金额
    },

    //每页显示数改变事件添加收货
    handleSizeChange(size) {
      this.pagesize2 = size;
      this.currentPage2 = 1;
      this.find1();
    },
    //页码改变事件 添加收获
    handleCurrentChange(page) {
      this.currentPage2 = page;
      this.find1();
    },

    //每页显示数改变事件
    handleSizeChange2(size) {
      this.pagesize1 = size;
      this.currentPage1 = 1;

      this.find1();
    },
    //页码改变事件
    handleCurrentChange2(page) {
      this.currentPage1 = page;
      this.find1();
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    //选择-添加
    handleSelectionChange1(val) {
      this.multipleSelection1 = val;
    },
    //添加确定
    qd() {
      this.tableData = this.multipleSelection1;

      this.dialogFormVisible1 = false;

      // document.getElementById("sumNumber").innerHTML = 0;
      // document.getElementById("sumSalary").innerHTML = 0;
      if (this.multipleSelection1.length == 0) {
        this.ff1 = true;
      } else {
        this.ff1 = false;
      }
    },
    //重置
    cz() {
      this.formtable = {
        dh: "",
        zt: "",
        gys: "",
        jhr: "",
        data: "",
      };
    },
    Jia() {
      var bh = this.$route.query.dh;

      $http
        .get(
          "  http://localhost:5149/api/Wh_inventory_h/Wh_inventory_hMH?bh=" + bh
        )
        .then((res) => {
          this.formInline.dh = res.inventory_code;

          this.formInline.lx = res.inventory_type;
          this.formInline.mc = res.ware_code;
          this.formInline.date = res.end_date;
          this.formInline.datek = res.begin_date;
          this.formInline.bei = res.remark;

          this.formInline.jbr = res.sure_man;

          this.cang();
        })
        .catch((err) => {
          alert(err);
        });
    },
    //明细
    find1() {
      var bh = this.$route.query.dh;

      var s1 = 0; //账面库存
      var s2 = 0; //盘点数量
      var s3 = 0; //盘盈数量
      var s4 = 0; //盘亏数量
      var s5 = 0; //账面金额
      var s6 = 0; //盘点金额
      var s7 = 0; //盘盈金额
      var s8 = 0; //盘亏金额

      $http
        .get(
          "  http://localhost:5149/api/Wh_inventory_h/Wh_inventory_dMH?bh=" + bh
        )
        .then((res) => {
          this.tableData = res;
          for (let i = 0; i < this.tableData.length; i++) {
            s1 += this.tableData[i].account_num;
            s2 += this.tableData[i].inventory_num;
            s5 +=
              this.tableData[i].account_num * this.tableData[i].inbill_price;
            s6 +=
              this.tableData[i].inventory_num * this.tableData[i].inbill_price;
            if (this.tableData[i].break_even_num > 0) {
              s3 += this.tableData[i].break_even_num;
              s7 +=
                this.tableData[i].break_even_num *
                this.tableData[i].inbill_price;
            }
            if (this.tableData[i].break_even_num < 0) {
              s4 += this.tableData[i].break_even_num;
              s8 +=
                this.tableData[i].break_even_num *
                this.tableData[i].inbill_price;
            }
          }
          document.getElementById("sumNumber").innerHTML = s2; //盘点数量
          document.getElementById("sumKu").innerHTML = s1; //账面库存
          document.getElementById("sumJin").innerHTML = s5; //账面金额
          document.getElementById("sumSalary").innerHTML = s6; //盘点金额
          document.getElementById("sumNumbery").innerHTML = s3; //盘盈数量
          document.getElementById("sumNumberk").innerHTML = s4; //盘亏数量
          document.getElementById("sumSalaryy").innerHTML = s7; //盘盈金额
          document.getElementById("sumSalaryk").innerHTML = s8; //盘亏金额
        })
        .catch((err) => {
          alert(err);
        });
    },
  },
  mounted() {
    this.CK();
    this.find1();
    this.Jia();
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

<style scoped>
.green-text {
  color: green;
}

.red-text {
  color: red;
}

#gb1 {
  width: 28px !important;
  color: #000;
  background-color: fff;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
}

#bc12 {
  width: 28px !important;
  color: #fff;
  background-color: #9c27b0;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
}

#bb {
  width: 130px !important;
}

#ttt {
  width: 1080px !important;
}

#te {
  width: 970px;
}

#yyy {
  margin-left: 55px;
  margin-top: 5px;
}

#yy2 {
  margin-left: 44px;
  margin-top: 5px;
}

#yy {
  margin-left: 44px;
  margin-top: 5px;
}

#yy1 {
  margin-left: 56px;
  margin-top: 5px;
}

#ru {
  margin-left: 44px;
  margin-top: 5px;
}

#yyyy {
  margin-left: 78px;
  margin-top: 5px;
}

#gb {
  width: 28px !important;
  color: #000;
  background-color: fff;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
}

#bc {
  width: 28px !important;
  color: #fff;
  background-color: #9c27b0;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 20px;
}

#bcc {
  width: 28px !important;
  color: #fff;
  background-color: #9c27b0;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 0px;
  position: relative;
  top: -25px;
}

#yichuchu {
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

#yichuchu:hover {
  background-color: #ff4949;
  color: #fff;
}

#dibu {
  line-height: 60px;
  position: relative;
  right: -945px;
}

#notification-container {
  position: fixed;
  bottom: 0;
  width: 100%;
  box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
  background-color: #fff;
  height: 60px;
  z-index: 3;
}

#adddds {
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 400px;
}

#addx {
  margin-top: 20px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 600px;
}

#fenye1 {
  text-align: center;
  margin-top: 20px;
}

#bddd {
  height: 32px;
  width: 221px;
}

#bddddd {
  width: 28px !important;
  color: #000;
  background-color: #fff;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 0px;
  position: relative;
  top: -0px;
}

#bdddd {
  width: 28px !important;
  color: #fff;
  background-color: blue;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 0px;
  position: relative;
  top: -0px;
}

#tjsh {
  margin-top: -70px;
}

.dialog-footer {
  margin-top: 10px;
}

.el-dialog__footer {
  padding: 10px 20px 20px;
  text-align: right;
  box-sizing: border-box;
  box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
  background-color: #fff;
  border-radius: 5px;
}

#fenye {
  text-align: center;
  margin-top: 25px;
}

.el-dialog {
  position: relative;
  margin: 0 auto 50px;
  background: #fff;
  border-radius: 2px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
  box-sizing: border-box;
  width: 50%;
  border-radius: 50px !important;
}

.el-dialog__header {
  border-radius: 10px !important;
  padding: 20px 20px 10px;
  color: #000 !important;
  display: flex;
  font-weight: bold;
  padding: 20px 20px 0 !important;
  box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
  background-color: #fff;
  height: 45px;
}
</style>