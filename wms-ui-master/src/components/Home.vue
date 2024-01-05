<template>
  <div
    id="ww"
    v-loading="fullscreenLoading"
    element-loading-text="拼命加载中"
    element-loading-spinner="el-icon-loading"
    element-loading-size="300px"
  >
    <!--今日 昨日概况--->
    <div class="ho">
      <div style="border: 1px solid #eeeeee; height: 40px">
        <i id="i">今日概况</i>
        <i id="ii">昨日概况</i>
        <!--昨日概况--->
        <div
          style="
            width: 575px;
            border: 1px solid #fff;
            margin-top: 10px;
            display: inline-block;
          "
        >
          <ul id="jrgk">
            <li>
              单据数量<i>{{ yesrk1 }}</i
              ><button class="rkan">入库</button>
            </li>
            <li>
              入库数量<i>{{ yesrk2 }}</i>
            </li>
            <li>
              入库金额<i>{{ formatMoney(yesrk3) }}</i>
            </li>
          </ul>
          <ul id="jrgk1">
            <li>
              单据数量<i>{{ yesck1 }}</i
              ><button class="ckan">出库</button>
            </li>
            <li>
              出库数量<i>{{ yesck2 }}</i>
            </li>
            <li>
              出库金额<i>{{ formatMoney(yesck3) }}</i>
            </li>
          </ul>
        </div>

        <!-- 今日概况--->
        <div
          style="
            width: 569px;
            border: 1px solid #fff;
            margin-top: 10px;
            float: left;
          "
        >
          <ul id="jrgk">
            <li>
              单据数量<i>{{ tork1 }}</i
              ><button class="rkan">入库</button>
            </li>
            <li>
              入库数量<i>{{ tork2 }}</i>
            </li>
            <li>
              入库金额<i>{{ formatMoney(tork3) }}</i>
            </li>
          </ul>
          <ul id="jrgk1">
            <li>
              单据数量<i>{{ tock1 }}</i
              ><button class="ckan">出库</button>
            </li>
            <li>
              出库数量<i>{{ tock2 }}</i>
            </li>
            <li>
              出库金额<i>{{ formatMoney(tock3) }}</i>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <div class="hong">
      <!--库存占比--->
      <div class="ho1">
        <div style="border: 1px solid #eeeeee; width: 525; height: 40px">
          <i id="i">库存数量占比</i>
          <div
            ref="bt"
            style="
              width: 500px;
              margin-left: 40px;
              margin-top: -35px;
              height: 450px;
            "
          ></div>
          <p
            style="
              position: relative;
              left: 272px;
              top: -239px;
              width: 44px;
              font-size: 13px;
              font-weight: bold;
            "
          >
            总数量{{ formatMoney(hpSUM) }}
          </p>
        </div>
      </div>
      <!--库存货品占比--->
      <div class="ho2">
        <div style="border: 1px solid #eeeeee; width: 525; height: 40px">
          <i id="i">库存货品数量占比</i>

          <div
            ref="bt1"
            style="
              width: 500px;
              margin-left: 40px;
              margin-top: -35px;
              height: 450px;
            "
          ></div>

          <p
            style="
              position: relative;
              left: 272px;
              top: -239px;
              width: 44px;
              font-size: 13px;
              font-weight: bold;
            "
          >
            总数量{{ formatMoney(hpSUM) }}
          </p>
        </div>
      </div>
    </div>
    <!--入库统计--->
    <div id="rk">
      <div style="border: 1px solid #eeeeee; height: 40px">
        <i id="i">入库统计</i>
        <div
          ref="chart"
          style="
            width: 1100px;
            margin-left: -0px;
            margin-top: 10px;
            height: 350px;
          "
        ></div>
      </div>
    </div>
    <!--出库统计--->
    <div id="ck">
      <div style="border: 1px solid #eeeeee; height: 40px">
        <i id="i">出库统计</i>
        <div
          ref="chart1"
          style="
            width: 1100px;
            margin-left: -0px;
            margin-top: 10px;
            height: 340px;
          "
        ></div>
      </div>
    </div>
    <!--入库排名--->
    <div class="zb">
      <div style="border: 1px solid #eeeeee; width: 525; height: 40px">
        <i id="i">入库排名</i>
        <el-table
          ref="singleTable"
          :data="tableData"
          :header-cell-style="{
            'text-align': 'center',
            'font-weight': 'bold',
            color: '#000',
          }"
          :cell-style="{ 'text-align': 'center' }"
          style="width: 100%"
        >
          <el-table-column type="index" label="序号" width="110">
            <template scope="scope">
              <span
                class="index_common"
                v-bind:class="[
                  scope.$index + 1 == '1'
                    ? 'index_one'
                    : scope.$index + 1 == '2'
                    ? 'index_two'
                    : scope.$index + 1 == '3'
                    ? 'index_three'
                    : 'index_more',
                ]"
              >
                {{ scope.$index + 1 }}
              </span>
            </template>
          </el-table-column>
          <el-table-column property="item_name" label="货品名称" width="110">
          </el-table-column>
          <el-table-column property="inbill_num" label="数量" width="107">
          </el-table-column>
          <el-table-column label="金额" width="110">
            <template slot-scope="scope">
              <span>{{ formatMoney(scope.row.buy_price) }}</span>
            </template>
          </el-table-column>
          <el-table-column property="number" label="入库次数" width="110">
          </el-table-column>
        </el-table>
      </div>
    </div>
    <!--出库排名--->
    <div class="zb1">
      <div style="border: 1px solid #eeeeee; width: 525; height: 40px">
        <i id="i">出库排名</i>
        <el-table
          ref="singleTable"
          :data="tableData1"
          :header-cell-style="{
            'text-align': 'center',
            'font-weight': 'bold',
            color: '#000',
          }"
          :cell-style="{ 'text-align': 'center' }"
          style="width: 100%"
        >
          <el-table-column type="index" label="序号" width="110">
            <template scope="scope">
              <span
                class="index_common"
                v-bind:class="[
                  scope.$index + 1 == '1'
                    ? 'index_one'
                    : scope.$index + 1 == '2'
                    ? 'index_two'
                    : scope.$index + 1 == '3'
                    ? 'index_three'
                    : 'index_more',
                ]"
              >
                {{ scope.$index + 1 }}
              </span>
            </template>
          </el-table-column>
          <el-table-column property="item_name1" label="货品名称" width="110">
          </el-table-column>
          <el-table-column property="outbill_num1" label="数量" width="107">
          </el-table-column>
          <el-table-column label="销售单价" width="110">
            <template slot-scope="scope">
              <span>{{ formatMoney(scope.row.sale_price1) }}</span>
            </template>
          </el-table-column>
          <el-table-column property="number1" label="出库次数" width="110">
          </el-table-column>
        </el-table>
      </div>
    </div>
    <el-button
      title="顶部"
      v-if="showElement"
      icon="el-icon-top"
      id="db"
      @click="scollTop"
    ></el-button>
  </div>
