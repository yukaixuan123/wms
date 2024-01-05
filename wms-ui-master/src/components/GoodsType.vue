<template>
  <div id="kj">
    <!--头部-->
    <el-breadcrumb separator="/" id="card">
      <el-breadcrumb-item :to="{ path: '/Home' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item
        ><a href="javascript:void(0)">货品管理</a></el-breadcrumb-item
      >
      <el-breadcrumb-item>货品类型</el-breadcrumb-item>
    </el-breadcrumb>
    <!--搜索-->
    <transition-group name="lyric">
      <div id="form" v-if="showDefaultAttr" key="1">
        <el-form :inline="true" :model="formInline2" class="demo-form-inline">
          <el-form-item label="货品类型" id="form_top">
            <el-input
              v-model="formInline2.lx"
              id="tex"
              placeholder="请输入货品类型名称/编号"
            ></el-input>
          </el-form-item>
          <el-form-item label="状态" id="form_top">
            <el-select v-model="formInline2.zt" id="tex" placeholder="请选择">
              <el-option label="启用" value="0"></el-option>
              <el-option label="停用" value="1"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="操作人" id="form_top" prop="ren">
            <!-- <el-select v-model="formInline2.ren" id="tex" placeholder="请输入">
                            <el-option v-for="item in List" :key="item.u_id" :label="item.u_True_name"
                                :value="item.u_id"></el-option>
                        </el-select> -->
            <el-input
              v-model="formInline2.ren"
              id="tex"
              placeholder="操作人"
            ></el-input>
          </el-form-item>
          <el-form-item label="操作时间" prop="startDate">
            <el-date-picker
              id="tex"
              v-model="formInline2.startDate"
              value-format="yyyy-MM-dd"
              clearable
              type="date"
              placeholder="请选择"
            />
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
      height="450px"
      v-loading="tableloading"
      @selection-change="handleSelectionChange"
      :data="cateList"
      :header-cell-style="{ background: '#F8F8F9', color: '#606266' }"
      id="tableMain"
      element-loading-text="拼命加载中"
      element-loading-spinner="el-icon-loading"
      row-key="item_type_id"
    >
      <el-table-column type="selection" width="55"> </el-table-column>
      <el-table-column fixed label="序号" type="index" width="50">
      </el-table-column>
      <el-table-column
        fixed
        prop="item_type_name"
        label="货品类型名称"
        width="120"
      >
      </el-table-column>

      <el-table-column
        prop="item_type_code"
        label="货品类型编号"
        fixed
        width="120"
      >
      </el-table-column>

      <el-table-column fixed label="状态" width="100">
        <!-- <template slot-scope="scope">
          <span
            v-if="scope.row.inbill_state == 0"
            style="color: blue; font-weight: 600; font-size: 13px"
            >正常</span
          >
          <span
            v-if="scope.row.inbill_state == 1"
            style="color: red; font-weight: 600; font-size: 13px"
            >停用</span
          >
        </template> -->
        <template slot-scope="scope">
          <div v-if="scope.row.inbill_state == 0">
            <el-tag>启用</el-tag>
          </div>
          <div v-if="scope.row.inbill_state == 1">
            <el-tag type="danger">停用 </el-tag>
          </div>
        </template>
      </el-table-column>

      <el-table-column prop="sort_code" label="排序" width="90">
      </el-table-column>
      <el-table-column
        prop="remark"
        label="备注"
        :show-overflow-tooltip="true"
        width="110"
      >
      </el-table-column>

      <el-table-column prop="create_by" label="操作人" width="120">
      </el-table-column>
      <el-table-column label="操作时间" width="150">
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
            @click="handleEdit(scope.row)"
          />
          <img
            src="../Images/shanchu.png"
            width="28px"
            height="28px"
            style="margin-left: 5px"
            title="删除"
            @click="handleDelete(scope.row)"
          />
        </template>
      </el-table-column>
    </el-table>
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
    <!-- 新增 -->
    <el-drawer
      title="新增"
      :visible.sync="drawer"
      :direction="direction"
      :before-close="handleClose"
    >
      <div class="demo-drawer__content">
        <el-form :model="formInline" id="lxtjjj">
          <el-form-item label="上级分类" :label-width="formLabelWidth">
            <el-cascader
              id="hplxbd"
              :options="options"
              v-model="formInline.father_code"
              :props="{ checkStrictly: true }"
              @change="handleChange"
              clearable
            ></el-cascader>
          </el-form-item>
          <el-form-item label="类型编号" :label-width="formLabelWidth">
            <el-input
              v-model="formInline.bh"
              autocomplete="off"
              id="hplxbd"
            ></el-input>
          </el-form-item>
          <el-form-item label="类型名称" :label-width="formLabelWidth">
            <el-input
              v-model="formInline.name"
              autocomplete="off"
              id="hplxbd"
            ></el-input>
          </el-form-item>
          <el-form-item label="排序" :label-width="formLabelWidth">
            <el-input
              v-model="formInline.px"
              autocomplete="off"
              id="hplxbd"
            ></el-input>
          </el-form-item>
          <el-form-item label="状态" :label-width="formLabelWidth">
            <el-radio v-model="formInline.zt" label="0">启用</el-radio>
            <el-radio v-model="formInline.zt" label="1">停用</el-radio>
          </el-form-item>
          <el-form-item label="备注" :label-width="formLabelWidth">
            <el-input
              v-model="formInline.bz"
              autocomplete="off"
              id="hplxbd"
            ></el-input>
          </el-form-item>
        </el-form>
        <div class="demo-drawer__footer" id="didi">
          <el-button id="tj" @click="closeDrawer()">提交</el-button>
          <el-button @click="drawer = false" id="qx">取 消</el-button>
        </div>
      </div>
    </el-drawer>
    <!-- 修改 -->

    <el-drawer
      title="修改"
      :visible.sync="drawer1"
      :direction="direction"
      :before-close="handleClose"
    >
      <div class="demo-drawer__content">
        <el-form :model="formInline1" id="lxtjjj">
          <el-form-item label="上级分类" :label-width="formLabelWidth">
            <el-cascader
              id="hplxbd"
              :options="options"
              v-model="formInline1.father_code"
              :props="{ checkStrictly: true }"
              @change="handleChange"
              clearable
            ></el-cascader>
          </el-form-item>
          <el-form-item label="类型编号" :label-width="formLabelWidth">
            <el-input
              v-model="formInline1.bh"
              autocomplete="off"
              id="hplxbd"
            ></el-input>
          </el-form-item>
          <el-form-item label="类型名称" :label-width="formLabelWidth">
            <el-input
              v-model="formInline1.name"
              autocomplete="off"
              id="hplxbd"
            ></el-input>
          </el-form-item>
          <el-form-item label="排序" :label-width="formLabelWidth">
            <el-input
              v-model="formInline1.px"
              autocomplete="off"
              id="hplxbd"
            ></el-input>
          </el-form-item>
          <el-form-item label="状态" :label-width="formLabelWidth">
            <el-radio v-model="formInline1.zt" label="0">启用</el-radio>
            <el-radio v-model="formInline1.zt" label="1">停用</el-radio>
          </el-form-item>
          <el-form-item label="备注" :label-width="formLabelWidth">
            <el-input
              v-model="formInline1.bz"
              autocomplete="off"
              id="hplxbd"
            ></el-input>
          </el-form-item>
        </el-form>
        <div class="demo-drawer__footer" id="didi">
          <el-button id="tj" @click="updateok()">提交</el-button>
          <el-button @click="drawer1 = false" id="qx">取 消</el-button>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script>
