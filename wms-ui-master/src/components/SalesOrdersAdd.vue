<template>
  <div>
    <el-input
      v-model="formInline.create_by"
      type="hidden"
      placeholder="制单人"
    ></el-input>
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
          ref="ruleForm"
          class="demo-form-inline"
        >
          <el-form-item label="销售单号" id="yyy" prop="sale_code">
            <el-input
              v-model="formInline.sale_code"
              id="tex"
              readonly
              placeholder="销售单号"
            ></el-input>
          </el-form-item>
          <el-form-item label="联系方式" id="yyy">
            <el-input
              disabled
              v-model="formInline.link_way"
              id="tex"
              placeholder="联系方式"
            ></el-input>
          </el-form-item>
          <el-form-item label="客户名称" id="yyy" prop="cust_code">
            <el-select
              v-model="formInline.cust_code"
              @change="XLKhandleSelectChange()"
              id="tex"
              clearable
              filterable
              placeholder="客户名称"
            >
              <el-option
                v-for="item in list1"
                :key="item.customer_id"
                :label="item.cust_name"
                :value="item.cust_name"
              ></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="销售日期" id="yyy" prop="sale_date">
            <el-date-picker
              v-model="formInline.sale_date"
              type="datetime"
              id="tex"
              placeholder="选择销售时间"
              value-format="yyyy-MM-dd HH:mm:ss"
            >
            </el-date-picker>
          </el-form-item>
          <el-form-item label="联系人" id="yyy">
            <el-input
              disabled
              v-model="formInline.link_man"
              id="tex"
              placeholder="联系人"
            ></el-input>
          </el-form-item>
          <el-form-item label="销售负责人" id="yyy">
            <el-select
              v-model="formInline.sale_duty_man"
              clearable
              filterable
              id="tex"
              placeholder="销售负责人"
            >
              <el-option
                v-for="item in list"
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
              placeholder="备注"
              v-model="formInline.remark"
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
        <h4 style="margin-left: 25px">销售货品明细</h4>
      </div>
      <div style="margin-top: 50px; margin-left: 30px">
        <el-button id="bcc" @click="bcc()">添加</el-button>
        <el-button
          id="yichuchu"
          @click="sc()"
          icon="el-icon-delete"
          :disabled="multipleSelection.length == 0"
          >移除</el-button
        >
        <el-table
          height="300"
          tooltip-effect="dark"
          @selection-change="handleSelectionChange"
          :data="tableData"
          :header-cell-style="{
            background: '#F8F8F9',
            color: '#606266',
            'text-align': 'center',
          }"
          :cell-style="{ 'text-align': 'center' }"
          id="ttt"
        >
          <el-table-column type="selection" width="55"> </el-table-column>
          <el-table-column label="序号" type="index" width="50">
          </el-table-column>
          <el-table-column prop="item_name" label="货品名称" width="80">
          </el-table-column>
          <el-table-column prop="item_code" label="货品编号" width="90">
          </el-table-column>
          <el-table-column prop="model_code" label="规格型号" width="80">
          </el-table-column>
          <el-table-column prop="unit" label="单位" width="115px">
            <!-- <template slot-scope="scope">
              <select
                v-model="scope.row.unit"
                style="width: 90px; height: 25px; border: 1px solid #eeeeee"
              >
                <option selected="selected" value="">请选择</option>
                <option label="箱" value="箱"></option>
                <option label="瓶" value="瓶"></option>
                x
              </select>
            </template> -->
          </el-table-column>
          <el-table-column prop="item_type_name" label="货品类型" width="80">
          </el-table-column>
          <el-table-column label="当前库存" width="90">
            <template slot-scope="scope">
              <span :id="'yiSum' + (scope.$index + 1)">{{ scope.row.kc }}</span>
            </template>
          </el-table-column>
          <el-table-column label="货品数量" width="115px">
            <template slot-scope="scope">
              <input
                type="text"
                style="
                  width: 80px;
                  padding-left: 5px;
                  height: 25px;
                  border: 1px solid #eeeeee;
                "
                placeholder="货品数量"
                name="grantDetails[0].numberSum"
                :id="'numberSum' + (scope.$index + 1)"
                v-on:keyup="onKeyPress(scope.$index + 1)"
                value="0"
              />
            </template>
          </el-table-column>
          <el-table-column label="销售单价" width="115px">
            <template slot-scope="scope">
              <input
                type="text"
                style="width: 80px; height: 25px; border: 1px solid #eeeeee"
                placeholder="销售单价"
                name="grantDetails[0].saleSum"
                :id="'saleSum' + (scope.$index + 1)"
                v-on:keyup="onKeyPress(scope.$index + 1)"
                :value="scope.row.inbill_price"
              />
            </template>
          </el-table-column>
          <el-table-column label="销售金额" width="85">
            <template slot-scope="scope">
              <i style="color: red" :id="'totalsum' + (scope.$index + 1)"></i>
            </template>
          </el-table-column>
          <el-table-column prop="create_by" label="备注" width="124px">
            <template slot-scope="scope">
              <input
                :id="'remark' + (scope.$index + 1)"
                type="text"
                style="width: 90px; height: 25px; border: 1px solid #eeeeee"
                placeholder="备注"
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
            <span style="line-height: 45px; font-size: 14px">货品数量：</span>
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
        <!-- 添加 -->
        <el-dialog
          title="添加货品"
          :visible.sync="dialogFormVisible"
          width="800px"
          id="tjsh"
        >
          <el-form :inline="true" :model="formtable" class="demo-form-inline">
            <el-form-item label="">
              <el-input
                v-model="formtable.bh"
                id="bddd"
                placeholder="请输入货品编号/名称"
              ></el-input>
            </el-form-item>
            <el-form-item label="" style="margin-left: 30px">
              <el-select
                v-model="formtable.dw"
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
            ref="tablee"
            :data="gridData"
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
            <el-table-column
              property="kc"
              label="当前库存"
              width="100"
            ></el-table-column>
          </el-table>
          <el-pagination
            id="fenye"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="currentPage"
            :page-sizes="[4, 8, 12, 16]"
            :page-size="pagesize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="rows"
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
      </div>
    </div>

    <div id="notification-container">
      <div id="dibu">
        <el-button id="gb" @click="gb()">关闭</el-button>
        <el-button id="bc" @click="bc('ruleForm')">保存</el-button>
      </div>
    </div>
  </div>
