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
          <el-form-item label="货品名称" id="yyy" prop="name">
            <el-input
              v-model="formInline.name"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>

          <el-form-item label="货品编号" id="yyy" prop="dh">
            <el-input
              v-model="formInline.dh"
              id="tex"
              placeholder="自动获取系统编号"
              :readonly="true"
            ></el-input>
          </el-form-item>

          <el-form-item label="货品类型" id="yyy">
            <el-cascader
              :options="options"
              v-model="formInline.item_type"
              :props="{ checkStrictly: true }"
              @change="handleChange"
              clearable
            ></el-cascader>
          </el-form-item>

          <el-form-item label="规格型号" id="yyy" prop="ggxh">
            <el-input
              v-model="formInline.ggxh"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="单位" id="yyy" prop="unit">
            <el-select v-model="formInline.unit">
              <el-option value="瓶">瓶</el-option>
              <el-option value="个">个</el-option>
              <el-option value="件">件</el-option>
              <el-option value="台">台</el-option>
              <el-option value="支">支</el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="入库参考价/元" id="yyy" prop="rk">
            <el-input
              v-model="formInline.rk"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>

          <el-form-item label="出库参考价/元" id="yyy" prop="ck">
            <el-input
              v-model="formInline.ck"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>

          <el-form-item label="显示顺序" id="yyy" prop="sx">
            <el-input
              v-model="formInline.sx"
              id="tex"
              placeholder="请输入"
            ></el-input>
          </el-form-item>

          <el-form-item label="状态" id="yyy">
            <el-radio-group v-model="formInline.zt" style="margin-bottom: 0">
              <el-radio label="0">正常</el-radio>
              <el-radio label="1">停用</el-radio>
            </el-radio-group>
          </el-form-item>

          <!-- <el-form-item label="入库日期" prop="date" id="ru">
                        <el-date-picker v-model="formInline.date" id="tex" type="datetime" placeholder="选择日期时间"
                            value-format="yyyy-MM-dd HH:mm:ss">
                        </el-date-picker>
                    </el-form-item> -->
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
    <div id="addxgood">
      <div
        style="
          height: 60;
          line-height: 60px;
          box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
          background-color: #fff;
        "
      >
        <h4 style="margin-left: 25px">编辑照片</h4>
        <el-upload
          style="margin-left: 20px"
          ref="myfile"
          action="http://localhost:5149/api/FileUpload/UploadFile/Upload"
          list-type="picture-card"
          :on-success="onSuccess"
          :auto-upload="true"
        >
          <i slot="default" class="el-icon-plus"></i>
          <div slot="file" slot-scope="{ file }">
            <img
              class="el-upload-list__item-thumbnail"
              :src="file.url"
              alt=""
            />
            <span class="el-upload-list__item-actions">
              <span
                class="el-upload-list__item-preview"
                @click="handlePictureCardPreview(file)"
              >
                <i class="el-icon-zoom-in"></i>
              </span>
              <span
                v-if="!disabled"
                class="el-upload-list__item-delete"
                @click="handleDownload(file)"
              >
                <i class="el-icon-download"></i>
              </span>
              <span
                v-if="!disabled"
                class="el-upload-list__item-delete"
                @click="handleRemove(file)"
              >
                <i class="el-icon-delete"></i>
              </span>
            </span>
          </div>
        </el-upload>
        <el-dialog :visible.sync="dialogVisible">
          <img width="100%" :src="dialogImageUrl" alt="" />
        </el-dialog>
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
export default {
  data() {
    return {
      kj: true,
      tp: [],
      str: "is_del=0 and 1=1 and sale_state=2 or sale_state=3",
      str1: "1=1",
      str2: "1=1",
      dialogImageUrl: "",

      disabled: false,
      dialogVisible: false,
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
      options: [],
      value: [],
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
        dh: "",
        dh: "",
        ggxh: "",
        lx: "",
        mc: "",
        name: "",
        date: "",
        bei: "",
        rk: "",
        ck: "",
        zt: "0",
        unit: "",
        item_type_code: "",
        item_type: "",
      },
      element: [],
      iid: "",
      rules: {
        name: [{ required: true, message: "请输入货品名称!", trigger: "blur" }],
        dh: [{ required: true, message: "请输入货品编号!", trigger: "blur" }],
        ggxh: [
          { required: true, message: "请输入规格型号!", trigger: "change" },
        ],
        zt: [{ required: true, message: "请选择状态!", trigger: "change" }],
        rk: [{ required: true, message: "请输入入库价格!", trigger: "change" }],
        unit: [
          { required: true, message: "请输入商品单位!", trigger: "change" },
        ],
        ck: [{ required: true, message: "请输入出库价格!", trigger: "change" }],
        sx: [{ required: true, message: "请选择顺序!", trigger: "change" }],
      },
    };
  },

  methods: {
    select() {
      // $http
      //   .get("http://localhost:5149/api/Bs_itemType/fatherGoodsFind")
      //   .then((res) => {
      //     console.log(res);
      //     this.options = res;
      //   });
      $http
        .get("http://localhost:5149/api/Sys_encode/FindSys_encodeById?id=1")
        .then((res) => {
          this.formInline.dh = res;
        });
    },
    cascader() {
      $http
        .get("http://localhost:5149/api/Sys_encode/GetItems?father_code=0")
        .then((res) => {
          console.log(res);
          this.menuItems = res;
          this.options = this.transformMenuItems(this.menuItems);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    transformMenuItems(menuItems) {
      //级联方法
      const op = [];
      for (const item of menuItems) {
        const option = {
          value: item.item_type_code,
          label: item.item_type_name,
        };
        if (item.children && item.children.length > 0) {
          option.children = this.transformMenuItems(item.children);
        }
        op.push(option);
      }
      return op;
    },

    onSuccess(response, file, fileList) {
      console.log(fileList);
      // alert(response);
      for (let i = 0; i < fileList.length; i++) {
        this.element[i] = fileList[i].name;
      }
      this.tp = this.element;
      console.log(this.element);
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
      // $http
      //     .get("http://localhost:5149/api/Bs_warehouse/Bs_warehouseSelect")
      //     .then(res => {
      //         t.countryList = res;
      //     })
      //     .catch(err => {
      //         alert(err);
      //     });
      // $http
      //     .get("http://localhost:5149/api/Wh_inbill_h/FindUser")
      //     .then(res => {
      //         t.countryList2 = res;

      //     })
      //     .catch(err => {
      //         alert(err);
      //     });
      // $http
      //     .get("http://localhost:5149/api/Wh_inbill_h/Bs_supplyFind")
      //     .then(res => {
      //         t.countryList3 = res;
      //     })
      //     .catch(err => {
      //         alert(err);
      //     });
    },
    //选择单号
    xz() {
      this.dialogFormVisible = true;

      this.find();
    },
    filterTime(timestamp) {
      return formatDate(timestamp);
    },
    //保存
    bc() {
      // var ppid = 0;
      // // console.log(this.value);
      // if (this.formInline.type == "") {
      //   this.$notify({
      //     title: "提示",
      //     message: "请输入货品类型",
      //     type: "warning",
      //   });
      //   return false;
      // }
      // if (this.value.length > 0) {
      //   ppid = parseInt(this.value[this.value.length - 1]);
      // }
      var sc;
      if (this.formInline.item_type && this.formInline.item_type.length > 0) {
        // Set to the last selected value (assuming checkStrictly is true)
        sc = this.formInline.item_type[this.formInline.item_type.length - 1];
      } else {
        // Nothing selected, set to default value (e.g., "0")
        sc = "0";
      }
      console.log(sc);
      var name = localStorage.getItem("b");
      this.$refs.formInline1.validate((valid) => {
        if (valid) {
          $http
            .post(
              "http://localhost:5149/api/Bs_item/AddGoodsInfo?item_name=" +
                this.formInline.name +
                "&item_code=" +
                this.formInline.dh +
                "&item_type=" +
                sc +
                "&model_code=" +
                this.formInline.ggxh +
                "&inbill_price=" +
                this.formInline.rk +
                "&outbill_price=" +
                this.formInline.ck +
                "&sort_code=" +
                this.formInline.sx +
                "&inbill_state=" +
                this.formInline.zt +
                "&create_by=" +
                name +
                "&remark=" +
                this.formInline.bei +
                "&unit=" +
                this.formInline.unit +
                "&item_type_code=" +
                sc +
                "&ImgUrl=" +
                this.tp +
                ""
            )
            .then((res) => {
              if (res) {
                this.$notify({
                  title: "成功",
                  message: "货品添加成功",
                  type: "success",
                });
                this.$router.push("/GoodsMessage");
              }
            });
        }
      });
      // $http
      //   .get(
      //     "http://localhost:5149/api/Bs_item/FindGoodsInfoById?id=" + sc + ""
      //   )
      //   .then((res) => {
      //     console.log(res);
      //     this.iid = res.item_type_code;

      //   });
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
        var weiSum = document.getElementById("weiSum" + i);

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
    handleRemove(file) {
      const index = this.$refs.myfile.uploadFiles.indexOf(file);
      this.$refs.myfile.uploadFiles.splice(index, 1);
      if (this.dialogVisible && this.dialogImageUrl === file.url) {
        this.dialogVisible = false;
        this.dialogImageUrl = "";
      }
    },
    handlePictureCardPreview(file) {
      this.dialogImageUrl = file.url;
      this.dialogVisible = true;
    },
    handleDownload(file) {
      console.log(file);
      // 创建一个a标签
      const link = document.createElement("a");
      // 设置a标签的href为文件的url
      link.href = file.url;
      // 设置a标签的下载属性为文件名
      link.download = file.name;
      // 将a标签添加到页面中
      document.body.appendChild(link);
      // 触发a标签的点击事件，开始下载
      link.click();
      // 下载完成后移除a标签
      document.body.removeChild(link);
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
    handleChange(value) {
      console.log(value);
    },
  },
  mounted() {
    this.cascader();
    this.CK();
    this.find1();
    this.select();
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

<style>
.el-upload-list--picture-card .el-upload-list__item-thumbnail {
  width: 100%;
  height: 147px !important;
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

#adds {
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 500px;
}

#addxgood {
  margin-top: 20px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 255px;
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