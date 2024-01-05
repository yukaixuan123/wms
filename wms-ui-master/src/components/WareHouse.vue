<template>
  <div id="kj">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">仓库管理</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>仓库管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!--搜索-->

    <transition-group name="lyric">
      <div id="form" v-if="showDefaultAttr" key="1">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="仓库" id="form_top">
            <el-input
              v-model="formInline.ck"
              id="tex"
              placeholder="请输入仓库名称/编号"
            ></el-input>
          </el-form-item>
          <el-form-item label="仓库状态" id="form_top">
            <el-select v-model="formInline.zt" id="tex" placeholder="请选择">
              <el-option label="启用" value="0"></el-option>
              <el-option label="停用" value="1"></el-option>
              <el-option label="已锁定" value="2"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="仓库主管" id="form_top" prop="ren">
            <el-select v-model="formInline.ren" id="tex" placeholder="请输入">
              <el-option
                v-for="item in List"
                :key="item.u_id"
                :label="item.u_True_name"
                :value="item.u_id"
              ></el-option>
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
      <el-button id="tex3" icon="el-icon-plus" @click="handleEdit()"
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
      <el-table-column fixed prop="warehouse_id" label="序号" width="60">
      </el-table-column>
      <el-table-column fixed prop="ware_code" label="仓库编号" width="120">
        <template slot-scope="{ row }">
          <router-link
            :to="{ name: 'WareHouseXiang', query: { dh: row.ware_name } }"
            style="color: #9c27b0"
            >{{ row.ware_code }}</router-link
          >
        </template>
      </el-table-column>
      <el-table-column fixed prop="ware_name" label="仓库名称" width="120">
      </el-table-column>
      <el-table-column prop="ware_cap" label="仓库容量/m" width="120">
      </el-table-column>
      <el-table-column
        prop="ware_adr"
        label="仓库地址"
        :show-overflow-tooltip="true"
        width="160"
      >
      </el-table-column>
      <el-table-column prop="ware_duty_man" label="仓库主管" width="100">
      </el-table-column>
      <el-table-column prop="ware_state" label="仓库状态" width="120">
        <template slot-scope="scope">
          <span
            v-if="scope.row.ware_state == 0"
            style="color: blue; font-weight: 600; font-size: 13px"
            >启用</span
          >
          <span
            v-if="scope.row.ware_state == 1"
            style="color: red; font-weight: 600; font-size: 13px"
            >停用</span
          >
          <span
            v-if="scope.row.ware_state == 2"
            style="color: pink; font-weight: 600; font-size: 13px"
            >已锁定</span
          >
        </template>

        <!-- <template slot-scope="scope">
          <div v-if="scope.row.ware_state == 0">
            <el-tag>启用</el-tag>
          </div>
          <div v-if="scope.row.ware_state == 1">
            <el-tag type="danger">停用 </el-tag>
          </div>
          <div v-if="scope.row.ware_state == 2">
            <el-tag type="warning">已锁定 </el-tag>
          </div>
        </template> -->
      </el-table-column>
      <el-table-column prop="sum" label="库位数量" width="100">
      </el-table-column>

      <el-table-column prop="create_by" label="操作人" width="120">
      </el-table-column>
      <el-table-column prop="create_time" label="操作时间" width="150">
        <template slot-scope="scope">
          <span>{{ filterTime(scope.row.create_time) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" fixed="right" width="100">
        <template slot-scope="scope">
          <img
            src="../Images/bianji1.png"
            title="编辑"
            width="25px"
            height="25px"
            @click="Update(scope.row.warehouse_id)"
          />
          <img
            src="../Images/shanchu.png"
            style="margin-left: 10px"
            title="删除"
            width="28px"
            height="28px"
            @click="handleDelete(scope.row)"
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
      style="width: 1440px"
    >
      <div class="demo-drawer__content">
        <el-form
          :model="formInline2"
          style="margin-top: 17px; height: 680px"
          ref="ckkgl"
          :rules="ru"
        >
          <el-form-item
            label="仓库编号"
            :label-width="formLabelWidth"
            prop="bh"
          >
            <el-input
              v-model="formInline2.bh"
              autocomplete="off"
              style="width: 210px"
              placeholder="自动获取系统编号"
              readonly
            ></el-input>
            <el-checkbox
              style="margin-left: 8px"
              v-model="checked"
              true-value="1"
              false-value="0"
              >默认仓库</el-checkbox
            >
          </el-form-item>
          <el-form-item
            label="仓库名称"
            :label-width="formLabelWidth"
            prop="name"
          >
            <el-input
              v-model="formInline2.name"
              autocomplete="off"
              style="width: 290px"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="仓库容量/立方" :label-width="formLabelWidth">
            <el-input
              v-model="formInline2.rl"
              autocomplete="off"
              style="width: 290px"
              type="number"
              placeholder="请输入"
            ></el-input>
            <p v-if="isNaN(formInline2.rl)">必须输入数字</p>
          </el-form-item>
          <el-form-item label="仓库主管" :label-width="formLabelWidth">
            <el-select v-model="formInline2.zg" id="tex" placeholder="请选择">
              <el-option
                v-for="item in List"
                :key="item.u_id"
                :label="item.u_True_name"
                :value="item.u_True_name"
              ></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="联系电话" :label-width="formLabelWidth">
            <el-input
              v-model="formInline2.dh"
              autocomplete="off"
              style="width: 290px"
              type="number"
              placeholder="请输入"
            ></el-input>
            <p v-if="isNaN(formInline2.dh)">必须输入数字</p>
          </el-form-item>
          <el-form-item label="仓库地址" :label-width="formLabelWidth">
            <el-input
              v-model="formInline2.dz"
              autocomplete="off"
              style="width: 290px"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="排序" :label-width="formLabelWidth">
            <el-input
              v-model="formInline2.px"
              autocomplete="off"
              style="width: 290px"
              type="number"
              placeholder="请输入"
            ></el-input>
            <p v-if="isNaN(formInline2.px)">必须输入数字</p>
          </el-form-item>
          <el-form-item label="状态" :label-width="formLabelWidth">
            <el-radio v-model="radio" label="0">启用</el-radio>
            <el-radio v-model="radio" label="1">停用</el-radio>
          </el-form-item>
          <el-form-item
            label="仓库锁定"
            :label-width="formLabelWidth"
            v-if="radio === '0'"
          >
            <el-switch
              v-model="value"
              active-value="1"
              inactive-value="0"
              active-color="#13ce66"
            >
            </el-switch>
          </el-form-item>
          <el-form-item label="备注" :label-width="formLabelWidth">
            <el-input
              v-model="formInline2.bz"
              autocomplete="off"
              placeholder="请输入"
              style="width: 290px"
            ></el-input>
          </el-form-item>
          <!-- <el-form-item label="" :label-width="formLabelWidth">
            <el-input
              autocomplete="off"
              value="1111"
              placeholder="请输入"
            ></el-input>
          </el-form-item> -->
        </el-form>
        <div class="demo-drawer__footer" id="didi">
          <el-button id="tj" @click="insert()">提交</el-button>
          <el-button @click="drawer = false" id="qx">取 消</el-button>
        </div>
      </div>
    </el-drawer>

    <el-drawer
      title="修改"
      :visible.sync="drawer1"
      :direction="direction"
      :before-close="handleClose"
    >
      <div class="demo-drawer__content">
        <el-form
          :model="formInline1"
          style="margin-top: 17px; height: 718px"
          :rules="rules1"
          ref="ckkgl1"
        >
          <el-form-item
            label="仓库编号"
            :label-width="formLabelWidth"
            prop="bh"
          >
            <el-input
              v-model="formInline1.bh"
              autocomplete="off"
              style="width: 210px"
              placeholder="自动获取系统编号"
              readonly
            ></el-input>
            <el-checkbox style="margin-left: 8px" v-model="checked1"
              >默认仓库</el-checkbox
            >
          </el-form-item>
          <el-form-item
            label="仓库名称"
            :label-width="formLabelWidth"
            prop="name"
          >
            <el-input
              v-model="formInline1.name"
              autocomplete="off"
              style="width: 290px"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="仓库容量/立方" :label-width="formLabelWidth">
            <el-input
              v-model="formInline1.rl"
              autocomplete="off"
              style="width: 290px"
              type="number"
              placeholder="请输入"
            ></el-input>
            <p v-if="isNaN(formInline1.rl)">必须输入数字</p>
          </el-form-item>
          <el-form-item label="仓库主管" :label-width="formLabelWidth">
            <el-select v-model="formInline1.zg" id="tex" placeholder="请选择">
              <el-option
                v-for="item in List"
                :key="item.u_id"
                :label="item.u_True_name"
                :value="item.u_True_name"
              ></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="联系电话" :label-width="formLabelWidth">
            <el-input
              v-model="formInline1.dh"
              autocomplete="off"
              style="width: 290px"
              type="number"
              placeholder="请输入"
            ></el-input>
            <p v-if="isNaN(formInline1.dh)">必须输入数字</p>
          </el-form-item>
          <el-form-item label="仓库地址" :label-width="formLabelWidth">
            <el-input
              v-model="formInline1.dz"
              autocomplete="off"
              style="width: 290px"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="排序" :label-width="formLabelWidth">
            <el-input
              v-model="formInline1.px"
              autocomplete="off"
              style="width: 290px"
              type="number"
              placeholder="请输入"
            ></el-input>
            <p v-if="isNaN(formInline1.px)">必须输入数字</p>
          </el-form-item>
          <el-form-item label="状态" :label-width="formLabelWidth">
            <el-radio v-model="radio1" label="0">启用</el-radio>
            <el-radio v-model="radio1" label="1">停用</el-radio>
          </el-form-item>
          <el-form-item
            label="仓库锁定"
            :label-width="formLabelWidth"
            v-if="radio1 === '0'"
          >
            <el-switch v-model="value1" active-color="#13ce66"> </el-switch>
          </el-form-item>
          <el-form-item label="备注" :label-width="formLabelWidth">
            <el-input
              v-model="formInline1.bz"
              autocomplete="off"
              placeholder="请输入"
              style="width: 290px"
            ></el-input>
          </el-form-item>
          <!-- <el-form-item label="" :label-width="formLabelWidth">
            <el-input
              autocomplete="off"
              value="1111"
              placeholder="请输入"
            ></el-input>
          </el-form-item> -->
        </el-form>
        <div class="demo-drawer__footer" id="didi">
          <el-button id="tj" @click="closeDrawer()">提交</el-button>
          <el-button @click="drawer1 = false" id="qx">取 消</el-button>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import $http from "../http/base.js";
var tj = "1 = 1 and is_del = '0'";
export default {
  data() {
    return {
      checked: 0,
      value: 0,
      checked1: false,
      value1: false,
      tableloading: false, //加载
      showDefaultAttr: true,
      multipleSelection: [], // 选中的行数据
      formInline: {
        ck: "",
        zt: "",
        ren: "",
      },
      formInline1: {
        bh: "",
        name: "",
        rl: "",
        zg: "",
        dh: "",
        dz: "",
        px: "",
        bz: "",
        id: 0,
      },
      formInline2: {
        bh: "",
        name: "",
        rl: "",
        zg: "",
        dh: "",
        dz: "",
        px: "",
        bz: "",
      },
      tableData: [],
      formLabelWidth: "100px",
      drawer: false,
      drawer1: false,
      direction: "rtl",
      radio: "0",
      radio1: "0",
      List: [],
      bl: "1",
      currentPage: 1, //当前页
      pagesize: 10, //每页显示数
      rows: 0, //总行数
      tj,
      rules1: {
        name: [{ required: true, message: "请输入仓库名称!", trigger: "blur" }],
        bh: [{ required: true, message: "请输入仓库编号!", trigger: "blur" }],
      },
      ru: {
        name: [{ required: true, message: "请输入仓库名称!", trigger: "blur" }],
        bh: [{ required: true, message: "请输入仓库编号!", trigger: "blur" }],
      },
    };
  },
  methods: {
    //查询方法
    find() {
      var t = this;
      $http
        .post(
          "http://localhost:5149/api/Bs_warehouse/FenYeHouse?currentPage=" +
            t.currentPage +
            "&pageSize=" +
            t.pagesize +
            "&str=" +
            tj +
            ""
        )
        .then((res) => {
          t.tableData = res.list;
          t.rows = res.rows;
          this.czr();
        })
        .catch((err) => {
          alert(err);
        });
    },
    czr() {
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
    Dang() {
      $http
        .get("http://localhost:5149/api/Sys_encode/FindSys_encodeById?id=" + 22)
        .then((res) => {
          this.formInline2.bh = res;
        })
        .catch((err) => {
          alert(err);
        });
    },
    sl() {
      $http.get("http://localhost:5149/api/Bs_warehouse/SelectAreaSL?name=");
    },
    //重置
    reset() {
      this.formInline.lx = "";
      this.formInline.zt = "";
      this.formInline.ren = "";
      this.formInline.data1 = "";
      tj = "1=1";
      this.find();
    },
    //每页显示数改变事件
    handleSizeChange(size) {
      this.pagesize = size;
      this.currentPage = 1;
      this.find();
      console.log(`每页 ${size} 条`);
    },
    //页码改变事件
    handleCurrentChange(page) {
      this.currentPage = page;
      this.find();
      console.log(`当前页: ${page}`);
    },
    handleEdit() {
      this.drawer = true;
      this.Dang();
    },
    insert() {
      this.$refs["ckkgl"].validate((valid) => {
        if (!valid) return;

        var t = this;
        var uu = localStorage.getItem("name");
        $http
          .get(
            "http://localhost:5149/api/Bs_warehouse/SelectName?name=" +
              t.formInline2.name
          )
          .then((res) => {
            if (res == 0) {
              if (t.formInline2.bz == "") {
                t.formInline2.bz = null;
              }
              $http
                .post(
                  "http://localhost:5149/api/Bs_warehouse/InsertHouse?code=" +
                    t.formInline2.bh +
                    "&cap=" +
                    t.formInline2.rl +
                    "&zt=" +
                    t.radio +
                    "&adr=" +
                    t.formInline2.dz +
                    "&mr=" +
                    Number(t.checked) +
                    "&sd=" +
                    t.value +
                    "&man=" +
                    t.formInline2.zg +
                    "&px=" +
                    t.formInline2.px +
                    "&cz=" +
                    uu +
                    "&gx=" +
                    uu +
                    "&name=" +
                    t.formInline2.name +
                    "&bz=" +
                    t.formInline2.bz +
                    "&dh=" +
                    t.formInline2.dh +
                    ""
                )
                .then((res) => {
                  if (res) {
                    $http
                      .put("http://localhost:5149/api/Bs_warehouse/UpdateSD")
                      .then((res) => {
                        if (res) {
                          this.$message({
                            message: "添加成功！",
                            type: "success",
                          });
                        }
                      });
                    t.formInline2.bh = "";
                    t.formInline2.name = "";
                    t.formInline2.rl = "";
                    t.formInline2.zg = "";
                    t.formInline2.dh = "";
                    t.formInline2.dz = "";
                    t.radio = "0";
                    t.checked = "0";
                    t.value = "0";
                    t.formInline2.px = "";
                    t.formInline2.bz = "";
                    t.drawer = false;
                    this.find();
                  }
                })
                .catch((err) => {
                  console.log(err);
                });
            } else {
              this.$message({
                message: "仓库名称已存在！",
                type: "error",
              });
            }
          })
          .catch((err) => {
            console.log(err);
          });
      });
    },
    Update(id) {
      this.drawer1 = true;
      $http
        .get("http://localhost:5149/api/Bs_warehouse/SelectID?id=" + id)
        .then((res) => {
          console.log("!23");
          console.log(res);
          if (res.ware_state === "0" || res.ware_state === "2") {
            this.radio1 = "0";
          } else {
            this.radio1 = "1";
          }
          this.formInline1.bh = res.ware_code;
          this.formInline1.name = res.ware_name;
          this.formInline1.rl = res.ware_cap;
          this.formInline1.zg = res.ware_duty_man;
          this.formInline1.dh = res.dh;
          this.formInline1.dz = res.ware_adr;
          // this.radio1 = res.ware_state;
          if (res.is_default == "1") {
            this.checked1 = true;
          } else {
            this.checked1 = false;
          }
          // this.value1 = res.is_lock === '1';
          if (res.is_lock == "1") {
            this.value1 = true;
          }
          this.formInline1.px = res.sort_code;
          this.formInline1.bz = res.remark;
          this.formInline1.id = res.warehouse_id;
          console.log(res.is_default);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    closeDrawer() {
      this.$refs["ckkgl1"].validate((valid) => {
        if (!valid) return;
        var t = this;
        var uu = localStorage.getItem("name");
        var mm = 0;
        if (t.checked1 == false) {
          mm = 0;
        } else if ((t.checked1 = true)) {
          mm = 1;
        }
        var ss = 0;
        if (t.value1 == false) {
          ss = 0;
        } else if (t.value1 == true) {
          ss = 1;
        }
        $http
          .put(
            "http://localhost:5149/api/Bs_warehouse/UpdateHouse?code=" +
              t.formInline1.bh +
              "&cap=" +
              t.formInline1.rl +
              "&zt=" +
              t.radio1 +
              "&adr=" +
              t.formInline1.dz +
              "&mr=" +
              mm +
              "&sd=" +
              ss +
              "&man=" +
              t.formInline1.zg +
              "&px=" +
              t.formInline1.px +
              "&gx=" +
              uu +
              "&name=" +
              t.formInline1.name +
              "&bz=" +
              t.formInline1.bz +
              "&dh=" +
              t.formInline1.dh +
              "&id=" +
              t.formInline1.id +
              ""
          )
          .then((res) => {
            if (res) {
              $http
                .put("http://localhost:5149/api/Bs_warehouse/UpdateSD")
                .then((res) => {
                  if (res) {
                    this.$message({
                      message: "修改成功！",
                      type: "success",
                    });
                  }
                })
                .catch((err) => {
                  console.log(err);
                });
              t.drawer1 = false;
              t.find();
            }
          })
          .catch((err) => {
            console.log(err);
          });
      });
    },
    //搜索
    search() {
      this.currentPage = 1;
      tj = "1=1";
      if (this.formInline.ck != "") {
        tj +=
          " and ware_name like '%" +
          this.formInline.ck +
          "%' or ware_code like '%" +
          this.formInline.ck +
          "%'";
      }
      if (this.formInline.zt != "") {
        tj += " and ware_state like '%" + this.formInline.zt + "%'";
      }
      if (this.formInline.ren != "") {
        tj += " and area_duty_man like '%" + this.formInline.ren + "%'";
      }
      this.find();
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    //删除
    handleDelete(i) {
      this.$confirm("此操作将永久删除该信息, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          $http
            .post(
              "http://localhost:5149/api/Bs_warehouse/DeleteHouse?id=" +
                i.warehouse_id +
                "&str=" +
                this.bl
            )
            .then((res) => {
              if (res) {
                this.$message({
                  message: "删除成功！",
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
    //刷新table
    flushed() {
      this.tableloading = true;
      // 模拟获取接口数据
      setTimeout(() => {
        //调用find();this.find();
        this.tableloading = false;
        this.find();
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
          var ss = [];
          for (let i = 0; i < this.multipleSelection.length; i++) {
            ss.push(this.multipleSelection[i].warehouse_id);
          }
          console.log("lo" + length);
          $http
            .put("http://localhost:5149/api/Bs_warehouse/PLDeleteHouse", ss)
            .then((res) => {
              if (res) {
                this.$message({
                  message: "删除成功！",
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
    filterTime(timestamp) {
      return formatDate(timestamp);
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
export function formatDate(date) {
  let time = new Date(date);

  let year = time.getFullYear();

  let month = time.getMonth() + 1;
  month = month.toString().padStart(2, "0");
  let day = time.getDate().toString().padStart(2, "0");
  return year + "年" + month + "月" + day + "日";
}
</script>
<style scoped src="../CSS/public.css"></style>
<style src="../CSS/tableys.css"></style>

<style scoped>
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
</style>