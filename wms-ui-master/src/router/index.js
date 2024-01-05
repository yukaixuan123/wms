
import Vue from 'vue';
import Router from 'vue-router'
Vue.use(Router);

import Login from '@/components/Login.vue';//登录
import Main from '@/components/Main.vue';//主页面
import HelloWorld from '@/components/HelloWorld.vue'//欢迎页面
import Home from '@/components/Home.vue'//首页
import GoodsMessage from '@/components/GoodsMessage.vue'//货品信息
import GoodsType from '@/components/GoodsType.vue'//货品类型
import Wh_inbill_h from '@/components/Wh_inbill_h.vue'//入库管理
import AddWh_inbill_h from '@/components/AddWh_inbill_h.vue'//新增入库管理
import UpdateWh_inbill_h from '@/components/UpdateWh_inbill_h.vue'//修改入库管理
import DetailedWh_inbill_h from '@/components/DetailedWh_inbill_h.vue'//详细入库管理
import Wh_outbill_h from '@/components/Wh_outbill_h.vue'//出库管理
import AddWh_outbill_h from '@/components/AddWh_outbill_h.vue'//新增出库管理
import UpdateWh_outbill_h from '@/components/UpdateWh_outbill_h.vue'//修改出库管理
import DetailedWh_outbill_h from '@/components/DetailedWh_outbill_h.vue'//详细入库管理
import Wh_inventory_h from '@/components/Wh_inventory_h.vue'//库存盘点
import AddWh_inventory_h from '@/components/AddWh_inventory_h.vue'//添加库存盘点
import UpdateWh_inventory_h from '@/components/UpdateWh_inventory_h.vue'//修改库存盘点
import DetaileWh_inventory_h from '@/components/DetaileWh_inventory_h.vue'//详细库存盘点
import Wh_transfer_h from '@/components/Wh_transfer_h.vue'//库存调拨
import AddWh_transfer_h from '@/components/AddWh_transfer_h.vue'//添加库存调拨
import UpdateWh_transfer_h from '@/components/UpdateWh_transfer_h.vue'//添加库存调拨
import DetaileWh_transfer_h from '@/components/DetaileWh_transfer_h.vue'//详细库存调拨

import Users from '@/components/Users.vue' //用户管理
import CodingRule from '@/components/CodingRule.vue' //用户管理
import Roles from '@/components/Roles.vue'//用户管理
import Purview from '@/components/Purview.vue' //菜单管理
import DictionaryManage from '@/components/DictionaryManage.vue'; //字典管理
import DictionaryData from '@/components/DictionaryData.vue'; //字典数据

import IncomingOrders from '@/components/IncomingOrders'//进货订单
import IncomingOrdersAdd from '@/components/IncomingOrdersAdd.vue'//进货订单添加
import IncomingOrdersCode from '@/components/IncomingOrdersCode.vue'//进货订单明细
import IncomingOrdersUpdate from '@/components/IncomingOrdersUpdate.vue'//进货订单修改
import ReturnedGoods from '@/components/ReturnedGoods'//进货退货
import ReturnedGoodsAdd from '@/components/ReturnedGoodsAdd'//进货退货添加
import ReturnedGoodsUpdate from '@/components/ReturnedGoodsUpdate'//进货退货修改
import ReturnedGoodsCode from '@/components/ReturnedGoodsCode'//退货订单明细
import ReturnedGoodsTH from '@/components/ReturnedGoodsTH'//进货退货出库


import SalesOrders from '@/components/SalesOrders'//销售订单
import SalesOrdersAdd from '@/components/SalesOrdersAdd'//销售订单添加
import SalesOrdersUpdate from '@/components/SalesOrdersUpdate'//销售订单修改
import SalesOrdersCode from '@/components/SalesOrdersCode'//销售订单明细
import SalesReturns from '@/components/SalesReturns'//销售退货
import SalesReturnsAdd from '@/components/SalesReturnsAdd'//销售退货添加
import SalesReturnsUpdate from '@/components/SalesReturnsUpdate'//销售退货修改
import SalesReturnsCode from '@/components/SalesReturnsCode'//销售退货明细
import StockInquire from '@/components/StockInquire'//库存查询
import StockInquireCode from '@/components/StockInquireCode'//库存分布
import StockInquireCode1 from '@/components/StockInquireCode1'//出入库流水
import SalesReturnsTH from '@/components/SalesReturnsTH.vue'; //销售退货入库


import AddGoodsInfo from '@/components/AddGoodsInfo.vue'; //新增货品信息
import UpdateGoodsInfo from '@/components/UpdateGoodsInfo.vue'; //修改货品信息
import DetailedGoodsInfo from '@/components/DetailedGoodsInfo.vue'; //编号查询货品信息


