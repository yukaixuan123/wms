using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Ku
{
    /// <summary>
    /// 盘点明细表
    /// </summary>
    public class Wh_inventory_d
    {
        public int inventory_d_id { get; set; }
        public string inventory_code { get; set; }
        public string item_code { get; set; }
        public string model_code { get; set; }
        public string unit { get; set; }
        public string item_type { get; set; }
        public Decimal account_num { get; set; }
        public string area_code { get; set; }
        public Decimal inventory_num { get; set; }
        public Decimal break_even_num { get; set; }
        public string inventory_state { get; set; }
        public Decimal inbill_price { get; set; }
        public string remark { get; set; }
    }
}
