﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Shi
{
    public class Wh_outbill_dXX
    {
        [Key]
        public int outbill_d_id { get; set; }
        public string item_name { get; set; }
        public string item_code { get; set; }
        public string model_code { get; set; }
        public string unit { get; set; }
        public string area_code { get; set; }
        public Decimal sale_price { get; set; }
        public Decimal sale_num { get; set; }
        public Decimal zong { get; set; }
        public string batch_no { get; set; }
        public string remark { get; set; }
        public string inbill_code { get; set; }

        public Decimal outbill_num { get; set; }
        public string item_type_name { get; set; }

        public Decimal wei { get; set; }
        public Decimal ku { get; set; }
    }
}