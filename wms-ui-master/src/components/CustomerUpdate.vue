<template>
  <div>
    <el-input
      v-model="formInline.create_by"
      type="hidden"
      placeholder="制单人"
    ></el-input>
    <div id="addsss">
      <div
        style="
          height: 170;
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
          ref="ruleForm1"
          class="demo-form-inline"
        >
          <el-form-item label="客户编码" id="yyy" prop="cust_code">
            <el-input
              v-model="formInline.cust_code"
              id="tex"
              placeholder="自动获取系统编号"
              readonly
            ></el-input>
          </el-form-item>
          <el-form-item label="客户名称" id="yyy" prop="cust_name">
            <el-input
              v-model="formInline.cust_name"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="电子邮箱" id="yyy">
            <el-input
              v-model="formInline.e_mail"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="客户来源" id="yyy">
            <el-select
              v-model="formInline.cust_from"
              id="tex"
              placeholder="请输入"
            >
              <el-option
                v-for="item in List2"
                :key="item.cust_from"
                :label="item.cust_from"
                :value="item.cust_from"
              ></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="销售负责人" id="yyy">
            <el-select
              v-model="formInline.head_of_Sales"
              id="tex"
              placeholder="请输入"
            >
              <el-option
                v-for="item in List"
                :key="item.u_id"
                :label="item.u_True_name"
                :value="item.u_True_name"
              ></el-option>
            </el-select>
          </el-form-item>

          <el-form-item label="联系电话" id="yyy">
            <el-input
              v-model="formInline.link_tel"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="客户地址" id="yyy">
            <el-input
              v-model="formInline.cust_adr"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>

          <el-form-item label="联系人" id="yyy">
            <el-input
              v-model="formInline.link_man"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="状态" :label-width="formLabelWidth">
            <el-radio v-model="radio" label="0">启用</el-radio>
            <el-radio v-model="radio" label="1">停用</el-radio>
          </el-form-item>
          <el-form-item label="所属行业" id="yyy">
            <el-select
              v-model="formInline.line_type"
              id="tex"
              placeholder="请输入"
            >
              <el-option
                v-for="item in List1"
                :key="item.line_type"
                :label="item.line_type"
                :value="item.line_type"
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
        <h4 style="margin-left: 25px">财务信息</h4>
      </div>
      <div style="margin-top: 30px">
        <el-form
          :inline="true"
          :model="formInline1"
          :rules="rules"
          ref="ruleForm"
          class="demo-form-inline"
        >
          <el-form-item label="账户名称" id="yyy">
            <el-input
              v-model="formInline1.finance_name"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="纳税人识别号" id="yyy">
            <el-input
              v-model="formInline1.tax_no"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="银行账户" id="yyy">
            <el-input
              v-model="formInline1.bank_no"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="开户银行" id="yyy">
            <el-input
              v-model="formInline1.open_bank"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="开户行地址" id="yyyy">
            <el-input
              id="te"
              type="textarea"
              placeholder="请输入"
              v-model="formInline1.open_adr"
              maxlength="100"
              :rows="5"
              show-word-limit
            >
            </el-input>
          </el-form-item>
        </el-form>
      </div>
    </div>

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
var str = "1=1 and is_del=0";
export default {
  data() {
    return {
      List1: [],
      List: [],
      List2: [],
      formLabelWidth: "150px",
      formtable: {
        bh: "",
        dw: "",
      },
      radio: "0",
      tableData: [],
      formInline: {
        cust_code: "",
        cust_name: "",
        e_mail: "",
        cust_from: "",
        cust_adr: "",
        head_of_Sales: "",
        line_type: "",
        link_man: "",
        link_tel: "",
        remark: "",
      },
      formInline1: {
        finance_name: "",
        tax_no: "",
        bank_no: "",
        open_bank: "",
        open_adr: "",
      },
      rules: {
        cust_code: [
          { required: true, message: "请填写客户编码!", trigger: "blur" },
        ],
        cust_name: [
          { required: true, message: "请填写客户名称!", trigger: "change" },
        ],
      },
    };
  },
  methods: {
    //保存
    bc() {
      this.$refs["ruleForm1"].validate((valid) => {
        if (!valid) return;
        var t = this;
        var id = this.$route.query.id;
        var uu = localStorage.getItem("name");
        $http
          .put(
            "http://localhost:5149/api/CustomerView/CustomerUpdate?code=" +
              t.formInline.cust_code +
              "&name=" +
              t.formInline.cust_name +
              "&type=" +
              t.formInline.line_type +
              "&from=" +
              t.formInline.cust_from +
              "&man=" +
              t.formInline.link_man +
              "&tel=" +
              t.formInline.link_tel +
              "&yx=" +
              t.formInline.e_mail +
              "&fz=" +
              t.formInline.head_of_Sales +
              "&zt=" +
              t.radio +
              "&adr=" +
              t.formInline.cust_adr +
              "&cz=" +
              uu +
              "&bz=" +
              t.formInline.remark +
              "&id=" +
              id +
              "",
            {}
          )
          .then((res) => {
            if (res) {
              $http
                .put(
                  "http://localhost:5149/api/CustomerView/FinanceUpdate?id=" +
                    id,
                  {
                    finance_name: t.formInline1.finance_name,
                    tax_no: t.formInline1.tax_no,
                    bank_no: t.formInline1.bank_no,
                    open_bank: t.formInline1.open_bank,
                    open_adr: t.formInline1.open_adr,
                    finance_type: "",
                  }
                )
                .then((res) => {
                  if (res) {
                    this.$router.go(-1);
                    this.$message({
                      message: "修改成功！",
                      type: "success",
                    });
                  }
                })
                .catch((err) => {
                  alert(err);
                });
            }
          })
          .catch((err) => {
            console.log(err);
          });
      });
    },
    yh() {},
    //关闭
    gb() {
      this.$router.go(-1);
    },
    fzr() {
      $http
        .post("http://localhost:5149/api/SupplyView/Czr")
        .then((res) => {
          this.List = res;
          console.log(res);
        })
        .catch((err) => {
          alert(err);
        });
    },
    ly() {
      $http
        .post("http://localhost:5149/api/CustomerView/LY")
        .then((res) => {
          this.List2 = res;
          console.log(res);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    hy() {
      $http
        .post("http://localhost:5149/api/CustomerView/HY")
        .then((res) => {
          this.List1 = res;
        })
        .catch((err) => {
          alert(err);
        });
    },
    fill() {
      var t = this;
      var id = t.$route.query.id;
      $http
        .get("http://localhost:5149/api/CustomerView/SelectID?id=" + id)
        .then((res) => {
          t.formInline.cust_code = res.cust_code;
          t.formInline.cust_name = res.cust_name;
          t.formInline.link_man = res.link_man;
          t.formInline.link_tel = res.link_tel;
          t.formInline.e_mail = res.e_mail;
          t.formInline.cust_adr = res.cust_adr;
          t.radio = res.inbill_state;
          t.formInline.cust_from = res.cust_from;
          t.formInline.remark = res.remark;
          t.formInline.line_type = res.line_type;
          t.formInline.head_of_Sales = res.head_of_Sales;
          t.formInline1.finance_name = res.finance_name;
          t.formInline1.tax_no = res.tax_no;
          t.formInline1.bank_no = res.bank_no;
          t.formInline1.open_bank = res.open_bank;
          t.formInline1.open_adr = res.open_adr;
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
  mounted() {
    this.formInline.create_by = localStorage.getItem("name");
    this.fill();
    this.fzr();
    this.hy();
    this.ly();
  },
};
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

#addsss {
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 520px;
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