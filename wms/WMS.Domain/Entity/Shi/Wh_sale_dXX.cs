using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Shi
{
    public class Wh_sale_dXX
    {

        public string sale_code { get; set; }
        public string item_name { get; set; }
        public string item_code { get; set; }
        public string item_type_name { get; set; }
        public string model_code { get; set; }
        public string unit { get; set; }
        public Decimal inbill3_num { get; set; }
        public Decimal outbill_num { get; set; }
        public Decimal inbill_price { get; set; }
        public string remark11 { get; set; }

        public Decimal change { get; set; }
        public string cw { get; set; }
        public Decimal zong { get; set; }

        public Decimal zm { get; set; }
        public Decimal yksl { get; set; }
        public string pdzt { get; set; }
        public string ccw { get; set; }
        public string rcw { get; set; }
    }
}