var str = " 1=1 and is_del=0 ";
var fjid = 0;
import $http from "../http/base.js";
export default {
  data() {
    return {
      tableloading: false, //加载
      showDefaultAttr: true,
      multipleSelection: [], // 选中的行数据
      formInline: {
        bh: "",
        zt: "0",
        px: "",
        bz: "",
        name: "",
        father_code: "",
      },

      formInline1: {
        fl: "",
        bh: "",
        name: "",
        px: "",
        bz: "",
        zt: "",
        item_type_id: 0,
        father_code: "",
      },
      formInline2: {
        lx: "",
        zt: "",
        ren: "",
        startDate: "",
      },
      value1: [],
      options: [],
      menuItems: [],
      tableData: [],
      cateList: [],
      formLabelWidth: "100px",
      drawer: false,
      drawer1: false,
      direction: "rtl",
      radio: "0",
      radio1: "0",
      List: [],
      bl: "1",
      direction: "rtl",
      currentPage: 1, //当前页
      pagesize: 10, //每页显示数
      rows: 0, //总行数
    };
  },
  methods: {
    //查询方法
    find() {
      var t = this;
      // $http.get('http://localhost:5149/api/Bs_itemType/fatherGoodsFind'
      // ).then(res => {
      //     console.log(res);
      //     this.tableData = res.label;
      // })
      $http
        .get(" http://localhost:5149/api/Bs_itemType/FindGoodsType", {
          params: {
            currentPage: this.currentPage,
            pageSize: this.pagesize,
            str,
          },
        })
        .then((res) => {
          console.log(res);
          this.cateList = res.list;

          this.rows = res.rows;
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
    czr() {
      // $http
      //   .get("http://localhost:5149/api/Bs_itemType/fatherGoodsFind")
      //   .then((res) => {
      //     console.log(res);
      //     this.options = res;
      //   });
    },
    add() {
      this.drawer = true;
      $http
        .get("http://localhost:5149/api/Sys_encode/FindSys_encodeById?id=1")
        .then((res) => {
          this.formInline.bh = res;
        });
    },
    closeDrawer() {
      var sc;
      if (
        this.formInline.father_code &&
        this.formInline.father_code.length > 0
      ) {
        // Set to the last selected value (assuming checkStrictly is true)
        sc =
          this.formInline.father_code[this.formInline.father_code.length - 1];
      } else {
        // Nothing selected, set to default value (e.g., "0")
        sc = "0";
      }
      console.log(sc);
      var name = localStorage.getItem("b");
      $http
        .post(
          "http://localhost:5149/api/Bs_itemType/AddGoodsType?father_code=" +
            sc +
            "&item_type_code=" +
            this.formInline.bh +
            "&item_type_name=" +
            this.formInline.name +
            "&inbill_state=" +
            this.formInline.zt +
            "&sort_code=" +
            this.formInline.px +
            "&remark=" +
            this.formInline.bz +
            "&create_by=" +
            name +
            "&is_del=0"
        )
        .then((res) => {
          if (res) {
            this.$message({
              message: "新增成功！",
              type: "success",
            });
            this.drawer = false;
            this.find();
          }
          console.log(res);
        });
    },
    //重置
    reset() {
      this.formInline2.lx = "";
      this.formInline2.zt = "";
      this.formInline2.ren = "";
      this.formInline2.startDate = "";
      this.find();
    },
    handleEdit(obj) {
      this.drawer1 = true;
      console.log(obj);
      this.formInline1.bh = obj.item_type_code;
      this.formInline1.name = obj.item_type_name;
      this.formInline1.zt = obj.inbill_state;
      this.formInline1.px = obj.sort_code;
      this.formInline1.bz = obj.remark;
      this.formInline1.father_code = obj.father_code;
      this.formInline1.item_type_id = obj.item_type_id;
    },

    updateok() {
      // var h = 0;
      // if (this.value.length > 0) {
      //   h = parseInt(this.value[this.value.length - 1]);
      // } else {
      //   h = this.value;
      // }
      var ppid = "";
      if (this.formInline1.father_code.slice(-1)[0].length == 1) {
        ppid = this.formInline1.father_code;
      } else {
        ppid = this.formInline1.father_code.slice(-1)[0];
      }

      var name = localStorage.getItem("b");
      $http
        .put(
          "http://localhost:5149/api/Bs_itemType/UpdateGoodsType?father_code=" +
            ppid +
            "&item_type_code=" +
            this.formInline1.bh +
            "&item_type_name=" +
            this.formInline1.name +
            "&inbill_state=" +
            this.formInline1.zt +
            "&sort_code=" +
            this.formInline1.px +
            "&remark=" +
            this.formInline1.bz +
            "&update_by=" +
            name +
            "&item_type_id=" +
            this.formInline1.item_type_id +
            ""
        )
        .then((res) => {
          if (res) {
            this.$message({
              message: "修改成功！",
              type: "success",
            });
            this.drawer1 = false;
            this.find();
          }
        });
    },
    // update(obj) {
    //     this.drawer1 = true;
    //    console.log(obj);
    // },
    //搜索
    search() {
      this.currentPage = 1;
      str = " 1=1 and  is_del=0 ";
      if (this.formInline2.lx != "") {
        str +=
          " AND item_type_code like CONCAT('%','" +
          this.formInline2.lx +
          "','%') or  item_type_name like CONCAT('%','" +
          this.formInline2.lx +
          "','%')";
      }
      if (this.formInline2.ren != "") {
        str +=
          " AND create_by like CONCAT('%','" + this.formInline2.ren + "','%')";
      }
      if (this.formInline2.zt != "") {
        str +=
          " AND inbill_state like CONCAT('%','" +
          this.formInline2.zt +
          "','%')";
      }
      // if (this.formInline2.startDate != "") {
      //     str += " AND create_time like CONCAT('%','" + this.formInline2.startDate + "','%')";
      // }
      if (this.formInline2.startDate != "") {
        const yearMonthDay = this.formInline2.startDate.substring(0, 10);
        str +=
          "and convert(varchar(50),create_time,120) LIKE  '" +
          yearMonthDay +
          "%'";
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
            .get(
              "http://localhost:5149/api/Sys_encode/FindBs_item_type?item_type_code=" +
                i.item_type_code
            )
            .then((res) => {
              if (res && res.length > 0) {
                this.$message({
                  type: "error",
                  message: "该主表被子表索引",
                });
              } else {
                // console.log(i.father_code);
                // $http.get('http://localhost:5149/api/Sys_encode/FindFather11?father_code=' + i.father_code).then(res => {
                //   console.log(res);
                // })
                $http
                  .put(
                    "http://localhost:5149/api/Sys_encode/DeleteBs_item_type?item_type_code=" +
                      i.item_type_code
                  )
                  .then((res) => {
                    this.$message({
                      type: "success",
                      message: "删除成功！",
                    });
                    this.find();
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
            ss.push(this.multipleSelection[i].item_type_id);
          }
          console.log("lo" + length);
          $http
            .put("http://localhost:5149/api/Bs_itemType/PLDeleteItemType", ss)
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
    handleChange(value) {
      console.log(value);
    },
    filterTime(timestamp) {
      return formatDate(timestamp);
    },
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
  },
  mounted() {
    this.find();
    this.cascader();
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

<style>
#hplxbd {
  width: 300px;
}
#lxtjjj {
  margin-top: 15px;
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