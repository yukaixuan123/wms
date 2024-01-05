using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Shi
{
    public class Wh_transfer_dXX
    {
        public int transfer_d_id { get; set; }
        public string item_code { get; set; }
        public string item_type_name { get; set; }
        public string transfer_code { get; set; }
        public string item_name { get; set; }
        public string model_code { get; set; }
        public string unit { get; set; }
        public string outarea_code { get; set; }
        public string inarea_code { get; set; }
        public string remark { get; set; }
        public decimal out_num { get; set; }
        public decimal in_num { get; set; }
        public decimal inbill_price { get; set; }

    }
}
