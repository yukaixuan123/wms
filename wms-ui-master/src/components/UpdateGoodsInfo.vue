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
        <h4 style="margin-left: 25px">编辑货品</h4>
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

          <el-form-item label="货品编号" id="yyy" prop="item_code">
            <el-input
              v-model="formInline.item_code"
              id="tex"
              placeholder="自动获取系统编号"
              :readonly="true"
            ></el-input>
          </el-form-item>
          <el-form-item label="货品类型" id="yyy">
            <el-cascader
              :options="menuOptions"
              v-model="hplx"
              :props="{
                value: 'value',
                label: 'label',
                children: 'children',
                checkStrictly: true,
              }"
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

          <el-form-item label="状态" id="yyy" prop="zt">
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
    <div id="addxinfo">
      <div
        style="
          height: 60;
          line-height: 60px;
          box-shadow: 0px -1px 7px rgba(0, 0, 0, 0.2);
          background-color: #fff;
        "
      >
        <h4 style="margin-left: 25px">编辑图片</h4>
      </div>

      <div class="block" v-if="tutu">
        <el-carousel trigger="click" height="250px">
          <el-carousel-item
            v-for="item in Imager"
            :key="item"
            style="border-radius: 10px"
          >
            <img :src="item" width="230px" height="230px" />
          </el-carousel-item>
        </el-carousel>
      </div>
      <el-upload
        style="margin-left: 20px; margin-top: 20px"
        ref="myfile"
        action="http://localhost:5149/api/FileUpload/UploadFile/Upload"
        list-type="picture-card"
        :on-success="onSuccess"
        :auto-upload="true"
      >
        <i slot="default" class="el-icon-plus"></i>
        <div slot="file" slot-scope="{ file }">
          <img class="el-upload-list__item-thumbnail" :src="file.url" alt="" />
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
      dialogImageUrl: "",
      dialogVisible: false,
      disabled: false,
      name: "Menu",
      tp: [],
      imageUrls: [],
      str: "is_del=0 and 1=1 and sale_state=2 or sale_state=3",
      str1: "1=1",
      str2: "1=1",
      // dialogVisible: true,
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
      menuOptions: [],
      hplx: "",
      options: [],
      value: [],
      ff1: true,
      formtable1: {
        bh: "",
        dw: "",
      },
      menuData: [],
      formtable: {
        dh: "",
        zt: "",
        gys: "",
        jhr: "",
        data: "",
      },
      tutu: true,
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
      hplx: [],
      formInline: {
        dh: "",
        ggxh: "",
        lx: "",
        mc: "",
        name: "",
        date: "",
        bei: "",
        rk: "",
        ck: "",
        zt: "",
        unit: "",
        item_type_code: "",
      },
      element: [],
      Imager: [],
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
        //sx: [{ required: true, message: "请选择顺序!", trigger: "change" }],
      },
    };
  },

  methods: {
    FenYetup() {
      var id = this.$route.params.item_id;
      $http
        .get("http://localhost:5149/api/Bs_item/FindGoodsIfoByItem_Id?id=" + id)
        .then((res) => {
          var imgUrls = res.imgUrl;
          if (imgUrls) {
            var imgUrlArray = imgUrls.split(",");
            for (let index = 0; index < imgUrlArray.length; index++) {
              const element = imgUrlArray[index];
              this.Imager.push("http://localhost:5149/api/images/" + element);
            }
          } else {
            this.Imager.push("http://localhost:5149/api/images/OIP-C.jpg");
          }
          console.log(this.Imager);
        });
    },
    // submitFile() {
    //     alert("ddd")
    //     this.$refs.myfile.submit();
    // },
    cascader() {
      $http
        .get("http://localhost:5149/api/Sys_encode/GetItems?father_code=0")
        .then((res) => {
          console.log(res);
          this.menuItems = res;

          this.menuOptions = this.transformMenuItems(this.menuItems);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    transformMenuItems(menuItems) {
      //级联方法
      const op2 = [];
      for (const item of menuItems) {
        const options = {
          value: item.item_type_code,
          label: item.item_type_name,
        };
        if (item.children && item.children.length > 0) {
          options.children = this.transformMenuItems(item.children);
        }
        op2.push(options);
      }
      return op2;
    },
    select() {
      // $http
      //   .get("http://localhost:5149/api/Bs_itemType/fatherGoodsFind")
      //   .then((res) => {
      //     console.log(res);
      //     this.options = res;
      //     this.menuData = res;
      //   });

      var id = this.$route.params.item_id;
      var pid = this.$route.params.father_code;
      $http
        .get(
          "http://localhost:5149/api/Sys_encode/FindGoodsIfoByItem_Id?id=" +
            id +
            ""
        )
        .then((res) => {
          console.log(res);

          this.formInline.rk = res.inbill_price;
          this.formInline.ck = res.outbill_price;
          this.formInline.zt = res.inbill_state;
          this.formInline.unit = res.unit;
          this.formInline.name = res.item_name;
          this.formInline.dh = res.item_code;
          this.formInline.ggxh = res.model_code;
          this.formInline.bei = res.remark;
          this.formInline.sx = res.sort_code;
          this.as = res.item_type;

          this.hplx = res.item_type_code;

          // console.log(this.as);
          this.formInline.item_code = res.item_code;
          this.file = res.ImgUrl;

          console.log(res);
        });

      // $http.get('http://localhost:5149/api/Sys_encode/FindSys_encodeById?id=1').then(res => {
      //     this.formInline.dh = res;
      // })
    },
    handleRemove(file) {
      const index = this.$refs.myfile.uploadFiles.indexOf(file);
      this.$refs.myfile.uploadFiles.splice(index, 1);

      // Close the dialog if it's open and the removed file is the one being previewed
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
    // handleRemove(file) {
    //   console.log(file);
    // },
    // handlePictureCardPreview(file) {
    //   this.dialogImageUrl = file.url;
    //   this.dialogVisible = true;
    // },
    // handleDownload(file) {
    //   console.log(file);
    // },
    onSuccess(response, file, fileList) {
      //    console.log(fileList.url);
      console.log(fileList);
      //   alert(response);
      for (let i = 0; i < fileList.length; i++) {
        this.element[i] = fileList[i].name;
      }
      this.tp = this.element;
      this.tutu = false;
      console.log(this.element);
    },
    cang() {
      var t = this;
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
    created() {},

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
    // CK() {
    //     var t = this;
    //     $http
    //         .get("http://localhost:5149/api/Bs_warehouse/Bs_warehouseSelect")
    //         .then(res => {
    //             t.countryList = res;
    //         })
    //         .catch(err => {
    //             alert(err);
    //         });
    //     $http
    //         .get("http://localhost:5149/api/Wh_inbill_h/FindUser")
    //         .then(res => {
    //             t.countryList2 = res;

    //         })
    //         .catch(err => {
    //             alert(err);
    //         });
    //     $http
    //         .get("http://localhost:5149/api/Wh_inbill_h/Bs_supplyFind")
    //         .then(res => {
    //             t.countryList3 = res;
    //         })
    //         .catch(err => {
    //             alert(err);
    //         });

    // },
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
      var name = localStorage.getItem("b");
      var id = this.$route.params.item_id;
      // var ppid = 0;
      // var h = 0;
      // if (this.value.length > 0) {
      //   ppid = parseInt(this.value[this.value.length - 1]);
      // } else {
      //   ppid = this.value;
      // }
      // if (this.value.length > 0) {
      //   h = parseInt(this.value[this.value.length - 1]);
      // } else {
      //   h = this.value;
      // }
      // if (this.formData.item_type.slice(-1)[0].length == 1) {
      //   sc = this.formData.item_type;
      // } else {
      //   sc = this.formData.item_type.slice(-1)[0];
      // }
      var sc;
      // if (this.formInline.item_type.slice(-1)[0].length == 1) {
      //   sc = this.formInline.item_type;
      // } else {
      //    sc = this.formInline.item_type.slice(-1)[0];
      // }
      if (this.hplx.slice(-1)[0].length == 1) {
        sc = this.hplx;
      } else {
        sc = this.hplx.slice(-1)[0];
      }

      console.log(sc);
      this.$refs.formInline1.validate((valid) => {
        if (valid) {
          $http
            .put(
              "http://localhost:5149/api/Bs_item/UpdateGoodsInFO?item_name=" +
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
                "&item_type_id=" +
                id +
                "&ImgUrl=" +
                this.tp +
                ""
            )
            .then((res) => {
              if (res) {
                this.$notify({
                  title: "修改",
                  message: "货品信息成功",
                  type: "success",
                });
                this.$router.push("/GoodsMessage");
              }
            });
        }
      });
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
    // this.CK();
    this.find1();
    this.cascader();
    this.select();

    this.FenYetup();
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
.block {
  height: 230px;
  margin-top: 20px;
  margin-left: 21px;
  width: 230px;
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
.upload-container {
  display: flex;
  flex-wrap: wrap;
}

.image-item {
  margin-right: 10px;
  margin-bottom: 10px;
}

.upload-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px dashed #ccc;
  border-radius: 4px;
  width: 100px;
  height: 100px;
  cursor: pointer;
}

.avatar {
  width: 100px;
  height: 100px;
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

#addxinfo {
  margin-top: 20px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 535px;
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