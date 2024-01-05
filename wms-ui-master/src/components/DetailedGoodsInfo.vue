<template>
  <div>
    <div id="addsdh">
      <h3 style="margin-left: 35px; padding-top: 30px; display: inline-block">
        货品单号：{{ formInline.dh }}

        <img
          src="../Images/fz.png"
          width="20px"
          height="20px"
          style="vertical-align: middle; margin-left: 120px"
          @click="fzcg"
        />
      </h3>

      <div style="float: right; padding-top: 30px; margin-right: 35px">
        <!-- <el-button id="tex3" @click="inserok()" icon="el-icon-plus">编辑</el-button> -->
        <!-- <el-button  id="tex4"  icon="el-icon-edit">修改</el-button> -->
        <el-button id="tex5" @click="delAll()" icon="el-icon-delete"
          >撤销</el-button
        >
        <el-button id="tex6" icon="el-icon-download">打印</el-button>
      </div>

      <div class="block">
        <el-carousel trigger="click" height="250px">
          <el-carousel-item
            v-for="item in Imager"
            :key="item"
            style="border-radius: 10px"
          >
            <img :src="item" width="290px" height="260px" />
          </el-carousel-item>
        </el-carousel>
      </div>
      <!-- <div class="demo-image__lazy">
          <el-image
            v-for="item in Imager"
            :key="item"
            :src="item"
            lazy
            style="width: 200px; height: 200px"
          ></el-image>
        </div> -->

      <table
        style="
          width: 945px;
          line-height: 55px;
          position: relative;
          right: -375px;
          top: -245px;
        "
      >
        <tr>
          <td>
            入库类型<i style="margin-left: 50px; color: #999999">{{
              formInline.lx
            }}</i>
          </td>

          <td style="position: relative; left: -55px">
            创建时间<i style="margin-left: 30px; color: #999999">{{
              filterTime(formInline.cjsj)
            }}</i>
          </td>
          <td style="position: relative; left: -155px">
            状态<i style="margin-left: 30px; font-weight: bold">{{
              formInline.zt ? "启用" : "停用"
            }}</i>
          </td>
        </tr>
        <tr>
          <td>
            创建人<i style="margin-left: 60px; color: #999999">{{
              formInline.cjr
            }}</i>
          </td>
          <td style="position: relative; left: -55px">
            更新日期<i style="margin-left: 30px; color: #999999">{{
              filterTime(formInline.gxsj)
            }}</i>
          </td>
          <td style="position: relative; left: -155px">
            单位<i style="margin-left: 30px; color: #999999">{{
              formInline.mc
            }}</i>
          </td>
        </tr>
        <tr>
          <td>
            更新人<i style="margin-left: 60px; color: #999999">{{
              formInline.gxr
            }}</i>
          </td>
          <td style="position: relative; left: -55px">
            备注<i style="margin-left: 65px; color: #999999">{{
              formInline.bei
            }}</i>
          </td>
        </tr>
        <tr>
          <td>
            规格型号<i style="margin-left: 50px; color: #999999">{{
              formInline.gys
            }}</i>
          </td>
        </tr>
      </table>
    </div>

    <div id="addxxgty">
      <el-tabs id="menu" v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="库存信息" name="first" style="margin-top: -10px">
          <el-button id="tex9" icon="el-icon-download" @click="exportRow1()"
            >导出</el-button
          >
          <el-table
            tooltip-effect="dark"
            :data="tableData4"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',

              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
            height="300px"
          >
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column label="序号" type="index" width="84">
            </el-table-column>
            <el-table-column prop="ware_code" label="仓库名称" width="200">
            </el-table-column>

            <!-- <el-table-column label="进货日期" width="300">
                            <template slot-scope='scope'>
                                <span v-if="scope.row.buy_date != '0001-01-01T00:00:00'">{{ filterTime(scope.row.buy_date)
                                }}</span>
                                <span v-else></span>

                            </template>
                        </el-table-column> -->
            <el-table-column prop="inbill3_num" label="当前库存" width="200">
            </el-table-column>

            <el-table-column prop="jin" label="库存金额" width="200">
            </el-table-column>
            <el-table-column prop="ru" label="待入库" width="170">
            </el-table-column>
            <el-table-column prop="cu" label="待出库" width="170">
            </el-table-column>
            <!-- <el-table-column label="制单时间" width="300">
                            <template slot-scope='scope'>
                                <span v-if="scope.row.create_time != '0001-01-01T00:00:00'">{{
                                    filterTime(scope.row.create_time)
                                }}</span>
                                <span v-else></span>
                            </template>
                        </el-table-column> -->

            <!-- <el-table-column label="审核时间" width="300">
                            <template slot-scope='scope'>
                                <span v-if="scope.row.sure_date != '0001-01-01T00:00:00'">{{ filterTime(scope.row.sure_date)
                                }}</span>
                                <span v-else></span>
                            </template>
                        </el-table-column> -->
          </el-table>
          <div
            style="
              border: 1px solid #eeeeee;
              width: 1078px;
              height: 45px;
              display: inline-block;
              margin-left: 2px;
            "
          >
            <p style="float: right">
              <span style="line-height: 45px; font-size: 14px">当前库存：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 35px;
                "
                id="k1"
              ></span>
              <span style="line-height: 45px; font-size: 14px">库存金额：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 35px;
                "
                id="k2"
              ></span>
              <span style="line-height: 45px; font-size: 14px">待入库：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 35px;
                "
                id="k3"
              ></span>
              <span style="line-height: 45px; font-size: 14px">待出库：</span>
              <span
                style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 14px;
                  margin-right: 35px;
                "
                id="k4"
              ></span>
            </p>
          </div>
          <!-- 分页 -->
          <!-- <el-pagination id="fenye" @size-change="handleSizeChange" @current-change="handleCurrentChange"
                        :current-page="currentPage" :page-sizes="[4, 8, 12, 16]" :page-size="pagesize"
                        layout="total, sizes, prev, pager, next, jumper" :total="rows">
                    </el-pagination> -->
        </el-tab-pane>
        <!-- <el-tab-pane label="入库记录" style="margin-top: -10px;">
                    <el-button id="tex9" icon="el-icon-download">导出</el-button>
                    <el-table tooltip-effect="dark" @selection-change="handleSelectionChange" :data="tableData"
                        :header-cell-style="{
                            background: '#F8F8F9',
                            color: '#606266',
                            'text-align': 'center',
                        }" :cell-style="{ 'text-align': 'center' }" id="jhmx" height="300px">
                        <el-table-column type="selection" width="55"> </el-table-column>
                        <el-table-column label="序号" type="index" width="50">
                        </el-table-column>
                        <el-table-column prop="item_name" label="货品名称" width="100">
                        </el-table-column>
                        <el-table-column prop="item_code" label="货品编号" width="100">
                        </el-table-column>
                        <el-table-column prop="model_code" label="规格型号" width="100">
                        </el-table-column>
                        <el-table-column prop="unit" label="单位" width="115px">
                        </el-table-column>
                        <el-table-column prop="area_code" label="入库仓位" width="100">
                        </el-table-column>
                        <el-table-column prop="buy_price" label="入库单价" width="100">
                        </el-table-column>
                        <el-table-column prop="inbill_num" label="入库数量" width="100">
                        </el-table-column>
                        <el-table-column prop="zong" label="入库金额" width="100">

                        </el-table-column>
                        <el-table-column prop="batch_no" label="批次号" width="100">
                        </el-table-column>
                        <el-table-column prop="remark" label="备注" width="180">
                        </el-table-column>
                    </el-table>
                    <div id="hj">
                        <span style="line-height: 45px; font-size: 12px; margin-left: 25px">合计</span>
                        <p style="float: right">
                            <span style="line-height: 45px; font-size: 12px">入库数量：</span>
                            <span style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 12px;
                  margin-right: 35px;
                ">{{ yrksl }}</span>
                            <span style="line-height: 45px; font-size: 12px">入库金额：</span>
                            <span style="
                  line-height: 45px;
                  font-weight: bold;
                  color: red;
                  font-size: 12px;
                  margin-right: 30px;
                " id="sumSalary">{{ zje }}￥</span>
                        </p>
                    </div>
                </el-tab-pane> -->
        <!-- <el-tab-pane label="操作记录" name="second">
                    <el-button id="tex9" icon="el-icon-download">导出</el-button>
                  
                 
                </el-tab-pane> -->
        <el-tab-pane label="进货记录" name="third1">
          <el-button id="tex9" icon="el-icon-download" @click="exportRow()"
            >导出</el-button
          >
          <el-table
            tooltip-effect="dark"
            :data="tableData3"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',

              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
            height="300px"
          >
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column label="序号" type="index" width="70">
            </el-table-column>
            <el-table-column prop="buy_code" label="进货单号" width="130">
            </el-table-column>

            <el-table-column label="进货日期" width="130">
              <template slot-scope="scope">
                <span v-if="scope.row.buy_date != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.buy_date)
                }}</span>
                <span v-else></span>
              </template>
            </el-table-column>
            <el-table-column prop="supply_code" label="供应商" width="130">
            </el-table-column>
            <el-table-column prop="link_man" label="联系人" width="130">
            </el-table-column>
            <el-table-column prop="link_way" label="联系方式" width="130">
            </el-table-column>
            <el-table-column prop="buy_man" label="进货人" width="130">
            </el-table-column>
            <el-table-column prop="buy_man" label="进货人" width="130">
            </el-table-column>
            <el-table-column prop="total_buy_num" label="货品数量" width="130">
            </el-table-column>
            <el-table-column prop="total_price" label="货品金额" width="130">
            </el-table-column>
            <el-table-column prop="create_by" label="制单人" width="130">
            </el-table-column>
            <el-table-column label="制单时间" width="150">
              <template slot-scope="scope">
                <span v-if="scope.row.create_time != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.create_time)
                }}</span>
                <span v-else></span>
              </template>
            </el-table-column>
            <el-table-column prop="sure_man" label="审核人" width="130">
            </el-table-column>
            <el-table-column label="审核时间" width="130">
              <template slot-scope="scope">
                <span v-if="scope.row.sure_date != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.sure_date)
                }}</span>
                <span v-else></span>
              </template>
            </el-table-column>
          </el-table>

          <!-- 分页 -->
          <!-- <el-pagination id="fenye" @size-change="handleSizeChange" @current-change="handleCurrentChange"
                        :current-page="currentPage" :page-sizes="[4, 8, 12, 16]" :page-size="pagesize"
                        layout="total, sizes, prev, pager, next, jumper" :total="rows">
                    </el-pagination> -->
        </el-tab-pane>
        <el-tab-pane label="盘点记录" name="third8" style="margin-top: -10px">
          <el-button id="tex9" icon="el-icon-download" @click="exportRow()"
            >导出</el-button
          >
          <el-table
            tooltip-effect="dark"
            :data="tableDatapd"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',

              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
            height="300px"
          >
            <el-table-column
              fixed
              prop="outbill_code"
              label="盘点单号"
              width="150"
            >
              <template slot-scope="{ row }">
                <router-link
                  :to="{ name: '', query: { dh: row.inventory_code } }"
                  style="color: #9c27b0"
                  >{{ row.inventory_code }}</router-link
                >
              </template>
            </el-table-column>
            <el-table-column fixed label="盘点结果" width="120">
              <template slot-scope="scope">
                <span>{{ zt(scope.row.zt) }}</span>
              </template>
            </el-table-column>
            <el-table-column fixed label="状态" width="120">
              <template slot-scope="scope">
                <span
                  v-if="scope.row.sure_state == 0"
                  style="color: blue; font-weight: 600; font-size: 13px"
                  >待审核</span
                >
                <span
                  v-if="scope.row.sure_state == 1"
                  style="color: red; font-weight: 600; font-size: 13px"
                  >驳回</span
                >
                <span
                  v-if="scope.row.sure_state == 2"
                  style="color: green; font-weight: 600; font-size: 13px"
                  >已完成</span
                >
              </template>
            </el-table-column>
            <el-table-column prop="ware_code" label="仓库名称" width="120">
            </el-table-column>
            <el-table-column prop="inventory_type" label="盘点类型" width="120">
            </el-table-column>
            <el-table-column label="盘点开始时间" width="180">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.begin_date) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="盘点结束时间" width="180">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.end_date) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="total_buy_num" label="盘点数量" width="120">
            </el-table-column>
            <el-table-column label="盘盈数量" width="120">
              <template slot-scope="scope">
                <span style="color: green">{{ scope.row.total_y_num }}</span>
              </template>
            </el-table-column>
            <el-table-column label="盘亏数量" width="120">
              <template slot-scope="scope">
                <span style="color: red">{{ scope.row.total_k_num }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="total_price" label="盘点金额" width="120">
            </el-table-column>
            <el-table-column label="盘盈金额" width="120">
              <template slot-scope="scope">
                <span style="color: green">{{ scope.row.total_y_price }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="" label="盘亏金额" width="120">
              <template slot-scope="scope">
                <span style="color: red">{{ scope.row.total_k_price }}</span>
              </template>
            </el-table-column>

            <el-table-column prop="create_by" label="制单人" width="120">
            </el-table-column>
            <el-table-column label="制单时间" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.create_time) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="sure_man" label="经办人" width="120">
            </el-table-column>

            <el-table-column label="审核时间" width="150">
              <template slot-scope="scope">
                <span v-if="scope.row.sure_date != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.sure_date)
                }}</span>
                <span v-else></span>
              </template>
            </el-table-column>
          </el-table>

          <!-- 分页 -->
          <el-pagination
            id="fenye"
            @size-change="handleSizeChange1"
            @current-change="handleCurrentChange1"
            :current-page="currentPage1"
            :page-sizes="[4, 8, 12, 16]"
            :page-size="pagesize1"
            layout="total, sizes, prev, pager, next, jumper"
            :total="rows1"
          >
          </el-pagination>
        </el-tab-pane>
        <el-tab-pane label="调拨记录" name="third12" style="margin-top: -10px">
          <el-button id="tex9" icon="el-icon-download" @click="exportRow()"
            >导出</el-button
          >
          <el-table
            tooltip-effect="dark"
            :data="tableDatadb"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',

              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
            height="300px"
          >
            <el-table-column fixed label="调拨单号" width="150">
              <template slot-scope="{ row }">
                <router-link
                  :to="{ name: '', query: { dh: row.transfer_code } }"
                  style="color: #9c27b0"
                  >{{ row.transfer_code }}</router-link
                >
              </template>
            </el-table-column>

            <el-table-column fixed label="单据状态" width="120">
              <template slot-scope="scope">
                <span
                  v-if="scope.row.sure_state == 0"
                  style="color: blue; font-weight: 600; font-size: 13px"
                  >待审核</span
                >
                <span
                  v-if="scope.row.sure_state == 1"
                  style="color: red; font-weight: 600; font-size: 13px"
                  >驳回</span
                >
                <span
                  v-if="scope.row.sure_state == 2"
                  style="color: green; font-weight: 600; font-size: 13px"
                  >已完成</span
                >
              </template>
            </el-table-column>
            <el-table-column label="调拨申请日期" width="180">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.transfer_date) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="out_warecode" label="调出仓库" width="120">
            </el-table-column>
            <el-table-column prop="in_warecode" label="调入仓库" width="120">
            </el-table-column>
            <el-table-column label="出库状态" width="120">
              <template slot-scope="scope">
                <span v-if="scope.row.outware_state == 2">未出库</span>

                <span v-if="scope.row.outware_state == 3">已出库</span>
              </template>
            </el-table-column>
            <el-table-column label="入库状态" width="120">
              <template slot-scope="scope">
                <span v-if="scope.row.inware_state == 0">未入库</span>

                <span v-if="scope.row.inware_state == 1">已入库</span>
              </template>
            </el-table-column>

            <el-table-column prop="total_buy_num" label="调拨数量" width="120">
            </el-table-column>
            <el-table-column prop="total_price" label="调拨金额" width="120">
            </el-table-column>

            <el-table-column prop="create_by" label="制单人" width="120">
            </el-table-column>
            <el-table-column label="制单时间" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.create_time) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="sure_man" label="经办人" width="120">
            </el-table-column>

            <el-table-column label="审核时间" width="150">
              <template slot-scope="scope">
                <span v-if="scope.row.sure_date != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.sure_date)
                }}</span>
                <span v-else></span>
              </template>
            </el-table-column>
          </el-table>

          <!-- 分页 -->
          <!-- <el-pagination id="fenye" @size-change="handleSizeChange2" @current-change="handleCurrentChange2"
                            :current-page="currentPage2" :page-sizes="[4, 8, 12, 16]" :page-size="pagesize2"
                            layout="total, sizes, prev, pager, next, jumper" :total="rows2">
                        </el-pagination> -->
        </el-tab-pane>
        <el-tab-pane label="销售记录" name="third122" style="margin-top: -10px">
          <el-button id="tex9" icon="el-icon-download" @click="exportRow()"
            >导出</el-button
          >
          <el-table
            tooltip-effect="dark"
            :data="tableDatajl"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',

              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
            height="300px"
          >
            <el-table-column fixed prop="" label="销售单号" width="150">
              <template slot-scope="scope">
                <a
                  href="javascript:void(0)"
                  style="color: #9c27b0"
                  v-on:click="jhdh(scope.row.sale_code)"
                  >{{ scope.row.sale_code }}</a
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
                  v-if="scope.row.sale_state > 1"
                  style="color: Green; font-weight: 600; font-size: 13px"
                  >通过</span
                >
              </template>
            </el-table-column>
            <el-table-column fixed label="销售日期" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.sale_date) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="cust_code" label="客户名称" width="120">
            </el-table-column>
            <el-table-column prop="link_man" label="联系人" width="120">
            </el-table-column>
            <el-table-column prop="link_way" label="联系方式" width="120">
            </el-table-column>
            <el-table-column
              prop="sale_duty_man"
              label="销售负责人"
              width="120"
            >
            </el-table-column>
            <el-table-column prop="total_buy_num" label="销售数量" width="120">
            </el-table-column>
            <el-table-column prop="total_price" label="销售金额" width="120">
            </el-table-column>
            <el-table-column
              prop="names"
              :show-overflow-tooltip="true"
              label="销售货品"
              width="120"
            >
            </el-table-column>
            <el-table-column prop="create_by" label="制单人" width="120">
            </el-table-column>
            <el-table-column label="制单时间" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.create_time) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="sure_man" label="审核人" width="120">
            </el-table-column>

            <el-table-column label="审核时间" width="150">
              <template slot-scope="scope">
                <span v-if="scope.row.sure_date != '0001-01-01T00:00:00'">{{
                  filterTime(scope.row.sure_date)
                }}</span>
                <span v-else></span>
              </template>
            </el-table-column>
          </el-table>

          <!-- 分页 -->
          <el-pagination
            id="fenye"
            @size-change="handleSizeChange2"
            @current-change="handleCurrentChange2"
            :current-page="currentPage2"
            :page-sizes="[3, 6, 9, 12]"
            :page-size="pagesize2"
            layout="total, sizes, prev, pager, next, jumper"
            :total="rows2"
          >
          </el-pagination>
        </el-tab-pane>
        <el-tab-pane label="入库记录" name="thirdrk" style="margin-top: -10px">
          <el-button id="tex9" icon="el-icon-download" @click="exportRow()"
            >导出</el-button
          >
          <el-table
            tooltip-effect="dark"
            :data="tableDatark"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',

              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
            height="300px"
          >
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column label="序号" type="index" width="70">
            </el-table-column>

            <el-table-column prop="inbill_code" label="入库单号" width="120">
            </el-table-column>
            <el-table-column prop="inbill_type" label="入库类型" width="103">
            </el-table-column>
            <el-table-column label="入库日期" width="150">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.create_time) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="ware_name" label="仓库名称" width="120">
            </el-table-column>
            <el-table-column prop="inbill_num" label="入库数量" width="100">
            </el-table-column>
            <el-table-column prop="zong" label="入库金额" width="120">
            </el-table-column>
            <el-table-column prop="sure_man" label="经办人" width="120">
            </el-table-column>
            <el-table-column prop="create_by" label="制单人" width="120">
            </el-table-column>
          </el-table>
          <!-- 分页 -->
          <el-pagination
            id="fenye"
            @size-change="handleSizeChangerk"
            @current-change="handleCurrentChangerk"
            :current-page="currentPagerk"
            :page-sizes="[6, 12, 18, 24]"
            :page-size="pagesizerk"
            layout="total, sizes, prev, pager, next, jumper"
            :total="rowsrk"
          >
          </el-pagination>
        </el-tab-pane>

        <el-tab-pane label="出库记录" name="thirdck" style="margin-top: -10px">
          <el-button id="tex9" icon="el-icon-download" @click="exportRow()"
            >导出</el-button
          >
          <el-table
            tooltip-effect="dark"
            :data="tableDatack"
            :header-cell-style="{
              background: '#F8F8F9',
              color: '#606266',

              'text-align': 'center',
            }"
            :cell-style="{ 'text-align': 'center' }"
            id="jhmx"
            height="300px"
          >
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column label="序号" type="index" width="70">
            </el-table-column>

            <el-table-column prop="outbill_code" label="出库单号" width="100">
            </el-table-column>
            <el-table-column prop="outbill_type" label="出库类型" width="100">
            </el-table-column>
            <el-table-column label="出库日期" width="130">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.outbill_date) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="ware_code" label="仓库名称" width="95">
            </el-table-column>
            <el-table-column prop="outbill_num" label="出库数量" width="99">
            </el-table-column>
            <el-table-column prop="zong" label="出库金额" width="100">
            </el-table-column>
            <el-table-column prop="sure_man" label="经办人" width="100">
            </el-table-column>

            <el-table-column prop="create_by" label="制单人" width="100">
            </el-table-column>
            <el-table-column label="制单时间" width="130">
              <template slot-scope="scope">
                <span>{{ filterTime(scope.row.create_time) }}</span>
              </template>
            </el-table-column>
          </el-table>
          <!-- 分页 -->
          <el-pagination
            id="fenye"
            @size-change="handleSizeChangeck"
            @current-change="handleCurrentChangeck"
            :current-page="currentPageck"
            :page-sizes="[4, 8, 12, 16]"
            :page-size="pagesizeck"
            layout="total, sizes, prev, pager, next, jumper"
            :total="rowsck"
          >
          </el-pagination>
        </el-tab-pane>
      </el-tabs>
    </div>
    <div id="notification-container">
      <div id="dibu">
        <el-button id="bcccc" @click="gb()">关闭</el-button>
      </div>
    </div>
  </div>