</template>

<script>
import $http from "../http/base.js";
var str = "1=1";
export default {
  data() {
    return {
      dwwww: "",
      list: [],
      list1: [],
      dialogFormVisible: false,
      formLabelWidth: "150px",
      dialogVisible: true,
      formtable: {
        bh: "",
        dw: "",
      },
      multipleSelection: [], // 选中的行数据
      multipleSelection1: [], // 选中的行数据
      multipleSelectAry: [],
      currentPage: 1, //当前页
      pagesize: 4, //每页显示数
      rows: 0, //总行数
      tableData: [],
      gridData: [],
      formInline: {
        sale_code: "",
        link_way: "",
        cust_code: "",
        sale_date: "",
        link_man: "",
        sale_duty_man: "",
        remark: "",
        create_by: localStorage.getItem("name"),
      },
      rules: {
        sale_code: [
          { required: true, message: "请填写单号!", trigger: "blur" },
        ],
        cust_code: [
          { required: true, message: "请填写客户!", trigger: "change" },
        ],
        sale_date: [
          { required: true, message: "请填写日期!", trigger: "blur" },
        ],
      },
    };
  },
  methods: {
    //保存
    bc(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          var i = 0;
          this.tableData = this.tableData.map((item) => {
            i++;
            return {
              ...item,
              sale_price: document.getElementById("saleSum" + i).value,
              remark: document.getElementById("remark" + i).value,
              inbill3_num: document.getElementById("numberSum" + i).value,
            };
          });

          const jsonString = JSON.stringify(this.tableData);
          const jsonString1 = JSON.stringify(this.formInline);
          console.log(jsonString);
          console.log(jsonString1);
          $http
            .get("http://localhost:5149/api/Wh_sale_h/Wh_sale_h_Insert", {
              params: {
                json: jsonString,
                xx: jsonString1,
              },
            })
            .then((res) => {
              if (res) {
                this.$message({
                  message: "添加成功!",
                  type: "success",
                });
                this.$router.go(-1);
              }
            })
            .catch((err) => {
              console.log(err);
            });
        }
      });
    },
    //金额改变事件
    onKeyPress(i) {
      //数量
      var numberSum = document.getElementById("numberSum" + i);
      //单价
      var saleSum = document.getElementById("saleSum" + i);
      //金额
      document.getElementById("totalsum" + i).innerHTML =
        document.getElementById("numberSum" + i).value *
        document.getElementById("saleSum" + i).value;
      if (isNaN(numberSum.value) || numberSum.value < 0) {
        this.$message({
          showClose: true,
          message: "数量填写错误",
          type: "error",
        });
        numberSum.value = "0";
        return;
      }
      if (isNaN(saleSum.value) || saleSum.value < 0) {
        this.$message({
          showClose: true,
          message: "金额填写错误",
          type: "error",
        });
        saleSum.value = "0.00";
        return;
      }

      //进货数量
      var slSum = document.getElementById("yiSum" + i);

      if (Number(numberSum.value) > Number(slSum.innerHTML)) {
        this.$message({
          showClose: true,
          message: "退货数量不能大于进货数量",
          type: "error",
        });
        numberSum.value = "0";
        document.getElementById("totalsum" + i).value = "0";
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
    //下拉框选中
    XLKhandleSelectChange(supid) {
      supid = this.formInline.cust_code;
      if (supid == "") {
        this.formInline.link_way = "";
        this.formInline.link_man = "";
        return;
      } else {
        $http
          .get(
            "http://localhost:5149/api/Wh_sale_h/Wh_sale_hNameAsyunc?cust_name=" +
              supid +
              ""
          )
          .then((res) => {
            this.formInline.link_way = res.link_tel;
            this.formInline.link_man = res.link_man;
          });
      }
    },
    //取消
    qqxx() {
      this.$refs.tablee.clearSelection();
      this.dialogFormVisible = false;
    },
    //确认
    qd() {
      try {
        const newData = this.multipleSelection1.map((item) => ({
          ...item,
        }));
        this.tableData = this.tableData.concat(newData);
      } catch (err) {
        console.error(err);
      }
      this.dialogFormVisible = false;
    },
    //重置
    cz() {
      this.formtable = {
        bh: "",
        dw: "",
      };
    },
    //查询
    onSubmit() {
      str = "1=1 ";
      if (this.formtable.bh != "") {
        str +=
          "and item_name like '%" +
          this.formtable.bh +
          "%' or  item_code like '%" +
          this.formtable.bh +
          "%' ";
      }
      if (this.formtable.dw != "") {
        str += "and unit = '" + this.formtable.dw + "'";
      }
      this.find();
    },
    //添加
    bcc() {
      this.dialogFormVisible = true;
    },
    //关闭
    gb() {
      this.$router.go(-1);
    },
    //删除
    sc() {
      this.multipleSelection.forEach((row) => {
        let index = this.tableData.indexOf(row);
        if (index !== -1) {
          this.tableData.splice(index, 1);
        }
      });
      for (var j = 1; j <= this.tableData.length; j++) {
        document.getElementById("numberSum" + j).value = 0;
        document.getElementById("totalsum" + j).innerHTML = "";
      }
      document.getElementById("sumNumber").innerHTML = 0.0;
      document.getElementById("sumSalary").innerHTML = 0.0;
      this.$notify({
        title: "成功",
        message: "销售货品移除成功!",
        type: "success",
      });
    },
    // handleEdit() {
    //     alert("!@3");
    // },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    //选择-添加
    handleSelectionChange1(val) {
      this.multipleSelection1 = val;
      console.log(this.multipleSelection1);
    },
    //货品信息查询
    find() {
      var t = this;
      $http
        .get("http://localhost:5149/api/Wh_sale_h/Wh_sale_hGoodsFenYe", {
          params: {
            pageSize: t.pagesize,
            currentPage: t.currentPage,
            str,
          },
        })
        .then((res) => {
          console.log(res);
          t.gridData = res.list;
          t.rows = res.rows;
        })
        .catch((err) => {
          console.log(err);
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
    //查询用户
    fond() {
      $http
        .get("http://localhost:5149/api/Wh_buy_order_h/UserFind")
        .then((res) => {
          this.list = res;
        });
    },
    //查询供应商
    fondgys() {
      $http
        .get("http://localhost:5149/api/Wh_sale_h/Wh_sale_hYHAsyunc")
        .then((res) => {
          this.list1 = res;
        });
    },
    Dang() {
      $http
        .get("http://localhost:5149/api/Sys_encode/FindSys_encodeById?id=" + 16)
        .then((res) => {
          this.formInline.sale_code = res;
        })
        .catch((err) => {
          alert(err);
        });
    },
  },
  mounted() {
    this.formInline.create_by = localStorage.getItem("name");
    this.fond();
    this.fondgys();
    this.find();
    this.Dang();
  },
};
</script>

<style>
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
#bddd {
  height: 32px;
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

.el-table {
  border: 1px solid #eeeeee;
}
#bb {
  width: 130px !important;
}
#ttt {
  width: 1080px !important;
}
#te {
  width: 920px;
}
#yyy {
  margin-left: 50px;
  margin-top: 5px;
}
#yyyy {
  margin-left: 82px;
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
  z-index: 999;
}
#adds {
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
  height: 550px;
}
#fenye1 {
  text-align: center;
  margin-top: 20px;
}
</style>