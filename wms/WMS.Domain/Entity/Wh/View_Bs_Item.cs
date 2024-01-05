﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    public class View_Bs_Item
    {

        public int item_id { get; set; }
        public string item_code { get; set; }//货品编号
        public string item_name { get; set; }//货品名称
        public string item_type { get; set; }//入库类型
        public int sort_code { get; set; }//排序
        public string inbill_state { get; set; }//入库状态
        public string model_code { get; set; }//规格型号
        public Decimal outbill_price { get; set; }//出库参考价
        public Decimal inbill_price { get; set; }//入库参考价
        public int item_up { get; set; }//货品上限
        public int item_down { get; set; }//货品下限
        public decimal below_down { get; set; }//低于下限
        public decimal above_up { get; set; }//高于上限
        public string unit { get; set; }//单位
        public string is_del { get; set; }//逻辑删除
        public Decimal item_inventory { get; set; }//库存

        public string item_type_code { get; set; }//货品类型编号

        public string item_type_name { get; set; }//货品类型名称

    }
}