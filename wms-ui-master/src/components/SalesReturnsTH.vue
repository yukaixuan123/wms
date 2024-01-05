<template>
  <div>
    <div id="adds">
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
          <el-form-item label="入库单号" id="yy" prop="sr_code">
            <el-input
              v-model="formInline.sr_code"
              id="tex"
              placeholder="自动获取系统编号"
              :readonly="true"
            ></el-input>
          </el-form-item>

          <el-form-item label="入库类型" id="yyy">
            <el-input
              v-model="formInline.rklx"
              id="tex"
              placeholder="请输入"
              readonly
            ></el-input>
          </el-form-item>
          <el-form-item label="客户名称" id="yyy">
            <el-input
              v-model="formInline.cust_code"
              id="tex"
              placeholder="请输入"
              disabled
            ></el-input>
          </el-form-item>

          <el-form-item label="入库日期" prop="sr_date" id="ru">
            <el-date-picker
              v-model="formInline.sr_date"
              id="tex"
              type="datetime"
              placeholder="选择日期时间"
              value-format="yyyy-MM-dd HH:mm:ss"
            >
            </el-date-picker>
          </el-form-item>

          <el-form-item label="联系方式" id="yyy">
            <el-input
              v-model="formInline.link_way"
              id="tex"
              placeholder="请输入"
              :disabled="true"
            ></el-input>
          </el-form-item>
          <el-form-item label="联系人" id="yy1">
            <el-input
              v-model="formInline.link_man"
              id="tex"
              placeholder="请输入"
              :disabled="true"
            ></el-input>
          </el-form-item>
          <el-form-item label="仓库名称" id="yy" prop="ckmc">
            <el-select
              v-model="formInline.ckmc"
              clearable
              filterable
              id="tex"
              placeholder="请选择"
              @change="cang()"
            >
              <el-option
                v-for="item in countryList"
                :key="item.warehouse_id"
                :label="item.ware_name"
                :value="item.ware_name"
              ></el-option>
            </el-select>
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
              v-model="formInline.bz"
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
        <h4 style="margin-left: 25px">入库明细</h4>
      </div>
      <div style="margin-top: 50px; margin-left: 30px">
        <!-- <el-button id="bcc" @click="bcc()" :disabled="ff">添加</el-button>
        <el-button
          id="yichuchu"
          @click="sc()"
          icon="el-icon-delete"
          :disabled="ff1"
          >移除</el-button
        > -->
        <el-table
          tooltip-effect="dark"
          :data="tableData"
          height="300"
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
          <el-table-column prop="buy_code" label="订单编号" v-if="false">
          </el-table-column>

          <el-table-column fixed prop="item_name" label="货品名称" width="100">
          </el-table-column>
          <el-table-column fixed prop="item_code" label="货品编号" width="100">
          </el-table-column>
          <el-table-column prop="item_type_name" label="货品类型" width="80">
          </el-table-column>
          <el-table-column prop="model_code" label="规格型号" width="80">
          </el-table-column>
          <el-table-column prop="unit" label="单位" width="80">
          </el-table-column>

          <el-table-column label="进货数量" width="80" v-if="kj">
            <template slot-scope="scope">
              <span :id="'xsSum' + (scope.$index + 1)">{{
                scope.row.inbill3_num
              }}</span>
            </template>
          </el-table-column>
          <el-table-column label="已入库数量" width="140" v-if="kj">
            <template slot-scope="scope">
              <span :id="'yiSum' + (scope.$index + 1)">{{
                scope.row.return_num
              }}</span>
            </template>
          </el-table-column>
          <el-table-column label="未入库数量" width="140" v-if="kj">
            <template slot-scope="scope">
              <span
                v-if="scope.row.inbill3_num - scope.row.return_num > 0"
                :id="'weiSum' + (scope.$index + 1)"
                >{{ scope.row.inbill3_num - scope.row.return_num }}</span
              >
              <span
                v-if="scope.row.inbill3_num - scope.row.return_num < 0"
                :id="'weiSum' + (scope.$index + 1)"
                >0</span
              >
            </template>
          </el-table-column>
          <el-table-column prop="cw" label="入库仓位" width="140px">
            <template slot-scope="scope">
              <select
                v-model="scope.row.cw"
                placeholder="请选择"
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

          <el-table-column prop="change" label="本次入库数量" width="140">
            <template slot-scope="scope">
              <input
                type="text"
                v-model="scope.row.change"
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
          <el-table-column label="进货单价" width="100">
            <template slot-scope="scope">
              <span :id="'saleSum' + (scope.$index + 1)">{{
                scope.row.inbill_price
              }}</span>
            </template>
          </el-table-column>
          <el-table-column label="入库金额" width="100">
            <template slot-scope="scope">
              <i :id="'totalsum' + (scope.$index + 1)" style="color: red"></i>
            </template>
          </el-table-column>

          <el-table-column label="备注" width="300">
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
            <span style="line-height: 45px; font-size: 14px">入库数量：</span>
            <span
              style="
                line-height: 45px;
                font-weight: bold;
                color: red;
                font-size: 14px;
                margin-right: 35px;
              "
              id="sumNumber"
              >0</span
            >
            <span style="line-height: 45px; font-size: 14px">总金额：</span>
            <span
              style="
                line-height: 45px;
                font-weight: bold;
                color: red;
                font-size: 14px;
                margin-right: 30px;
              "
              id="sumSalary"
              >￥0.00</span
            >
          </p>
        </div>
      </div>
    </div>
    <!-- 选择进货单 -->
    <el-dialog
      title="选择进货单"
      :visible.sync="dialogFormVisible"
      width="800px"
      id="tjsh"
    >
      <el-form :inline="true" :model="formtable" class="demo-form-inline">
        <el-form-item label="" style="width: 221px">
          <el-input
            v-model="formtable.dh"
            id="bddd"
            placeholder="请输入进货单号"
          ></el-input>
        </el-form-item>
        <el-form-item label="" style="margin-left: 30px">
          <el-select
            v-model="formtable.zt"
            clearable
            filterable
            placeholder="请选择单据状态"
            id="bddd"
          >
            <el-option label="未入库" value="2"></el-option>
            <el-option label="部分入库" value="3"></el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="" style="margin-left: 30px">
          <el-select
            v-model="formtable.gys"
            clearable
            filterable
            placeholder="请选择供应商"
            id="bddd"
          >
            <el-option
              v-for="item in countryList3"
              :key="item.supply_id"
              :label="item.supply_name"
              :value="item.supply_name"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="" style="margin-left: 0px">
          <el-select
            v-model="formtable.jhr"
            clearable
            filterable
            placeholder="请选择进货人"
            id="bddd"
          >
            <el-option
              v-for="item in countryList2"
              :key="item.u_id"
              :label="item.u_True_name"
              :value="item.u_True_name"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="" style="margin-left: 30px">
          <el-date-picker
            v-model="formtable.date"
            id="bddd"
            type="datetime"
            placeholder="请选择进货日期"
            value-format="yyyy-MM-dd HH:mm:ss"
          ></el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-button
            icon="el-icon-refresh"
            style="margin-left: 60px"
            id="bddddd"
            @click="cz()"
            >重置</el-button
          >
          <el-button
            type="primary"
            icon="el-icon-search"
            style="margin-left: 20px"
            @click="onSubmit()"
            id="bdddd"
            >查询</el-button
          >
        </el-form-item>
      </el-form>

      <el-table
        :data="gridData"
        height="300"
        :header-cell-style="{ background: '#F8F8F9', color: '#606266' }"
        @row-click="handleRowClick"
      >
        <el-table-column label="序号" type="index" width="50" fixed>
        </el-table-column>
        <el-table-column
          fixed
          property="buy_code"
          label="进货单号"
          width="100"
        ></el-table-column>
        <el-table-column label="单据状态" width="120">
          <template slot-scope="scope">
            <span
              v-if="scope.row.sale_state == 3"
              style="color: red; font-weight: 600; font-size: 13px"
              >部分入库</span
            >
            <span
              v-if="scope.row.sale_state == 2"
              style="color: green; font-weight: 600; font-size: 13px"
              >未入库</span
            >
          </template>
        </el-table-column>
        <el-table-column label="进货日期" width="140">
          <template slot-scope="scope">
            <span>{{ filterTime(scope.row.buy_date) }}</span>
          </template>
        </el-table-column>
        <el-table-column
          property="supply_code"
          label="供应商"
          width="100"
        ></el-table-column>
        <el-table-column
          property="buy_man"
          label="进货人"
          width="100"
        ></el-table-column>
        <el-table-column
          property="total_buy_num"
          label="货品数量"
          width="100"
        ></el-table-column>
        <el-table-column
          property="total_price"
          label="进货金额"
          width="100"
        ></el-table-column>
      </el-table>
      <el-pagination
        id="fenye"
        @size-change="handleSizeChange1"
        @current-change="handleCurrentChange1"
        :current-page="currentPage"
        :page-sizes="[4, 8, 12, 16]"
        :page-size="pagesize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="rows1"
      >
      </el-pagination>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button style="background-color: #9c27b0; color: #fff" @click="que()"
          >确 定</el-button
        >
      </div>
    </el-dialog>
    <!-- 添加收货 -->
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
          label="入库单价"
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
        <el-button id="bc" @click="bc('formInline1')">保存</el-button>
      </div>
    </div>
  </div>
