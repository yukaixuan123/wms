﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Cm
{
    public class InventoryRecords
    {
        public int inventory_h_id { get; set; }
        public string inventory_code { get; set; }
        public string ware_code { get; set; }
        public string inventory_type { get; set; }
        public string sure_man { get; set; }
        public DateTime sure_date { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
        public Decimal total_buy_num { get; set; }
        public Decimal total_price { get; set; }
        public Decimal total_y_num { get; set; }
        public Decimal total_k_num { get; set; }
        public Decimal total_y_price { get; set; }
        public Decimal total_k_price { get; set; }
        public DateTime begin_date { get; set; }
        public DateTime end_date { get; set; }
        public string names { get; set; }
        public string zt { get; set; }
        public string sure_state { get; set; }

        public string item_code { get; set; }
    }
}
