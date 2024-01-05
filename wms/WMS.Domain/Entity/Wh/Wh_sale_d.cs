using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    /// <summary>
    /// 销售明细表
    /// </summary>
    public class Wh_sale_d
    {
        public int sale_codeId { get; set; }
        public string sale_code { get; set; }
        public string item_name { get; set; }
        public string item_code { get; set; }
        public string model_code { get; set; }
        public string unit { get; set; }
        public string item_type_name { get; set; }
        public Decimal inbill3_num { get; set; }
        public Decimal return_num { get; set; }
        public Decimal outbill_num { get; set; }
        public Decimal sale_price { get; set; }
        public string remark { get; set; }
        public string is_del { get; set; }

    }
}