</template>

<script>
import $http from "../http/base.js";
export default {
  data() {
    return {
      kj: true,
      str: "is_del=0 and 1=1 and sale_state=2 or sale_state=3",
      str1: "1=1",
      str2: "1=1",
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
      countryList3: [],
      formInline: {
        sr_code: "",
        rklx: "退货入库",
        cust_code: "",
        sr_date: "",
        link_man: "",
        link_way: "",
        ckmc: "",
        jbr: "",
        bz: "",
        create_by: localStorage.getItem("name"),
      },
      rules: {
        sr_date: [
          { required: true, message: "请选择入库时间!", trigger: "blur" },
        ],
        sr_code: [{ required: true, message: "请填写单号!", trigger: "blur" }],
      },
    };
  },

  methods: {
    bc(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          let j = 0;
          j++;
          const s = {
            create_by: localStorage.getItem("name"),
            inbll_date: this.formInline.sr_date,
            ware_name: this.formInline.ckmc,
            inbill_bh: this.formInline.sr_code,
            inbill_duty_man: this.formInline.jbr,
            remark: this.formInline.bz,
          };

          var i = 0;
          this.tableData = this.tableData.map((item) => {
            i++;
            return {
              ...item,
              user: localStorage.getItem("name"),
            };
          });
          // console.log(this.tableData);
          // console.log(this.formInline);
          const jsonString = JSON.stringify(this.tableData);
          const jsonString1 = JSON.stringify(s);
          console.log(jsonString);
          console.log(jsonString1);
          $http
            .get(
              "http://localhost:5149/api/Wh_sale_return_h/Wh_sale_return_h_sale_inser",
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
                  message: "添加成功!",
                  type: "success",
                });
                this.$router.push("/Wh_inbill_h");
              }
            })
            .catch((err) => {
              console.log(err);
            });
        }
      });
    },
    cang() {
      var t = this;
      $http
        .post(
          "http://localhost:5149/api/Wh_inbill_h/Bs_ware_areaName?bh=" +
            this.formInline.ckmc
        )
        .then((res) => {
          t.countryList1 = res;
        })
        .catch((err) => {
          alert(err);
        });
    },
    gong() {
      $http
        .get(
          "http://localhost:5149/api/Wh_inbill_h/Bs_supplyName?name=" +
            this.formInline.gys
        )
        .then((res) => {
          this.formInline.lxr = res.link_man;
          this.formInline.fs = res.link_tel;
        })
        .catch((err) => {
          alert(err);
        });
    },
    zt(i) {
      if (i == 0) return "草稿";
      if (i == 1) return "待审核";
      if (i == 2) return "驳回";
      if (i == 3) return "已完成";
    },
    //选择单号
    find() {
      $http
        .post(
          "http://localhost:5149/api/Wh_inbill_h/FenOrder?page=" +
            this.pagesize +
            "&pageSize=" +
            this.currentPage +
            "&str=" +
            this.str
        )
        .then((res) => {
          this.gridData = res.list;
          this.rows1 = res.rows;
        })
        .catch((err) => {
          alert(err);
        });
    },
    //进货查询
    onSubmit() {
      this.str = "1=1 and is_del=0 and sale_state=2 or sale_state=3 ";
      if (this.formtable.dh != "") {
        this.str += "and buy_code like '%" + this.formtable.dh + "%'";
      }
      if (this.formtable.zt != "") {
        this.str += "and sale_state like '%" + this.formtable.zt + "%'";
      }
      if (this.formtable.gys != "") {
        this.str += "and supply_code ='" + this.formtable.gys + "'";
      }

      if (this.formtable.date != "" && this.formtable.date != null) {
        const yearMonthDay = this.formtable.date.substring(0, 10);
        this.str +=
          "and convert(varchar(50),buy_date,120) LIKE  '" + yearMonthDay + "%'";
      }
      if (this.formtable.jhr != "") {
        this.str += "and buy_man = '" + this.formtable.jhr + "'";
      }

      this.find();
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
      $http
        .get("http://localhost:5149/api/Bs_warehouse/Bs_warehouseSelect")
        .then((res) => {
          t.countryList = res;
        })
        .catch((err) => {
          alert(err);
        });
      $http
        .get("http://localhost:5149/api/Wh_inbill_h/FindUser")
        .then((res) => {
          t.countryList2 = res;
        })
        .catch((err) => {
          alert(err);
        });
      $http
        .get("http://localhost:5149/api/Wh_inbill_h/Bs_supplyFind")
        .then((res) => {
          t.countryList3 = res;
        })
        .catch((err) => {
          alert(err);
        });
    },
    //选择单号
    xz() {
      this.dialogFormVisible = true;

      this.find();
    },
    filterTime(timestamp) {
      return formatDate(timestamp);
    },

    //添加
    bcc() {
      this.dialogFormVisible1 = true;
      this.formtable1 = {
        bh: "",
        dw: "",
      };
    },
    //明细
    find1() {
      var t = this;
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
      if (this.kj == true) {
        //未入库数量
        var weiSum = document.getElementById("xsSum" + i);

        if (Number(numberSum.value) > Number(weiSum.innerHTML)) {
          this.$message({
            showClose: true,
            message: "数量填写错误",
            type: "error",
          });
          numberSum.value = "0";
          document.getElementById("totalsum" + i).innerHTML = "0";
        }
      }

      var sum = 0;
      var sum1 = 0;
      var sum2 = 0;
      for (var j = 1; j <= this.tableData.length; j++) {
        var numberSum = document.getElementById("numberSum" + j).value;
        var saleSum = document.getElementById("saleSum" + j).value;

        var totalsum = document.getElementById("totalsum" + j).innerHTML;
        if (totalsum == "") {
          totalsum = "0";
        }
        sum2 = Number(sum2) + Number(totalsum);
        if (numberSum == "") {
          numberSum = "0";
        }
        sum = Number(sum) + Number(numberSum);
        if (saleSum == "") {
          saleSum = "0";
        }
        sum1 = Number(sum1) + Number(saleSum);
      }
      document.getElementById("sumNumber").innerHTML = sum;
      document.getElementById("sumSalary").innerHTML = sum2;
    },
    //添加单号的确定
    que() {
      this.dialogFormVisible = false;
      this.ff = false;
      this.ff1 = true;

      this.formInline.gldh = "";
      this.formInline.gys = "";
      this.formInline.lxr = "";
      this.formInline.fs = "";
      this.tableData = [];
      this.rows = 0;
    },
    handleRowClick(i) {
      this.formInline.gldh = i.buy_code;
      this.formInline.gys = i.supply_code;

      this.dialogFormVisible = false;
      this.ff = true;
      $http
        .get(
          "http://localhost:5149/api/Wh_inbill_h/Bs_supplyName?name=" +
            i.supply_code
        )
        .then((res) => {
          this.formInline.lxr = res.link_man;
          this.formInline.fs = res.link_tel;
        })
        .catch((err) => {
          alert(err);
        });

      var t = this;
      t.str2 = "buy_code='" + i.buy_code + "'";

      $http
        .post(
          "http://localhost:5149/api/Wh_inbill_h/Wh_orderbuy_dBH?page=" +
            t.pagesize1 +
            "&pageSize=" +
            t.currentPage1 +
            "&str=" +
            t.str2
        )
        .then((res) => {
          t.tableData = res.list;
          t.rows = res.rows;
        })
        .catch((err) => {
          alert(err);
        });
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

    //每页显示数改变事件 选择单号
    handleSizeChange1(size) {
      this.pagesize = size;
      this.currentPage = 1;
      this.find();
    },
    //页码改变事件 选择单号
    handleCurrentChange1(page) {
      this.currentPage = page;
      this.find();
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
      this.kj = false;

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
    findjb() {
      $http
        .get(
          "http://localhost:5149/api/Wh_sale_return_h/Wh_sale_return_h_CodeAsyunc?sr_code=" +
            this.$route.query.sr_code +
            ""
        )
        .then((res) => {
          this.formInline.sr_code = res.sr_code;
          this.formInline.link_man = res.link_man;
          this.formInline.link_way = res.link_way;
          this.formInline.cust_code = res.cust_code;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    findmx() {
      $http
        .get(
          "http://localhost:5149/api/Wh_sale_return_h/Wh_sale_return_h__srlAsyunc?sr_code=" +
            this.$route.query.sr_code +
            ""
        )
        .then((res) => {
          this.tableData = res;
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
  mounted() {
    this.CK();
    this.find1();
    this.findjb();
    this.findmx();
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

#adds {
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 500px;
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