import Supplier from '@/components/Supplier.vue'//供应商
import Customer from '@/components/Customer.vue'//客户
import SupplyInsert from '@/components/SupplyInsert.vue'//供应商添加
import CustomerInsert from '@/components/CustomerInsert.vue'//客户添加
import SupplyUpdate from '@/components/SupplyUpdate.vue'//供应商修改
import CustomerUpdate from '@/components/CustomerUpdate.vue'//客户修改
import WareHouse from '@/components/WareHouse.vue'//仓库管理
import WareArea from '@/components/WareArea.vue'//库位管理
import supplyXiang from '@/components/supplyXiang.vue'//供应商详情
import CustomerXiang from '@/components/CustomerXiang.vue'//客户详情
import WareHouseXiang from '@/components/WareHouseXiang.vue'//仓库详情

import ProjectBackground from '@/components/ProjectBackground.vue'//项目背景




const router = new Router({
    routes: [
        {
            name: 'Login',
            path: '/Login',
            component: Login
        }, {
            path: "/",
            redirect: "Login"
        },
        {
            name: "Main",
            path: "/Main",
            component: Main,
            children: [
                {
                    name: "HelloWorld",
                    path: "/HelloWorld",
                    component: HelloWorld
                },
                {
                    path: "/Main",
                    component: HelloWorld
                },
                {
                    name: "Home",
                    path: "/Home",
                    component: Home
                },
                {
                    name: "GoodsMessage",
                    path: "/GoodsMessage",
                    component: GoodsMessage
                },
                {
                    name: "StockInquireCode1",
                    path: "/StockInquireCode1",
                    component: StockInquireCode1,
                },
                {
                    name: "GoodsType",
                    path: "/GoodsType",
                    component: GoodsType
                },
                {
                    name: "Wh_inbill_h",
                    path: "/Wh_inbill_h",
                    component: Wh_inbill_h
                },
                {
                    name: "AddWh_inbill_h",
                    path: "/AddWh_inbill_h",
                    component: AddWh_inbill_h

                },
                {
                    name: "DetailedWh_inbill_h",
                    path: "/DetailedWh_inbill_h",
                    component: DetailedWh_inbill_h

                },
                {
                    name: "UpdateWh_inbill_h",
                    path: "/UpdateWh_inbill_h",
                    component: UpdateWh_inbill_h

                },
                {
                    name: "DetaileWh_inventory_h",
                    path: "/DetaileWh_inventory_h",
                    component: DetaileWh_inventory_h
                },
                {
                    name: "Wh_outbill_h",
                    path: "/Wh_outbill_h",
                    component: Wh_outbill_h
                },
                {
                    name: "AddWh_outbill_h",
                    path: "/AddWh_outbill_h",
                    component: AddWh_outbill_h
                },
                {
                    name: "UpdateWh_outbill_h",
                    path: "/UpdateWh_outbill_h",
                    component: UpdateWh_outbill_h
                },
                {
                    name: "DetailedWh_outbill_h",
                    path: "/DetailedWh_outbill_h",
                    component: DetailedWh_outbill_h
                },
                {
                    name: "Wh_inventory_h",
                    path: "/Wh_inventory_h",
                    component: Wh_inventory_h
                },
                {
                    name: "AddWh_inventory_h",
                    path: "/AddWh_inventory_h",
                    component: AddWh_inventory_h
                },
                {
                    name: "UpdateWh_inventory_h",
                    path: "/UpdateWh_inventory_h",
                    component: UpdateWh_inventory_h
                },
                {
                    name: "Wh_transfer_h",
                    path: "/Wh_transfer_h",
                    component: Wh_transfer_h
                },
                {
                    name: "AddWh_transfer_h",
                    path: "/AddWh_transfer_h",
                    component: AddWh_transfer_h
                },
                {
                    name: "UpdateWh_transfer_h",
                    path: "/UpdateWh_transfer_h",
                    component: UpdateWh_transfer_h
                },
                {
                    name: "DetaileWh_transfer_h",
                    path: "/DetaileWh_transfer_h",
                    component: DetaileWh_transfer_h
                },
                {
                    name: "Users",
                    path: "/Users",
                    component: Users
                },
                {
                    name: "CodingRule",
                    path: "/CodingRule",
                    component: CodingRule
                },
                {
                    name: "Roles",
                    path: "/Roles",
                    component: Roles
                }, {
                    name: "Purview",
                    path: "/Purview",
                    component: Purview
                }, {
                    name: "DictionaryManage",
                    path: "/DictionaryManage",
                    component: DictionaryManage
                }, {
                    name: "DictionaryData",
                    path: "/DictionaryData/:dict_id/:dict_label",
                    component: DictionaryData
                },
                {
                    name: "IncomingOrders",
                    path: "/IncomingOrders",
                    component: IncomingOrders
                },
                {
                    name: "IncomingOrdersAdd",
                    path: "/IncomingOrdersAdd",
                    component: IncomingOrdersAdd
                },
                {
                    name: "IncomingOrdersCode",
                    path: "/IncomingOrdersCode",
                    component: IncomingOrdersCode,
                },
                {
                    name: "IncomingOrdersUpdate",
                    path: "/IncomingOrdersUpdate",
                    component: IncomingOrdersUpdate,
                },
                {
                    name: "ReturnedGoods",
                    path: "/ReturnedGoods",
                    component: ReturnedGoods,
                },
                {
                    name: "ReturnedGoodsAdd",
                    path: "/ReturnedGoodsAdd",
                    component: ReturnedGoodsAdd,
                },
                {
                    name: "ReturnedGoodsUpdate",
                    path: "/ReturnedGoodsUpdate",
                    component: ReturnedGoodsUpdate,
                },
                {
                    name: "ReturnedGoodsCode",
                    path: "/ReturnedGoodsCode",
                    component: ReturnedGoodsCode,
                },
                {
                    name: "SalesOrders",
                    path: "/SalesOrders",
                    component: SalesOrders,
                },
                {
                    name: "SalesOrdersAdd",
                    path: "/SalesOrdersAdd",
                    component: SalesOrdersAdd,
                },
                {
                    name: "SalesOrdersUpdate",
                    path: "/SalesOrdersUpdate",
                    component: SalesOrdersUpdate,
                },
                {
                    name: "SalesOrdersCode",
                    path: "/SalesOrdersCode",
                    component: SalesOrdersCode,
                },
                {
                    name: "SalesReturns",
                    path: "/SalesReturns",
                    component: SalesReturns,
                },
                {
                    name: "SalesReturnsAdd",
                    path: "/SalesReturnsAdd",
                    component: SalesReturnsAdd,
                },
                {
                    name: "SalesReturnsUpdate",
                    path: "/SalesReturnsUpdate",
                    component: SalesReturnsUpdate,
                },
                {
                    name: "SalesReturnsCode",
                    path: "/SalesReturnsCode",
                    component: SalesReturnsCode,
                },
                {
                    name: "StockInquire",
                    path: "/StockInquire",
                    component: StockInquire,
                },
                {
                    name: "StockInquireCode",
                    path: "/StockInquireCode",
                    component: StockInquireCode,
                },
                {
                    name: "AddGoodsInfo",
                    path: "/AddGoodsInfo",
                    component: AddGoodsInfo
                },
                {
                    name: "UpdateGoodsInfo",
                    path: "/UpdateGoodsInfo/:item_id/:father_code",
                    component: UpdateGoodsInfo
                },
                {
                    name: "DetailedGoodsInfo",
                    path: "/DetailedGoodsInfo",
                    component: DetailedGoodsInfo
                },
                {
                    name: "SalesReturnsTH",
                    path: "/SalesReturnsTH",
                    component: SalesReturnsTH
                },
                {
                    name: "ReturnedGoodsTH",
                    path: "/ReturnedGoodsTH",
                    component: ReturnedGoodsTH
                },
                {
                    name: "Supplier",
                    path: "/Supplier",
                    component: Supplier
                },
                {
                    name: "Customer",
                    path: "/Customer",
                    component: Customer
                },
                {
                    name: "SupplyInsert",
                    path: "/SupplyInsert",
                    component: SupplyInsert
                },
                {
                    name: "CustomerInsert",
                    path: "/CustomerInsert",
                    component: CustomerInsert
                },
                {
                    name: "SupplyUpdate",
                    path: "/SupplyUpdate",
                    component: SupplyUpdate
                },
                {
                    name: "CustomerUpdate",
                    path: "/CustomerUpdate",
                    component: CustomerUpdate
                },
                {
                    name: "WareHouse",
                    path: "/WareHouse",
                    component: WareHouse
                },
                {
                    name: "WareArea",
                    path: "/WareArea",
                    component: WareArea
                },
                {
                    name: "supplyXiang",
                    path: "/supplyXiang",
                    component: supplyXiang
                },
                {
                    name: "CustomerXiang",
                    path: "/CustomerXiang",
                    component: CustomerXiang
                },
                {
                    name: "WareHouseXiang",
                    path: "/WareHouseXiang",
                    component: WareHouseXiang
                },
                {
                    name: "ProjectBackground",
                    path: "/ProjectBackground",
                    component: ProjectBackground
                }
            ]
        },

    ]
})

router.beforeEach((to, from, next) => {
    if (to.path == '/login') {
        next();
    } else {
        var token = sessionStorage.getItem('token');
        if (!token) {
            next('/login');
        } else {
            next();
        }
    }
})

export default router