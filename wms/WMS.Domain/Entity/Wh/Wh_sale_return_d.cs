using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    /// <summary>
    /// 退货材料明细
    /// </summary>
    public class Wh_sale_return_d
    {
        public int sr_codeId { get; set; }
        public string sr_code { get; set; }
        public string item_code { get; set; }
        public string item_name { get; set; }
        public Decimal inbill3_num { get; set; }
        public Decimal return_num { get; set; }
        public Decimal return_money { get; set; }

        public string ware_code { get; set; }
        public string area_code { get; set; }
        public string batch_no { get; set; }
        public Decimal sale_price { get; set; }
        public string is_del { get; set; }

    }
}
