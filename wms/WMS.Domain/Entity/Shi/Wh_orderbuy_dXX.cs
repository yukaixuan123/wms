using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Shi
{
    /// <summary>
    /// 进货订单明细
    /// </summary>
    public class Wh_orderbuy_dXX
    {
        public string buy_code { get; set; }
        public string item_name { get; set; }
        public string item_code { get; set; }
        public string item_type_name { get; set; }
        public string model_code { get; set; }
        public string unit { get; set; }
        public Decimal buy_num { get; set; }
        public Decimal inbill_num { get; set; }
        public Decimal inbill_price { get; set; }
        public string remark11 { get; set; }

        public Decimal change { get; set; }
        public string cw { get; set; }
        public Decimal zong { get; set; }
    }
}