</template>

<script>
import $http from "@/http/base";
import axios from "axios";
export function formatDate(date) {
  let time = new Date(date);

  let year = time.getFullYear();

  let month = time.getMonth() + 1;
  month = month.toString().padStart(2, "0");
  let day = time.getDate().toString().padStart(2, "0");
  return year + "年" + month + "月" + day + "日";
}
export default {
  data() {
    return {
      activeIndex: "1",

      formInline: {
        dh: "",
        lx: "",
        mc: "",
        date: "",
        bei: "",
        lxr: "",
        fs: "",
        gldh: "",
        gys: "",
        sj: "",
        zt: "",
        rk: "",
        ck: "",
        cjr: "",
        cjsj: "",
        gxr: "",
        gxsj: "",
        px: "",
      },
      tableData: [],
      tableData1: [],
      tableData2: [],
      tableData3: [],
      tableData4: [],
      tableDatapd: [],
      tableDatadb: [],
      tableDatajl: [],
      tableDatark: [],
      tableDatack: [],
      Imager: [],
      ii: "",
      currentPage: 1, //当前页,
      pagesize1: 4,
      currentPagerk: 1, //当前页,
      pagesizerk: 6,
      pagesize2: 3,
      currentPage2: 1, //当前页,
      currentPage1: 1,
      pagesize: 4, //每页显示数
      currentPageck: 1,
      pagesizeck: 4, //每页显示数
      rows: 0, //总行数
      rows1: 0,
      rows2: 0,
      rowsrk: 0,
      rowsck: 0,
      str: " 1=1 ",
      str2: "1=1",
      str3: "1=1",
      stxrsff: "1=1",
      strrk: "1=1",
      strck: "1=1",
      multipleSelection: [],
      yrksl: 0,
      zje: 0,
      activeName: "first",
    };
  },
  methods: {
    //每页显示数改变事件
    handleSizeChange(size) {
      this.pagesize = size;
      this.currentPage = 1;
      this.FenYe();
      this.find();
    },
    handleSizeChange1(size) {
      this.pagesize1 = size;
      this.currentPage1 = 1;
      this.FenYe();
      this.find();
    },

    //页码改变事件
    handleCurrentChange(page) {
      this.currentPage = page;
      this.FenYe();
      this.find();
    },
    handleCurrentChange1(page) {
      this.currentPage1 = page;
      this.FenYe();
      this.find();
    },
    FenYe() {
      var id = this.$route.query.dh;
      console.log(id);
      $http
        .get("http://localhost:5149/api/Bs_item/FindGoodsIfoByItem_Id?id=" + id)
        .then((res) => {
          this.formInline.lx = res.item_type_name;
          this.formInline.dh = res.item_code;
          this.formInline.ck = res.outbill_price;
          this.formInline.rk = res.inbill_price;
          this.formInline.cjr = res.create_by;
          this.formInline.cjsj = res.create_time;
          this.formInline.gxr = res.update_by;
          this.formInline.gxsj = res.update_time;
          this.formInline.zt = res.inbill_state;
          this.formInline.gys = res.model_code;
          this.formInline.mc = res.unit;
          this.formInline.bei = res.remark;
          // debugger;
          console.log(res);
          //  this.Imager = res.imgUrl;
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

          // var imgUrlArray = imgUrls.split(",");
          // for (let index = 0; index < imgUrlArray.length; index++) {
          //     const element = imgUrlArray[index];
          //     this.Imager.push("http://localhost:5149/api/images/" + element);
          // }
          console.log(this.Imager);
        });
    },
    //关闭
    gb() {
      this.$router.go(-1);
    },
    //导出
    exportRow() {
      const apiUrl = "http://localhost:5149/api/Export";
      const dummyData = this.tableData3.map((item) => ({
        ...item,
        sure_man: item.sure_man || "null",
        update_by: item.update_by || "null",
        sure_state: item.sure_state || "null",
      }));
      console.log(dummyData);
      $http
        .post(apiUrl, dummyData)
        .then((response) => {
          console.log(response);
          // Handle the response, for example, download the exported file
          this.downloadFile(response, "exportedData.csv");
        })
        .catch((error) => {
          alert("导出失败");
          console.error("Export failed", error);
        });
    },
    downloadFile(data, fileName) {
      const blob = new Blob([data], { type: "application/octet-stream" });
      const link = document.createElement("a");
      link.href = window.URL.createObjectURL(blob);
      link.download = fileName;
      link.click();
    },
    fzcg() {
      this.$message({
        message: "复制成功",
        type: "success",
      });
    },
    //下标
    handleSelect(key, keyPath) {
      console.log(key, keyPath);
    },
    //选择
    handleSelectionChange(val) {
      this.multipleSelection = val;
      console.log(this.multipleSelection);
    },
    //根据id查进货订单
    Jia() {
      var bh = this.$route.query.dh;

      // $http
      //     .get("  http://localhost:5149/api/Wh_inbill_h/Wh_inbill_hMH?bh=" + bh)
      //     .then(res => {

      //         this.formInline.dh = res.inbill_bh;
      //         this.formInline.gldh = res.buy_code;
      //         this.formInline.lx = res.inbill_type;
      //         this.formInline.mc = res.ware_name;
      //         this.formInline.date = res.inbll_date;
      //         this.formInline.bei = res.remark;
      //         this.formInline.lxr = res.link_man;
      //         this.formInline.fs = res.link_way;
      //         this.formInline.gys = res.supply_code;
      //         this.formInline.jbr = res.inbill_duty_man;
      //         this.formInline.sj = res.create_time;
      //         this.formInline.zt = res.inbill_state;
      //         this.ii = res.inbill_id;

      //     })
      //     .catch(err => {
      //         alert(err);
      //     });
    },

    //进货明细
    find() {
      var item_code = this.$route.query.item_code;
      $http
        .get(
          "http://localhost:5149/api/Bs_item/FindPurchaseRecord?item_code=" +
            item_code
        )
        .then((res) => {
          this.tableData3 = res;
          console.log(res);
        });
      //库存信息
      this.str = "item_code='" + item_code + "'";
      $http
        .post(
          "http://localhost:5149/api/Wh_transfer_h/KuFen?page=" +
            this.pagesize +
            "&pageSize=" +
            this.currentPage +
            "&str=" +
            this.str +
            ""
        )
        .then((res) => {
          this.tableData4 = res.list;
          this.rows = res.rows;
          var k1 = 0;
          var k2 = 0;
          var k3 = 0;
          var k4 = 0;

          for (let i = 0; i < this.tableData4.length; i++) {
            k1 += this.tableData4[i].inbill3_num;
            k2 += this.tableData4[i].jin;
            k3 += this.tableData4[i].ru;
            k4 += this.tableData4[i].cu;
          }
          document.getElementById("k1").innerHTML = k1;
          document.getElementById("k2").innerHTML = k2;
          document.getElementById("k3").innerHTML = k3;
          document.getElementById("k4").innerHTML = k4;
          console.log(res);
        });
      //盘点记录
      this.str2 = "item_code='" + item_code + "'";
      $http
        .get("http://localhost:5149/api/Bs_item/FindInventoryRecords", {
          params: {
            PageSize: this.pagesize1,
            CurrentPage: this.currentPage1,
            str: this.str2,
          },
        })
        .then((res) => {
          this.tableDatapd = res.list;
          this.rows1 = res.rows;
          console.log(res);
        });

      //调拨记录
      this.str3 = "item_code='" + item_code + "'";
      $http
        .get("http://localhost:5149/api/Bs_item/FindTransferRecords", {
          params: {
            PageSize: 5,
            CurrentPage: 1,
            str: this.str3,
          },
        })
        .then((res) => {
          this.tableDatadb = res.list;
          this.rows1 = res.rows;
          console.log(res);
        });

      //var bh = this.$route.query.dh
      // $http
      //     .get("  http://localhost:5149/api/Wh_inbill_h/Wh_inbill_dMH?bh=" + bh)
      //     .then(res => {
      //         this.tableData = res;
      //         for (let i = 0; i < this.tableData.length; i++) {
      //             this.yrksl += this.tableData[i].inbill_num;
      //             this.zje +=
      //                 this.tableData[i].zong;

      //         }

      //     })
      //     .catch(err => {
      //         alert(err);
      //     });
    },
    //销售记录方法
    xsff() {
      var item_code = this.$route.query.item_code;
      this.strxsff = "item_code='" + item_code + "'";
      $http
        .get("http://localhost:5149/api/Bs_item/FindXiaoshouJl", {
          params: {
            //?PageSize=1 & CurrentPage=1& str=1% 3D1% 20AND% 20item_code % 3D % 271 % 27
            PageSize: this.pagesize2,
            CurrentPage: this.currentPage2,
            str: this.strxsff,
          },
        })
        .then((res) => {
          this.tableDatajl = res.list;
          this.rows2 = res.rows;
        });
    },
    //入库记录
    rkjl() {
      var item_code = this.$route.query.item_code;
      this.strrk = "item_code='" + item_code + "'";
      $http
        .get("http://localhost:5149/api/Bs_item/FindRkst", {
          params: {
            PageSize: this.pagesizerk,
            CurrentPage: this.currentPagerk,
            str: this.strrk,
          },
        })
        .then((res) => {
          console.log(res);
          this.tableDatark = res.list;
          this.rowsrk = res.rows;
        });
    },
    //出库记录
    ckjl() {
      var item_code = this.$route.query.item_code;
      this.strck = "item_code='" + item_code + "'";
      $http
        .get("http://localhost:5149/api/Bs_item/FindCkSt", {
          params: {
            PageSize: this.pagesizeck,
            CurrentPage: this.currentPageck,
            str: this.strck,
          },
        })
        .then((res) => {
          console.log(res);
          this.tableDatack = res.list;
          this.rowsck = res.rows;
        });
    },
    zt(i) {
      if (i == 0) return "无盈亏";
      if (i == 1) return "有盈亏";
    },
    handleSizeChange2(size) {
      this.pagesize2 = size;
      this.currentPage2 = 1;
      this.xsff();
    },

    //页码改变事件
    handleCurrentChange2(page) {
      this.currentPage2 = page;
      this.xsff();
    },
    handleSizeChangerk(size) {
      this.pagesizerk = size;
      this.currentPagerk = 1;
      this.rkjl();
    },

    //页码改变事件
    handleCurrentChangerk(page) {
      this.currentPagerk = page;
      this.rkjl();
    },
    handleSizeChangeck(size) {
      this.pagesizeck = size;
      this.currentPageck = 1;
      this.ckjl();
    },

    //页码改变事件
    handleCurrentChangeck(page) {
      this.currentPageck = page;
      this.ckjl();
    },
    //时间格式化
    filterTime(timestamp) {
      return formatDate(timestamp);
    },
    handleClick(tab, event) {
      console.log(tab, event);
    },
  },
  mounted() {
    this.Jia();
    this.find();
    this.FenYe();
    this.xsff();
    this.rkjl();
    this.ckjl();
  },
};
</script>
<style src="../CSS/public.css"></style>
<style scoped>
.block {
  height: 260px;
  margin-top: 20px;
  margin-left: 35px;
  width: 290px;
}
.el-carousel__item h3 {
  color: #475669;
  font-size: 14px;
  opacity: 0.75;
  line-height: 150px;
  margin: 0;
}