</template>

<script>
import $http from "../http/base.js";
import * as echarts from "echarts";
export default {
  data() {
    return {
      showElement: false,
      fullscreenLoading: false,
      tableData: [],
      tableData1: [],
      list: [],
      list1: [],

      list2: [],
      listSL: [],

      list3: [],
      listHPSL: [],

      inbll_date: [],
      total_buy_num: [],
      total_price: [],

      outbill_date1: [],
      total_buy_num1: [],
      total_price1: [],

      hpSUM: 0,
      kcSUM: 0,

      tork1: 0,
      tork2: 0,
      tork3: 0,
      yesrk1: 0,
      yesrk2: 0,
      yesrk3: 0,

      tock1: 0,
      tock2: 0,
      tock3: 0,
      yesck1: 0,
      yesck2: 0,
      yesck3: 0,
    };
  },
  methods: {
    //保留两位小数好
    formatMoney(value) {
      return value.toFixed(2);
    },
    //入库排名
    RKpaiming() {
      $http.get("http://localhost:5149/api/Home/RKpaiming").then((res) => {
        this.tableData = res;
      });
    },
    //出库排名
    CKpaiming() {
      $http.get("http://localhost:5149/api/Home/CKpaiming").then((res) => {
        console.log(res);
        this.tableData1 = res;
      });
    },
    //入库今
    rkjfind() {
      $http.get("http://localhost:5149/api/Home/ToCountRK").then((res) => {
        this.tork1 = res.to_Table1Count;
        this.tork2 = res.to_total_buy_num;
        this.tork3 = res.to_total_price;
      });
    },
    //入库昨
    rkzfind() {
      $http.get("http://localhost:5149/api/Home/YesCountRK").then((res) => {
        this.yesrk1 = res.yes_Table1Count;
        this.yesrk2 = res.yes_total_buy_num;
        this.yesrk3 = res.yes_total_price;
      });
    },
    //出库今
    ckjfind() {
      $http.get("http://localhost:5149/api/Home/ToCountCK").then((res) => {
        this.tock1 = res.to_Table1Count1;
        this.tock2 = res.to_total_buy_num1;
        this.tock3 = res.to_total_price1;
      });
    },
    //出库昨
    ckzfind() {
      $http.get("http://localhost:5149/api/Home/YesCountCK").then((res) => {
        this.yesck1 = res.yes_Table1Count1;
        this.yesck2 = res.yes_total_buy_num1;
        this.yesck3 = res.yes_total_price1;
      });
    },
    //库存数量
    ckSUMfind() {
      $http.get("http://localhost:5149/api/Home/kcslSUM").then((res) => {
        this.kcSUM = res;
      });
    },
    //货品总数量
    hpSUMfind() {
      $http.get("http://localhost:5149/api/Home/hpslSUM").then((res) => {
        this.hpSUM = res;
      });
    },
    //回到顶部
    scollTop() {
      //  设置一个定时器
      const upRoll = setInterval(() => {
        const top = document.documentElement.scrollTop; // 每次获取页面被卷去的部分
        const speed = Math.ceil(top / 20); // 每次滚动多少 （步长值）
        if (document.documentElement.scrollTop > 0) {
          document.documentElement.scrollTop -= speed; // 不在顶部 每次滚动到的位置
        } else {
          clearInterval(upRoll); // 回到顶部清除定时器
        }
      }, 10);
    },
    handleScroll() {
      // 检查滚动位置，当达到某个条件时显示元素
      if (window.scrollY > 300) {
        this.showElement = true;
      }
      if (window.scrollY < 50) {
        this.showElement = false;
      }
    },
    //加载
    openFullScreen1() {
      this.fullscreenLoading = true;
      setTimeout(() => {
        this.fullscreenLoading = false;
      }, 1500);
    },
    //出库树状图
    infoEcharts() {
      $http.get("http://localhost:5149/api/Home/HomeRK").then((res) => {
        this.list = res;
        for (let i = 0; i < this.list.length; i++) {
          // 假设 inbll_date 是一个日期字符串
          let date = new Date(this.list[i].inbll_date);

          // 转换为特定格式的日期字符串
          let formattedDate =
            date.getFullYear() +
            "-" +
            (date.getMonth() + 1).toString().padStart(2, "0") +
            "-" +
            date.getDate().toString().padStart(2, "0");

          this.inbll_date[i] = formattedDate;
          this.total_buy_num[i] = this.list[i].total_buy_num;
          this.total_price[i] = this.list[i].total_price;
        }
        const myChart = echarts.init(this.$refs.chart); // 实例化echarts对象
        //配置图表
        var option = {
          tooltip: {
            trigger: "axis",
            axisPointer: {
              type: "cross",
              crossStyle: {
                color: "#999",
                width: "0px",
              },
            },
          },
          toolbox: {
            feature: {
              dataView: { show: true, readOnly: false },
              magicType: { show: true, type: ["line", "bar"] },
              restore: { show: true },
              saveAsImage: { show: true },
            },
          },
          legend: {
            data: ["数量", "价格"],
          },
          xAxis: [
            {
              type: "category",
              data: this.inbll_date,
              axisPointer: {
                type: "shadow",
              },
            },
          ],
          yAxis: [{ name: "数量" }, { name: "价格" }],
          series: [
            {
              name: "数量",
              type: "bar",
              tooltip: {
                valueFormatter: function (value) {
                  return value + " 个";
                },
              },
              data: this.total_buy_num,
            },
            {
              name: "价格",
              type: "line",
              yAxisIndex: 1,
              tooltip: {
                valueFormatter: function (value) {
                  return value + " ￥";
                },
              },
              data: this.total_price,
            },
          ],
        };

        myChart.setOption(option);
      });
    },
    //入库树状图
    infoEcharts1() {
      $http.get("http://localhost:5149/api/Home/HomeCK").then((res) => {
        this.list1 = res;
        for (let i = 0; i < this.list1.length; i++) {
          // 假设 inbll_date 是一个日期字符串
          let date = new Date(this.list1[i].outbill_date);

          // 转换为特定格式的日期字符串
          let formattedDate =
            date.getFullYear() +
            "-" +
            (date.getMonth() + 1).toString().padStart(2, "0") +
            "-" +
            date.getDate().toString().padStart(2, "0");

          this.outbill_date1[i] = formattedDate;
          this.total_buy_num1[i] = this.list1[i].total_buy_num;
          this.total_price1[i] = this.list1[i].total_price;
        }
        const myChart = echarts.init(this.$refs.chart1); // 实例化echarts对象
        //配置图表
        var option = {
          tooltip: {
            trigger: "axis",
            axisPointer: {
              type: "cross",
              crossStyle: {
                color: "#999",
              },
            },
          },
          toolbox: {
            feature: {
              dataView: { show: true, readOnly: false },
              magicType: { show: true, type: ["line", "bar"] },
              restore: { show: true },
              saveAsImage: { show: true },
            },
          },
          legend: {
            data: ["数量", "价格"],
          },
          xAxis: [
            {
              type: "category",
              data: this.outbill_date1,
              axisPointer: {
                type: "shadow",
              },
            },
          ],
          yAxis: [{ name: "数量" }, { name: "价格" }],
          series: [
            {
              name: "数量",
              type: "bar",
              color: ["#F2CA6B"],
              tooltip: {
                valueFormatter: function (value) {
                  return value + " 个";
                },
              },
              data: this.total_buy_num1,
            },
            {
              name: "价格",
              type: "line",
              color: ["#9ECA7F"],
              yAxisIndex: 1,
              tooltip: {
                valueFormatter: function (value) {
                  return value + " ￥";
                },
              },
              data: this.total_price1,
            },
          ],
        };
        myChart.setOption(option);

        // // 遍历接收到的数据并转换为所需的格式
        // this.list1.forEach((item) => {
        //   this.list2.push({
        //     value: item.total_buy_num1,
        //     name: item.total_price1,
        //   });
        // });
      });
    },
    //库存数量占比
    Piecharts() {
      $http.get("http://localhost:5149/api/Home/HomeSL").then((res) => {
        this.list2 = res;
        // 遍历接收到的数据并转换为所需的格式
        this.list2.forEach((item) => {
          this.listSL.push({
            value: item.inbill3_num,
            name: item.ware_code,
          });
        });

        const myChart = echarts.init(this.$refs.bt); // 实例化echarts对象
        //配置图表
        var option = {
          legend: {
            top: "bottom",
          },
          title: {
            text: "",
            subtext: "",
            left: "center",
          },
          tooltip: {
            trigger: "item",
          },
          toolbox: {
            feature: {
              dataView: { show: true, readOnly: false },
              restore: { show: true },
              saveAsImage: { show: true },
            },
          },
          series: [
            {
              name: "数据",
              type: "pie",
              radius: [50, 110],
              center: ["50%", "50%"],
              itemStyle: {
                borderRadius: 8,
              },
              data: this.listSL,
            },
          ],
        };
        myChart.setOption(option);
      });
    },
    //库存货品数量占比
    Piecharts1() {
      $http.get("http://localhost:5149/api/Home/HomeHPSL").then((res) => {
        this.list3 = res;
        // 遍历接收到的数据并转换为所需的格式
        this.list3.forEach((item) => {
          this.listHPSL.push({
            value: item.inbill3_num,
            name: item.item_name,
          });
        });
        const myChart = echarts.init(this.$refs.bt1); // 实例化echarts对象
        //配置图表
        var option = {
          legend: {
            top: "bottom",
          },
          title: {
            text: "",
            subtext: "",
            left: "center",
          },
          tooltip: {
            trigger: "item",
          },
          toolbox: {
            feature: {
              dataView: { show: true, readOnly: false },
              restore: { show: true },
              saveAsImage: { show: true },
            },
          },
          series: [
            {
              name: "数据",
              type: "pie",
              radius: [50, 130],
              center: ["50%", "50%"],
              roseType: "area",
              itemStyle: {
                borderRadius: 8,
              },
              data: this.listHPSL,
            },
          ],
        };
        myChart.setOption(option);
      });
    },
  },
  mounted() {
    window.addEventListener("scroll", this.handleScroll);
    this.openFullScreen1();
    this.infoEcharts();
    this.infoEcharts1();
    this.Piecharts();
    this.Piecharts1();
    this.hpSUMfind();
    this.ckSUMfind();
    this.rkjfind();
    this.rkzfind();
    this.ckjfind();
    this.ckzfind();
    this.RKpaiming();
    this.CKpaiming();
  },
};
</script>
<style>
.index_common {
  width: 20px;
  height: 20px;
  display: inline-block;
  border-radius: 4em;
  color: #ffffff;
}
.index_one {
  background: red;
}
.index_two {
  background: #e6a23c;
}
.index_three {
  background: #409eff;
}
.index_more {
  background: #c8c9cc;
}
.rkan {
  float: right;
  margin-right: 20px;
  margin-top: 10px;
  width: 40px;
  height: 26px;
  line-height: 26px;
  border: 1px solid #5fcb71;
  color: #5fcb71;
  border-radius: 2px;
  background-color: #effaf1;
}
.ckan {
  float: right;
  margin-right: 20px;
  margin-top: 10px;
  width: 40px;
  height: 26px;
  line-height: 26px;
  border: 1px solid #f3b23e;
  color: #f3b23e;
  border-radius: 2px;
  background-color: #fdf3e2;
}
#jrgk {
  height: 122px;
  width: 260px;
  line-height: 40px;
  border-right: 1px solid #eeeeee;
  margin-top: 20px;
  margin-left: 20px;
  font-size: 13px;
  color: #999999;
  float: left;
}
#jrgk1 {
  margin-left: 300px;
  height: 122px;
  line-height: 40px;
  border-right: 1px solid #eeeeee;
  margin-top: 20px;
  font-size: 13px;
  color: #999999;
}
#jrgk i {
  font-size: 13px;
  color: #000;
  margin-left: 20px;
  font-weight: bold;
}
#jrgk1 i {
  font-size: 13px;
  color: #000;
  margin-left: 20px;
  font-weight: bold;
}
.zb {
  width: 550px;
  height: 575px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 2px 0 20px 3px #dcdde2;
  float: left;
  margin-top: 30px;
}
.zb1 {
  margin-left: 42px;
  width: 550px;
  height: 575px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 2px 0 20px 3px #dcdde2;
  float: left;
  margin-top: 30px;
}
#ww .el-loading-spinner {
  top: 13%;
  margin-top: -21px;
  width: 100%;
  text-align: center;
  position: relative;
  font-size: 50px;
}
#ww .el-loading-spinner .el-loading-text {
  color: #409eff;
  margin: 3px 0;
  font-size: 15px;
}
#ww .el-loading-mask {
  position: absolute;
  z-index: 2000;
  background-color: rgba(255, 255, 255, 0.9);
  margin: 0;
  top: 0;
  right: -8px;
  bottom: -600px;
  left: 0;
  transition: opacity 0.3s;
}
#rk {
  width: 1150px;
  height: 380px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 2px 0 20px 3px #dcdde2;
  margin-top: 260px;
}
#ck {
  width: 1150px;
  height: 380px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 2px 0 20px 3px #dcdde2;
  margin-top: 25px;
}
#i {
  line-height: 40px;
  font-size: 13px;
  font-weight: bold;
  margin-left: 20px;
}
#ii {
  line-height: 40px;
  font-size: 13px;
  font-weight: bold;
  margin-left: 520px;
}
#db {
  position: fixed;
  right: 20px;
  bottom: 10px;
  width: 40px;
  height: 40px;
  padding: 0 !important;
  border-radius: 30px !important;
}
.ho {
  width: 1150px;
  height: 250px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 2px 0 20px 3px #dcdde2;
}
.hong {
  margin-top: 25px;
  width: 1150px;
  height: 250px;
  border-radius: 5px;
}
.ho1 {
  width: 555px;
  height: 480px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 2px 0 20px 3px #dcdde2;
  float: left;
}
.ho2 {
  margin-left: 40px;
  width: 555px;
  height: 480px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 2px 0 20px 3px #dcdde2;
  float: left;
}
</style>