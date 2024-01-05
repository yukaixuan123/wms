
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    public class Wh_GoodsReturn_dXX
    {
        public string returns_code { get; set; }
        public string item_name { get; set; }
        public string item_code { get; set; }
        public string item_type_name { get; set; }
        public string model_code { get; set; }
        public string unit { get; set; }
        public Decimal inbill3_num { get; set; }
        public Decimal return_goods_num { get; set; }
        public Decimal buy_num { get; set; }
        
        public Decimal inbill_price { get; set; }
        public string remark { get; set; }
        public Decimal change { get; set; }
        public string cw { get; set; }

        public string user { get; set; }
        public string zong { get; set; }

        public string buy_code { get; set; }


    }
}