.el-carousel__item:nth-child(2n) {
  background-color: #99a9bf;
}

.el-carousel__item:nth-child(2n + 1) {
  background-color: #d3dce6;
}
#hj {
  border: 1px solid #eeeeee;
  width: 1080px;
  height: 45px;
  margin-left: 2px;
  display: inline-block;
}
.red-text {
  color: red;
}
.el-tabs__item {
  padding: 0 20px;
  height: 50px !important;
  box-sizing: border-box;
  line-height: 50px !important;
  display: inline-block;
  list-style: none;
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  position: relative;
}

#menu {
  position: relative;
  left: 30px;
  width: 1085px;
}

#jhmx {
  width: 1080px !important;
  margin-top: 25px;
  margin-left: 2px;
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

#bcccc {
  width: 28px !important;
  color: #fff;
  background-color: #9c27b0;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 115px;
}

#addsdh {
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 350px;
}

#addxxgty {
  margin-top: 20px;
  border-radius: 5px;
  background-color: #fff;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
  width: 1150px;
  height: 580px;
}

#tex9 {
  border: 1px solid #fae4a2;
  color: #f8c341;
  background-color: #fef8e8;
  width: 28px !important;
  line-height: 28px !important;
  width: 73px !important;
  padding: 0px !important;
  margin-left: 2px;
  margin-top: 25px;
}

#tex9:hover {
  background-color: #f5bd41;
  color: #fff;
}
.el-carousel__item h3 {
  color: #475669;
  font-size: 14px;
  opacity: 0.75;
  line-height: 150px;
  margin: 0;
}

.el-carousel__item:nth-child(2n) {
  background-color: #99a9bf;
}

.el-carousel__item:nth-child(2n + 1) {
  background-color: #d3dce6;
}
</style>